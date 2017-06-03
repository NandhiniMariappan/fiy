//
//  ViewController.swift
//  dataset
//
//  Created by Deepak on 02/06/2016 A.
//  Copyright © 2017 Adyog. All rights reserved.
//

import UIKit
import fiy

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        let ref = fiy()
        print("ref",ref)
        ref.doSomething()
        
        // Do any additional setup after loading the view, typically from a nib.
        //print("view did load")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

