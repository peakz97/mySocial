//
//  SearchTableViewController.swift
//  socialpeak
//
//  Created by fleexx on 2019-07-09.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import UIKit
import Firebase

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var SearchTable: UITableView!
    
    var LoggedInUser:User?

    var userArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
   
    
    
    var dataRef = Database.database().reference()
    
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        SearchTable.dataSource = self
        SearchTable.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        dataRef.child("users").queryOrdered(byChild: "username").observe(.childAdded, with: { (snapshot) in
            
            let key = snapshot.key
            let snapshot = snapshot.value as? NSDictionary
            snapshot?.setValue(key, forKey: "uid")
            
            if(key == self.LoggedInUser?.uid)
            {
                print("same as logged in user")
            }
            else
            {
            self.userArray.append(snapshot)
                
                self.SearchTable.insertRows(at: [IndexPath(row: self.userArray.count-1, section: 0)], with: UITableView.RowAnimation.automatic)

            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredUsers.count
        }
        return self.userArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        
        let user : NSDictionary?
        
        if searchController.isActive && searchController.searchBar.text != "" {
            user = filteredUsers[indexPath.row]
        } else {
            user = self.userArray[indexPath.row]
        }
        
        cell.textLabel?.text = user?["username"] as? String
        
        
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContent(searchText: self.searchController.searchBar.text!)
        
    }

    func filterContent(searchText:String)
    {
        self.filteredUsers = self.userArray.filter{ user in
            
            let Uname = user!["username"] as? String
            
            return(Uname?.lowercased().contains(searchText.lowercased()))!
            
        }
        
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowUserSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let user = userArray[indexPath.row]
                let controller = segue.destination as? followControllerViewController
                controller?.otherUser = user
        }
    }
}
    
}
