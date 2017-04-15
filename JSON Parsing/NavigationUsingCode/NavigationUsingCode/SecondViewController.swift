//
//  SecondViewController.swift
//  NavigationUsingCode
//
//  Created by Rajesh Billakanti on 14/04/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function to instanciate story board and SecondViewController
    static func storyboardInstance() -> SecondViewController{
        print("inside storyboardInstance of SecondViewController")
        let storyboard = UIStoryboard(name: "SecondViewController", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
    }
    
    //function to dismiss presented view controller
    @IBAction func onClickOfDismiss(_ sender: Any) {
        print("inside onClickOfBack of SecondViewController")
        //_ = navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //function to dismiss to root view controller
    @IBAction func navigateToHome(_ sender: Any) {
        print("inside navigateToHome of SecondViewController")
        view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}
