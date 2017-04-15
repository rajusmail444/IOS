//
//  HomeViewController.swift
//  NavigationUsingCode
//
//  Created by Rajesh Billakanti on 14/04/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function to instanciate main story board and home view controller
    static func storyboardInstance() -> HomeViewController{
        print("inside storyboardInstance of HomeViewController")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateInitialViewController() as! HomeViewController
    }
    //function navigates to first view controller using navigation controller
    @IBAction func NavigateToFirst(_ sender: Any) {
        print("inside NavigateToFirst of HomeViewController")
        let firstViewController = FirstViewController.storyboardInstance()
        print("Back to NavigateToFirst of HomeViewController: firstViewController: \(firstViewController)")
        navigationController?.pushViewController(firstViewController, animated: true)
    }

}
