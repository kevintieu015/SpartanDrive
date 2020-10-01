//
//  SearchFileView.swift
//  Project Group 7
//
//  Created by Johnny Sun on 10/7/18.
//  Copyright © 2018 Johnny Sun. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import Photos


var f = [Photos]()
var myIndex = 0
class SearchFileView:  UITableViewController, UISearchBarDelegate{
let storageRef = Storage.storage().reference()
var photos = [Photos]()
var filteredPhotos = [Photos]()//updated field
var User_set = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.setToolbarHidden(false, animated: animated) //Show Tool bar
    }

    @IBAction func SETPUBLIC(_ sender: Any) {
        if User_set == true{
            SWITCH.title = "User"
            User_set = false
            fetchPhoto()
           
            print("Switched to false")
        }
        else{
            SWITCH.title = "Public"
            User_set = true
            fetchPhoto()
            print("Switched to true")
        }
        print("working")
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var SWITCH: UIBarButtonItem!
    @IBOutlet var ImageTable: UITableView!
    @IBAction func DeleteImage(_ sender: UIButton) {
        if (User_set == false){
            
        }else{
        if let indexPath = self.tableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: self.tableView)){//get index from clicked the row where the button was clicked
            Database.database().reference().child("users").child("\(String(describing: Auth.auth().currentUser!.uid))").child("Photos").child("\(String(describing: tableView.cellForRow(at: indexPath)!.textLabel!.text!))").removeValue() //delete from DB
            /*delete Image from Storage*/
            storageRef.child("\(String(describing: Auth.auth().currentUser!.uid))/\(String(describing: tableView.cellForRow(at: indexPath)!.textLabel!.text!))").delete { (delete_error) in
                if delete_error != nil{
                    print(delete_error)
                }
            }
            self.photos.remove(at: indexPath.row) //remove from the array of photos
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic) //delete from table
            
        }
            print("Delete") //debug
            
        }
    }
    @IBAction func Download(_ sender: UIButton) {
         if let indexPath = self.tableView.indexPathForRow(at: sender.convert(CGPoint.zero, to: self.tableView)){ //get index from clicked the row where the button was clicked
            if let photoURL =  photos[indexPath.row].ImageURL { //get URL using index
                let url = URL(string: photoURL) //convert into URL type
                let Req = URLRequest(url: url! as URL) //convert into URLRequest Type
                URLSession.shared.dataTask(with: Req as URLRequest, completionHandler: {
                    (data, response, download_error) in
                    if download_error != nil{
                        print(download_error)
                        return
                    }
                    let image = UIImage(data: data!) //covert data to UIImage Type
                    if image == nil{ print("still fucked") } //debug
                    UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil) //save to photo lib
        }).resume()
            }
        }
    }
    @IBOutlet weak var SearchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        SearchBar.delegate = self
        // Setup the Search Controller
      fetchPhoto()
    }
    var searchActive : Bool = false
    
    func fetchPhoto(){
        self.photos.removeAll()
        var childstring: String?
        if User_set == true{
             childstring = "\(String(describing: Auth.auth().currentUser!.uid))"
        }
        else if User_set == false{
            print("SHOULD RELOAD")
            childstring = "Public"
        }
        Database.database().reference().child("users").child(childstring!).child("Photos").observe(.childAdded, with: {(DataSnapshot) in
            if let Dictionary = DataSnapshot.value as? [String: AnyObject]{
                let photo = Photos()
                //photo.setValuesForKeys(Dictionary)
                photo.ImageURL = Dictionary["URL"] as? String
                photo.name = Dictionary["ImageName"] as? String
                self.photos.append(photo)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
        filteredPhotos = photos
        f = filteredPhotos
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == false{
            return photos.count
        }
        return filteredPhotos.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        //let photo = photos[indexPath.row]
        var photo = photos[indexPath.row]
        if searchActive == true {
            photo = filteredPhotos[indexPath.row]
        }
        if User_set == false{
            cell.viewWithTag(1)?.isHidden = true
        }
        else{
            cell.viewWithTag(1)?.isHidden = false
        }
        cell.textLabel?.text = photo.name
        cell.detailTextLabel?.text = "Description"
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.image = UIImage(named: "Loading")
        if let photoURL = photo.ImageURL {
            let url = URL(string: photoURL)
            let Req = URLRequest(url: url! as URL)
            URLSession.shared.dataTask(with: Req as URLRequest, completionHandler: {
                (data, response, error) in
                if error != nil{
                    print(error)
                    return
                }
                DispatchQueue.main.async {
                 cell.imageView?.image = UIImage(data: data!)
                }
            }).resume()
        }
        return cell
    }
    
  
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive=true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive=false
    }
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //this refreshes each search
        guard !searchText.isEmpty else {
            filteredPhotos = photos
            self.tableView.reloadData()
            return
        }
        filteredPhotos = photos.filter({ (p1) -> Bool in
            p1.name!.lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
        }
}

/*
 Derian Lemus Wrote the Filtering of search bar (Approx 20 lines of code)
 */
