//
//  SignUpPageViewController.swift
//  Project Group 7
//
//  Created by Johnny Sun on 9/19/18.
//  Copyright © 2018 Johnny Sun. All rights reserved.
//

import UIKit
import CloudKit

class SignUpPageViewController: UIViewController {
    @IBOutlet weak var ReturnHomeButton: UIButton!

    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBAction func SignUp(_ sender: UIButton) {
        if !(Username.text?.isEmpty)! && !(Password.text?.isEmpty)!{
            UserProfileRecord.setValue(Username.text!, forKey: Password.text!)
        }
        else{
            
        }
    }
    
}
