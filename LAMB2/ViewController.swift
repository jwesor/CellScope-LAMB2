//
//  ViewController.swift
//  LAMB2
//
//  Created by Fletcher Lab Mac Mini on 11/21/14.
//  Copyright (c) 2014 Fletchlab. All rights reserved.
//

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("launchCameraSession", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
