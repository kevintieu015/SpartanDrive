//
//  MainMenuViewController.swift
//  Project Group 7
//
//  Created by Johnny Sun on 9/21/18.
//  Copyright © 2018 Johnny Sun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
var Color: String?
class MainMenuViewController: UIViewController{
    
    override func viewWillAppear(_ animated: Bool) {
        MusicHelper.sharedHelper.playBackgroundMusic()
        Database.database().reference().child("users").child("\(String(describing: Auth.auth().currentUser!.uid))").child("BackGround Color")
            .observe(.value, with: {(DataSnapshot) in
                let XXX = DataSnapshot.value as! String
                Color = XXX 
                print(XXX)
                if Color == "Default"{
                    super.view.backgroundColor = #colorLiteral(red: 0, green: 0.6557540298, blue: 0.9530157447, alpha: 1)
                }else if Color == "Tan"{
                    super.view.backgroundColor = #colorLiteral(red: 0.9935336709, green: 0.9783670306, blue: 0.8132466674, alpha: 1)
                }
            }, withCancel: nil)
        super.viewWillAppear(animated);
        self.navigationController?.setToolbarHidden(true, animated: animated) //hide Tool bar
    }
    @IBOutlet weak var SearchByFilename: UIButton!
    
    @IBOutlet weak var MainMenuLabel: UILabel!
    @IBOutlet weak var LogoutButton: UIButton!

    @IBAction func Logout(_ sender: Any) {
        do{
            try Auth.auth().signOut() //try signing out
            self.performSegue( withIdentifier: "Logout", sender: self) //segue show detail so there is no back button
        } catch let logouterror {
            print(logouterror) //show error if something is wrong
        }
        
    }
    
    
}
