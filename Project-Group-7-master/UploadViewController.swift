//
//  UploadViewController.swift
//  Project Group 7
//
//  Created by Johnny Sun on 10/9/18.
//  Copyright © 2018 Johnny Sun. All rights reserved.
//

import UIKit
import Photos
import FirebaseDatabase
import Firebase
import FirebaseAuth
import FirebaseStorage


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
let imagePicker = UIImagePickerController()
    let storageRef = Storage.storage().reference()
    override func viewWillAppear(_ animated: Bool) {
        Database.database().reference().child("users").child("\(String(describing: Auth.auth().currentUser!.uid))").child("BackGround Color")
            .observe(.value, with: {(DataSnapshot) in
                let XXX = DataSnapshot.value as! String
                Color = XXX
                print(XXX)
            }, withCancel: nil)
        if Color == "Default"{
            super.view.backgroundColor = #colorLiteral(red: 0, green: 0.6557540298, blue: 0.9530157447, alpha: 1)
        }else if Color == "Tan"{
            super.view.backgroundColor = #colorLiteral(red: 0.9935336709, green: 0.9783670306, blue: 0.8132466674, alpha: 1)
        self.ShareLabel.textColor = UIColor.black
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Share2Public.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1);
        Share2Public.layer.cornerRadius = 16.0;
        
        Choose_From_Lib.layer.cornerRadius = 0.1 * Choose_From_Lib.bounds.size.width
        Choose_From_Lib.clipsToBounds = true
        
        UploadButton.layer.cornerRadius = 0.2 * UploadButton.bounds.size.width
        UploadButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var UPLOADMENU: UILabel!
    
    @IBOutlet weak var Choose_From_Lib: UIButton!
    
    @IBOutlet weak var UploadButton: UIButton!
    
    
    @IBOutlet weak var ShareLabel: UILabel!
    @IBOutlet weak var PhotoName: UITextField!
    @IBOutlet weak var Sample_Display: UIImageView!
    
    @IBOutlet weak var Share2Public: UISwitch!
    
    @IBAction func UploadtoFirebase(_ sender: Any) {
        
        var data = UIImageJPEGRepresentation(Sample_Display.image!, 0.7)
        let filePath = "\(Auth.auth().currentUser!.uid)/\("\(String(describing: PhotoName.text!))")"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        self.storageRef.child(filePath).putData(data!, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.storageRef.child(filePath).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("an error occurred!")
                    
                    return
                }
                let D_URL = downloadURL.absoluteString
                let userReference = ref.child("users").child("\(Auth.auth().currentUser!.uid)").child("Photos").child("\(self.PhotoName.text!)")
                let user = ["ImageName": "\(self.PhotoName.text!)", "URL": D_URL] //add into db
                userReference.updateChildValues(user, withCompletionBlock: { (DBERROR, ref) in
                    if DBERROR != nil{
                        print(DBERROR!)
                        return
                    }
                })
            }
           
        }
        if Share2Public.isOn{
            let filePath = "Public/\("\(String(describing: PhotoName.text!))")"
            self.storageRef.child(filePath).putData(data!, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
            
            self.storageRef.child(filePath).downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print(error!)
                    
                    return
                }

                let PD_URL = downloadURL.absoluteString
 
                let PublicRef = ref.child("users").child("Public").child("Photos").child("\(self.PhotoName.text!)")
                print(PublicRef)
                let user = ["ImageName": "\(self.PhotoName.text!)", "URL": PD_URL] //add into db
            PublicRef.updateChildValues(user, withCompletionBlock: { (DBERROR, ref) in
                if DBERROR != nil{
                    print(DBERROR!)
                    return
                }
            })
        }//
    }
    }
    
    @IBAction func OpenPhotoLib(_ sender: Any) {
         openPhotoLibrary()
    }

    func openPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }

@objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print(info)
        // get the image
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        // do something with it
        Sample_Display.image = image
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }
}

