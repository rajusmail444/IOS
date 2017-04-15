
//
//  FirstViewController.swift
//  NavigationUsingCode
//
//  Created by Rajesh Billakanti on 14/04/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //function to instanciate story board and FirstViewController
    static func storyboardInstance() -> FirstViewController{
        print("inside storyboardInstance of FirstViewController")
        let storyboard = UIStoryboard(name: "FirstViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as! FirstViewController
        //return storyboard.instantiateViewController(withIdentifier: "FirstViewController") as! FirstViewController
    }

    //function to pop view controller
    @IBAction func onClickOfBack(_ sender: Any) {
        print("inside onClickOfDismiss of FirstViewController")
        _ = navigationController?.popViewController(animated: true)
    }
    
    ////function to present view controller
    @IBAction func navigateToSecond(_ sender: Any) {
        print("inside navigateToSecond of FirstViewController")
        let secondViewController = SecondViewController.storyboardInstance()
        print("Back to navigateToSecond of FirstViewController: secondViewController: \(secondViewController)")
        present(secondViewController, animated: true, completion: nil)
    }
    //function to pop to root view controller
    @IBAction func navigateToHome(_ sender: Any) {
        print("inside navigateToHome of FirstViewController")
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
