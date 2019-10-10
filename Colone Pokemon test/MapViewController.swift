

import UIKit
import MapKit


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate
{
    
    @IBOutlet weak var mapView: MKMapView!
    var pokemons : [Pokemon] = []   //pokemons是一个一个空的[Pokemon]类型的array
    var manager = CLLocationManager()//CLLocationManager定位管理者//随时得知用户位置
    var updateConunt = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        pokemons = getAllPokemon()
        
        manager.delegate = self
        //manager.desiredAccuracy = kCLLocationAccuracyBest//设定跟踪位置准确程度
       // manager.activityType = .automotiveNavigation//设定行动活动模式//.后面还有4种其他模式例如步行模式，运动模式等。
        manager.startUpdatingLocation()//开app后显示用户所在地点////用户当前地址变化跟踪,开机时便得显示到用户当前地址//此语句将触动func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])

        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse//第一次app运行时如果authorizationStatus显示用户同意“随时得知用户位置”的协议👇
        {
            setup()//就直接运行setup（）
        }
        else//如果用户第一次运行时NO同意“随时得知用户位置”的协议👇
        {
            manager.requestWhenInUseAuthorization()//就提出现实问用户是否同意协议，同意或不同意后做什么交给👇func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)来管理。
        }
    }
   
    //用来管理同意或不同意协议后做什么。
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedWhenInUse//同意的话就用行setup（）
        {
            setup()
        }
    }
    
    func setup()
    {
        mapView.delegate = self// 设置地图的代理对象为当前的视图控制器对象
        mapView.showsUserLocation = true //获取用户地址
       // manager.startUpdatingHeading()    //开始更新指向
        //每五秒钟创立新的pokemon在地图上
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            if let center = self.manager.location?.coordinate//先找到我们的当前地址
            {
                var annoCoord = center//把当前地址交给新创建的annoCoord
                annoCoord.latitude += (Double.random(in: 0...400)-100.0)/90000.0 //annoCoord在离我们当前centerc位置的基础上随机改变
                annoCoord.longitude += (Double.random(in: 0...400)-100.0)/90000.0
                
                if let pokemon = self.pokemons.randomElement()//随机调出的存储的pokemon
                {
                    //建立用户自定义的annotationView PokeAnnotation.swift
                    let anno = PokeAnnotation(coord: annoCoord, pokemon: pokemon)
                    self.mapView.addAnnotation(anno)
                    
                }
            }
        }
    }
    
    //个人制定大头针样式,//此功能，可在其中调用自定义视图　//We have this function where we decide what the custom view is for an anntation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let annoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)//得到大头针
        if annotation is MKUserLocation //如果anntation是那个初始化原点的话（就是user自己）//if的声明代表如果annotation是user自己就显示if中内容，else的话就显示else中的自定义内容
        {
            annoView.image = UIImage(named: "me")
            
        }
        else
        {
            if let pokeAnnotation = annotation as? PokeAnnotation
            {
                if let imageName = pokeAnnotation.pokemon.imageName
                {
                    annoView.image = UIImage(named: imageName)
                }
            }
        }
        var frame = annoView.frame
        frame.size.height = 50.0
        frame.size.width = 50.0
        annoView.frame = frame
        
        return annoView
    }
    
    
    //用户当前地址变化跟踪,开机时便得显示到用户当前地址//
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if updateConunt < 3 {
            if let center = manager.location?.coordinate {
                let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
                mapView.setRegion(region, animated: false)
            }
            updateConunt += 1
        } else {
            manager.stopUpdatingLocation()
        }
    }

    @IBAction func centerTapped(_ sender: Any)//按下此Button后显示你当前的地址
    {
        if let center = manager.location?.coordinate
        {
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
            mapView.setRegion(region, animated: false)
        }
    }
//    点到annotation出发什么
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        if view.annotation is MKUserLocation {
            // 如果点击用户自己的大头像的话，显示个人人物设定
            self.performSegue(withIdentifier: "userViewcontroller", sender: nil)
            
        } else {
            if let center = manager.location?.coordinate {
                if let pokeCenter = view.annotation?.coordinate {
                    let region = MKCoordinateRegion(center: pokeCenter, latitudinalMeters: 200, longitudinalMeters: 200)
                    mapView.setRegion(region, animated: false)
                    
                    if let pokeAnnotation = view.annotation as? PokeAnnotation {
                        if let pokemonName = pokeAnnotation.pokemon.name {
                            if mapView.visibleMapRect.contains(MKMapPoint(center)) {//如果annotaion在user center范围内
                                // CAUGHT
                                pokeAnnotation.pokemon.caught = true
                                (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
                                let alertVC = UIAlertController(title: "Neu unbekant entdeckt!", message: "Name: \(pokemonName)", preferredStyle: .alert)
                                let fangenAction = UIAlertAction(title: "Fangen es!", style: .default) { (action) in
                                    self.performSegue(withIdentifier: "fightingView", sender: nil)
                                }
                                let okAction = UIAlertAction(title: "Passen", style: .default, handler: nil)
                                alertVC.addAction(fangenAction)
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                            } else {
                                // TOO FAR
                                let alertVC = UIAlertController(title: "Oops!", message: "You were too far away from this \(pokemonName) to catch it. Try moving closer!", preferredStyle: .alert)
                                
                                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alertVC.addAction(okAction)
                                present(alertVC, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
  
}


