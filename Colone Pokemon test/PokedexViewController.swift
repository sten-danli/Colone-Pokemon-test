//
//  PokedexViewController.swift
//  Colone Pokemon test
//
//  Created by Dan Li on 29.09.19.
//  Copyright © 2019 Dan Li. All rights reserved.
//

import UIKit

class PokedexViewController: UIViewController
{

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
    

}
