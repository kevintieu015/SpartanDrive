//
//  SearchFileView.swift
//  Project Group 7
//
//  Created by Johnny Sun on 10/7/18.
//  Copyright © 2018 Johnny Sun. All rights reserved.
//

import UIKit
import CloudKit

class SearchFileView: UITableViewController {


  
let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var SearchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        tableView.delegate=self
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    var FilteredData = [Candies]()
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            print("filtering")
            return FilteredData.count
        }
        print("not filtering")
        return Inventory.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        let candy: Candies
        if isFiltering(){
            candy = FilteredData[indexPath.row]
        }else{
            candy = Inventory[indexPath.row]
        }
        cell.textLabel!.text=candy.Name
        cell.detailTextLabel!.text=candy.type
        return cell
    }
    
    
    func isFiltering() -> Bool {
        return searchController.isActive && !SearchBarEmpty()
    }
    func SearchBarEmpty() -> Bool {
        return (searchController.searchBar.text?.isEmpty) ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All"){
        FilteredData = Inventory.filter({( candy: Candies)-> Bool in
            return (candy.Name?.lowercased().contains(searchText.lowercased()))!
        })
        tableView.reloadData()
    }
    
    let Inventory = [
        Candies(categories: "Chocolate", name: "Milk Chocolate"),
        Candies(categories: "Chocolate", name: "Dark Chocolate"),
        Candies(categories: "Chocolate", name: "Caramel Chocolate"),
        Candies(categories: "Chocolate", name: "White Chocolate"),
        Candies(categories: "Chocolate", name: "Hershey Cookie & Cream"),
        Candies(categories: "Chocolate", name: "M&Ms"),
        Candies(categories: "Gummy", name: "Sour Gummy Warms"),
        Candies(categories: "Gummy", name: "Peach Gummy Rings"),
        Candies(categories: "Gummy", name: "Gummy Bears"),
        Candies(categories: "Gummy", name: "Sour Kids"),
        Candies(categories: "Candy", name: "Sour Drops"),
        Candies(categories: "Candy", name: "StarBurst"),
        Candies(categories: "Candy", name: "Air Heads"),
        Candies(categories: "Candy", name: "Laffy Taffy"),
        Candies(categories: "Candy", name: "Warheads"),
        Candies(categories: "Candy", name: "Skittles"),
        Candies(categories: "Candy", name: "Jolly Ranchers")
    ]
   
}
extension SearchFileView: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
}
