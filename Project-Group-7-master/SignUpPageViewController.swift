//
//  SignUpPageViewController.swift
//  Project Group 7
//
//  Created by Johnny Sun on 9/19/18.
//  Copyright © 2018 Johnny Sun. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class SignUpPageViewController: UIViewController {
    @IBOutlet weak var ReturnHomeButton: UIButton!

    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBAction func SignUp(_ sender: UIButton) {
        if !(FirstName.text?.isEmpty)! && !(LastName.text?.isEmpty)! && !(Email.text?.isEmpty)! && !(Username.text?.isEmpty)! && !(Password.text?.isEmpty)!{
            let smtpSession = MCOSMTPSession()
            smtpSession.hostname = "smtp.gmail.com"
            smtpSession.username = "spartandrive.cmpe137@gmail.com"
            smtpSession.password = "2018cmpe-137"
            smtpSession.port = 465
            smtpSession.authType = MCOAuthType.saslPlain
            smtpSession.connectionType = MCOConnectionType.TLS
            smtpSession.connectionLogger = {(connectionID, type, data) in
                if data != nil {
                    if let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue){
                        NSLog("Connectionlogger: \(string)")
                    }
                }
            }
            
            let builder = MCOMessageBuilder()
            builder.header.to = [MCOAddress(displayName: "Admin", mailbox: "\(Email.text!)")]
            builder.header.from = MCOAddress(displayName: "Spartan Drive", mailbox: "spartandrive.cmpe137@gmail.com")
            builder.header.subject = "Email Comfirmation"
            builder.textBody = "Hi \(FirstName.text!) \(LastName.text!), \n You have successfully signed up for Spartan Drive! Your username is \(Username.text!)"
            
            let rfc822Data = builder.data()
            let sendOperation = smtpSession.sendOperation(with: rfc822Data)
            sendOperation?.start { (error) -> Void in
                if (error != nil) {
                    NSLog("Error sending email: \(error)")
                } else {
                    var NEWUID: String?
                    NSLog("Successfully sent email!")
                    //create user using email as login
                    Auth.auth().createUser(withEmail: self.Email.text!, password: self.Password.text!, completion: { (User, signuperror) in
                        if signuperror != nil {
                            print(signuperror!)
                            return
                        }
                        NEWUID = User?.user.uid
                        let userReference = ref.child("users").child("\(String(describing: NEWUID!))") //unique id for each user
                        let user = ["name": self.Username.text!, "email": self.Email.text!] //add into db
                        userReference.updateChildValues(user, withCompletionBlock: { (DBERROR, ref) in
                            if DBERROR != nil{
                                print(DBERROR!)
                                return
                            }
                        })
                        let defaultColor = ["BackGround Color": "Default"] //add into db
                        userReference.updateChildValues(defaultColor, withCompletionBlock: { (DBERROR, ref) in
                            if DBERROR != nil{
                                print(DBERROR!)
                                return
                            }
                        })
                    })
                
                
                   // UserProfileRecord.setValue(self.Username.text!, forKey: self.Password.text!) //TODO update with firebase
                }
            }
          
        }
        else{
            
        }
    }
   
}
