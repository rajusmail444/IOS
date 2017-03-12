//
//  ViewController.swift
//  AlertAndAction
//
//  Created by Rajesh Billakanti on 25/02/17.
//  Copyright © 2017 RAjaY. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   

    @IBAction func simpleAlert(_ sender: Any) {
        print("simpleAlert:sender:\((sender as AnyObject).tag)")
        alertControllerAction(sender as AnyObject)
    }

    @IBAction func alertWithTextField(_ sender: Any) {
        alertControllerAction(sender as AnyObject)
    }
    
    @IBAction func alertWithLoginForm(_ sender: Any) {
        alertControllerAction(sender as AnyObject)
    }
    
    @IBAction func alertWithmultipleButtons(_ sender: Any) {
        alertControllerAction(sender as AnyObject)
    }
    
    @IBAction func actionSheet(_ sender: Any) {
        alertControllerAction(sender as AnyObject)
    }
    
    func alertControllerAction(_ sender : AnyObject){
        print("alertControllerAction:sender:\(sender.tag!)")
        if(sender.tag == 0){
            let alertController = UIAlertController(title: "Default AlertController", message: "A standard alert", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action : UIAlertAction) in
                print("you have pressed the Cancel button")
            })
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action : UIAlertAction) in
                print("you have pressed the Ok button")
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }else if(sender.tag == 1){
            var loginTextField : UITextField?
            let alertController = UIAlertController(title: "Default AlertController", message: "UIAlertController With TextField", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action : UIAlertAction) in
                print("you have pressed the Cancel button")
            })
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action : UIAlertAction) in
                print("you have pressed the Ok button")
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            alertController.addTextField(configurationHandler: {(textField) in
                //print("textField: \(textField)")
                loginTextField = textField
                loginTextField?.placeholder = "Enter your login ID  "
            })
            self.present(alertController, animated: true, completion: nil)
            
        }else if(sender.tag == 2){
            var loginTextField : UITextField?
            var passwordTextField : UITextField?
            let alertController = UIAlertController(title: "Default AlertController", message: "UIAlertController With TextField", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action : UIAlertAction) in
                print("you have pressed the Cancel button")
            })
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action : UIAlertAction) in
                print("you have pressed the Ok button")
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            alertController.addTextField(configurationHandler: {(textField) in
                //print("textField: \(textField)")
                loginTextField = textField
                loginTextField?.placeholder = "User ID"
            })
            alertController.addTextField(configurationHandler: {(textField) in
                //print("textField: \(textField)")
                passwordTextField = textField
                passwordTextField?.placeholder = "Password"
                passwordTextField?.isSecureTextEntry = true
            })
            self.present(alertController, animated: true, completion: nil)
        
        }else if(sender.tag == 3){
            let alertController = UIAlertController(title: "Default AlertController", message: "A standard alert", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action : UIAlertAction) in
                print("you have pressed the Cancel button")
            })
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action : UIAlertAction) in
                print("you have pressed the Ok button")
            })
            let ignoreAction = UIAlertAction(title: "Ignore", style: .default, handler: {(action : UIAlertAction) in
                print("you have pressed the ignore button")
            })
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action : UIAlertAction) in
                print("you have pressed the delete button")
            })
            alertController.addAction(ignoreAction)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)
            
        }else if(sender.tag == 4){
            let alertController = UIAlertController(title: "Default AlertController", message: "A standard alert", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action : UIAlertAction) in
                print("you have pressed the Cancel button")
            })
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: {(action : UIAlertAction) in
                print("you have pressed the Ok button")
            })
            let ignoreAction = UIAlertAction(title: "Ignore", style: .default, handler: {(action : UIAlertAction) in
                print("you have pressed the ignore button.")
            })
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action : UIAlertAction) in
                print("you have pressed the delete button.")
            })
            alertController.addAction(ignoreAction)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}

