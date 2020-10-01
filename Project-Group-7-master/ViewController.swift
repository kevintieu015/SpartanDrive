//
//  ViewController.swift
//  Project Group 7
//
//  Created by Johnny Sun on 9/19/18.
//  Copyright © 2018 Johnny Sun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
let ref = Database.database().reference(fromURL: "https://spartandrive-73d94.firebaseio.com/") //firebase
class ViewController: UIViewController {
    @IBOutlet weak var Email_Input: UITextField!
    @IBOutlet weak var PasswordInput: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var SignUpButton: UIButton!

    override func viewDidLoad() {
      // MusicHelper.sharedHelper.playBackgroundMusic() //Music is optional i turned it off currently bc it is getting annoying
        if Auth.auth().currentUser?.uid == nil{
            do{
                try Auth.auth().signOut()
            } catch let logouterror {
                print(logouterror)
            }
        }
        LoginButton.layer.cornerRadius = 8
        LoginButton.clipsToBounds = true
        SignUpButton.layer.cornerRadius = 8
        SignUpButton.clipsToBounds = true
    }
    @IBAction func Login(_ sender: UIButton) {
        var email = Email_Input.text ?? "nada"
        var password = PasswordInput.text ?? "nada"
        //attempt sign in
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil{
                print(error) //if it didnt sign in print error
                return
            }
            else{
                self.performSegue( withIdentifier: "ToMain", sender: self) //if signed in segue
            }
        }
        
    }
    
}
