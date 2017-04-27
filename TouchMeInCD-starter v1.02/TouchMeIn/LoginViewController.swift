/*
* Copyright (c) 2014 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import CoreData
import LocalAuthentication

class LoginViewController: UIViewController {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    //MyKeychainWrapper holds a reference to the Objective-C KeychainWrapper class.
    let MyKeychainWrapper = KeychainWrapper()
    
    //below two constants will be used to determine if the Login button is being used to create some credentials, or to log in; the loginButton outlet will be used to update the title of the button depending on that same state.
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    let defaults = UserDefaults.standard
    //The context references an authentication context, which is the main player in Local Authentication.
    var context = LAContext()
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createInfoLabel: UILabel!
    @IBOutlet weak var touchIDButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // You first check hasLoginKey to see if you’ve already stored a login for this user.
        let hasLogin = defaults.bool(forKey: "hasLoginKey")
        
        // If so, change the button’s title to Login, update its tag to loginButtonTag, and hide createInfoLabel, which contains the informative text “Start by creating a username and password“. If you don’t have a stored login for this user, set the button label to Create and display createInfoLabel to the user.
        if hasLogin {
            loginButton.setTitle("Login", for: UIControlState.normal)
            loginButton.tag = loginButtonTag
            createInfoLabel.isHidden = true
        } else {
            loginButton.setTitle("Create", for: UIControlState.normal)
            loginButton.tag = createLoginButtonTag
            createInfoLabel.isHidden = false
        }
        
        // Finally, you set the username field to what is saved in NSUserDefaults to make logging in a little more convenient for the user.
        if let storedUsername = defaults.value(forKey: "username") as? String {
            usernameTextField.text = storedUsername as String
        }
        
        //Below method can help to check whether the device can implement Touch ID authentication.
        touchIDButton.isHidden = true
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            touchIDButton.isHidden = false
        }
    }
    // MARK: - Login with TouchID
    @IBAction func touchIDLoginAction(_ sender: UIButton) {
        // Once again, you’re using canEvaluatePolicy(_:error:) to check whether the device is Touch ID capable.
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error:nil) {
            
            // If the device does support Touch ID, you then use evaluatePolicy(_:localizedReason:reply:) to begin the policy evaluation — that is, prompt the user for Touch ID authentication. evaluatePolicy(_:localizedReason:reply:) takes a reply block that is executed after the evaluation completes.
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: "Logging in with Touch ID") {
                                    (success, evaluateError) in
                                    //nside the reply block, you handling the success case first. By default, the policy evaluation happens on a private thread, so your code jumps back to the main thread so it can update the UI. If the authentication was successful, you call the segue that dismisses the login view.
                                    if (success) {
                                        DispatchQueue.main.async {
                                            // User authenticated successfully, take appropriate action
                                            self.performSegue(withIdentifier: "dismissLogin", sender: self)
                                        }
                                    } else {
                                        
                                        if let error: LAError = evaluateError as! LAError? {
                                            var message: String
                                            var showAlert : Bool
                                            //Now for the “failure” cases. You use a switch statement to set appropriate error messages for each error case, then present the user with an alert view.
                                            switch error {
                                                
                                            case LAError.authenticationFailed:
                                                message = "There was a problem verifying your identity."
                                                showAlert = true
                                            case LAError.userCancel:
                                                message = "You pressed cancel."
                                                showAlert = true
                                            case LAError.userFallback:
                                                message = "You pressed password."
                                                showAlert = true
                                            default:
                                                showAlert = true
                                                message = "Touch ID may not be configured"
                                            }
                                            
                                            if showAlert {
                                                let alertView = UIAlertController(title: "Error",
                                                                                  message: message as String, preferredStyle:.alert)
                                                let okAction = UIAlertAction(title: "Darn!", style: .default, handler: nil)
                                                alertView.addAction(okAction)
                                                self.present(alertView, animated: true, completion: nil)
                                            }
                                        }
                                    }
                                    
            }
        } else {
            // If canEvaluatePolicy(_:error:) failed, you display a generic alert. In practice, you should really evaluate and address the specific error code returned, which could include any of the following:
            //LAErrorTouchIDNotAvailable: the device isn’t Touch ID-compatible.
            //LAErrorPasscodeNotSet: there is no passcode enabled as required for Touch ID
            //LAErrorTouchIDNotEnrolled: there are no fingerprints stored.
            let alertView = UIAlertController(title: "Error",
                                              message: "Touch ID not available" as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Darn!", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    // MARK: - Action for checking username/password
    @IBAction func loginAction(_ sender: AnyObject) {
        // If either the username or password is empty, then present an alert to the user and return from the method.
        if (usernameTextField.text == "" || passwordTextField.text == "") {
            let alertView = UIAlertController(title: "Login Problem",
                                              message: "Wrong username or password." as String, preferredStyle:.alert)
            let okAction = UIAlertAction(title: "Foiled Again!", style: .default, handler: nil)
            alertView.addAction(okAction)
            self.present(alertView, animated: true, completion: nil)
            return;
        }
        
        // Dismiss the keyboard if it’s visible.
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        // If the login button’s tag is createLoginButtonTag, then proceed to create a new login.
        if sender.tag == createLoginButtonTag {
            // Next, you read hasLoginKey from NSUserDefaults which indicates whether a password has been saved to the Keychain. If the username field is not empty and hasLoginKey indicates no login has already been saved, then you save the username to NSUserDefaults.
            let hasLoginKey = defaults.bool(forKey: "hasLoginKey")
            if hasLoginKey == false {
                defaults.set(self.usernameTextField.text, forKey: "username")
            }
            
            // You then use mySetObject and writeToKeychain to save the password text to Keychain. You then set hasLoginKey in NSUserDefaults to true to indicate that a password has been saved to the keychain. You set the login button’s tag to loginButtonTag so that it will prompt the user to log in the next time they run your app, rather than prompting the user to create a login. Finally, you dismiss loginView.
            MyKeychainWrapper.mySetObject(passwordTextField.text, forKey:kSecValueData)
            MyKeychainWrapper.writeToKeychain()
            defaults.set(true, forKey: "hasLoginKey")
            defaults.synchronize()
            loginButton.tag = loginButtonTag
            
            performSegue(withIdentifier: "dismissLogin", sender: self)
        } else if sender.tag == loginButtonTag {
            // If the user is logging in (as indicated by loginButtonTag), you call checkLogin(_:password:) to verify the user-provided credentials; if they match then you dismiss the login view.
            if checkLogin(username: usernameTextField.text!, password: passwordTextField.text!) {
                performSegue(withIdentifier: "dismissLogin", sender: self)
            } else {
                // If the login authentication fails, then present an alert message to the user.
                let alertView = UIAlertController(title: "Login Problem",
                                                  message: "Wrong username or password." as String, preferredStyle:.alert)
                let okAction = UIAlertAction(title: "Foiled Again!", style: .default, handler: nil)
                alertView.addAction(okAction)
                self.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    func checkLogin(username: String, password: String ) -> Bool {
        if password == MyKeychainWrapper.myObject(forKey: "v_Data") as? String &&
            username == defaults.value(forKey: "username") as? String {
            return true
        } else {
            return false
        }
    }
    
    
    
}
