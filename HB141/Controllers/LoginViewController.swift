//
//  LoginViewController.swift
//  HB141
//
//  Created by Bailey Bercik on 3/5/17.
//  Copyright © 2017 International Human Trafficking Institute. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    

    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func login(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: Username.text!, password: Password.text!) {
            (user, error) in
            if error != nil {
                print("Login Unsuccessful")
            } else {
                print("Login Successful!!")
            }
        }
    }
    
    func loginExternal(credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential) {
            (user, error) in
            if error != nil {
                print("Login Unsuccessful")
            } else {
                print("Login Successful")
            }
        }
    }
}
