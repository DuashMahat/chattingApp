//
//  FriendsTableViewController.swift
//  chattingApp
//
//  Created by Duale on 3/22/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit

class FriendsTableViewController: UIViewController , UISearchBarDelegate  , UITableViewDelegate , UITableViewDataSource{
    var arrUserConvers = [[String : Any]]()
    var cellIdentifier = "Cell"
    var idsDict = [String : Any]()
    var arrFriends = [UserModel]()
    var options = [String]()
    var fileredoptions = [String]()
    var friendsInfo = [[String: Any]]()
    var filteredFootballer = [Footballer]()
    var optionsImgs = [UIImage]()
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableview.tableHeaderView = searchController.searchBar
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor.white
        getFriend()
        getUsersInfoWithConversations()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
              getUsersInfoWithConversations()
          }
          
    func getUsersInfoWithConversations(){
              arrUserConvers = [[String : Any]]()
              FireBaseManager.shared.getAllConversationsForUser { (arrOfUsersInfo) in
                  if let array = arrOfUsersInfo {
                      self.arrUserConvers = array
                  }
              }
}

    
    func p () {
        print(options)
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if searchController.isActive && searchController.searchBar.text != "" {
          return fileredoptions.count
        }
        return options.count
    
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       let  username : String
       if searchController.isActive && searchController.searchBar.text != "" {
        username = fileredoptions[indexPath.row]
       } else {
         username = options[indexPath.row]
       }
       cell.textLabel?.text =  username
       cell.detailTextLabel?.text = "send message"
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = arrUserConvers[indexPath.row]
                   let st = UIStoryboard(name: "Main", bundle: nil)
                           let vc = st.instantiateViewController(withIdentifier: "ChatSharedViewController") as! ChatSharedViewController
                   vc.userId = user["userId"] as? String
                   vc.userName = "\(user["name"] as? String ?? "") \(user["lastName"] as? String ?? "")"
                   if let image = user["userImg"] as? UIImage {
                       vc.userImage = image ?? UIImage(named: "male")
                   }
                   vc.getAllMessages(userId: ((user["userId"] as? String)!))
                  self.present(vc, animated: true, completion: nil)
        
    }

    
    private func filternames (for searchText: String) {
      fileredoptions = options.filter { name in
        return name.lowercased().contains(searchText.lowercased())
      }
      tableview.reloadData()
    }

}

extension FriendsTableViewController :  UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
       filternames(for: searchController.searchBar.text ?? "")
    }
}




extension FriendsTableViewController {
    func getFriend(){
               FireBaseManager.shared.getAllFriends { (arrOfUsers) in
                   guard let users = try? arrOfUsers else {
                       print("Could not get friends")
                       return
                   }
                   self.arrFriends = users
                   print(self.arrFriends)
                   for friend in self.arrFriends {
                       let friendDict = ["friendName": (friend.name ?? "") + " " +  (friend.lastName ?? ""), "userId" : friend.userId as Any, "userImg": friend.userImage as Any, "gender": friend.gender as Any ] as [String : Any]
                       self.idsDict = [friendDict["friendName"] as! String : friendDict["userId"] as! String]
                       self.friendsInfo.append(friendDict)

                          }
                   for dict in self.friendsInfo {
                       let image = (dict["userImg"] as? UIImage) ?? UIImage(named: "camera")
                       self.optionsImgs.append(image!)
                       self.options.append(dict["friendName"] as! String)
                    print("=====options=== \(type(of: self.options))")
                   }
                   DispatchQueue.main.async {
                    self.tableview.reloadData()
                   }
               }
    }
}
