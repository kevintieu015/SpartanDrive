//
//  InvitationPageViewController.swift
//  Project Group 7
//
//  Created by Johnny Sun on 11/27/18.
//  Copyright © 2018 Johnny Sun. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class InvitationPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var ReceiverEmailInput: UITextField!
    
    @IBOutlet weak var SendButton: UIButton!
    
    @IBAction func SendEmail(_ sender: Any) {
        if(!(ReceiverEmailInput.text?.isEmpty)!){
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
        builder.header.to = [MCOAddress(displayName: "Admin", mailbox: "\(ReceiverEmailInput.text!)")]
        builder.header.from = MCOAddress(displayName: "Spartan Drive", mailbox: "spartandrive.cmpe137@gmail.com")
        builder.header.subject = "Email Comfirmation"
            builder.textBody = "Hi, User: \(String(describing: Auth.auth().currentUser!.email!)) is inviting you to Join Spartan Drive!"
        
        let rfc822Data = builder.data()
        let sendOperation = smtpSession.sendOperation(with: rfc822Data)
        sendOperation?.start { (error) -> Void in
            if (error != nil) {
                NSLog("Error sending email: \(error)")
            } else {
                NSLog("Successfully sent email!")
        
            }
        }
        }
        
    }
    /* Written By Kevin Tieu */

}
