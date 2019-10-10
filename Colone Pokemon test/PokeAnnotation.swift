//
//  PokeAnnotation.swift
//  Colone Pokemon test
//
//  Created by Dan Li on 09.10.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit
import MapKit
class PokeAnnotation: NSObject, MKAnnotation {
    var coordinate : CLLocationCoordinate2D //获取当前经纬度
    var pokemon : Pokemon

     init(coord:CLLocationCoordinate2D, pokemon:Pokemon) {
        self.coordinate = coord
        self.pokemon = pokemon
    }
}

