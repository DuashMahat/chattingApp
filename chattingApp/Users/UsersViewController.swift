//
//  UsersViewController.swift
//  chattingApp
//
//  Created by Duale on 3/19/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class UsersViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource {
    var isFriend = [Bool]()
    @IBOutlet weak var cellview: UICollectionView!
    var userArray = [UserModel]()
    var friendArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        cellview.delegate = self
        cellview.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           getAllUsers()
           getAllFriends()
//           print(arrUsers.count)
    }
    func getAllUsers(){
                  friendArray = []
                  FireBaseManager.shared.getAllUsers { [weak self] (arrOfUsers) in
                      guard let users = try? arrOfUsers else {
                          print("Could not get users")
                          return
                      }
                      self?.userArray  = users
                      print(self!.userArray.count)
                      if self?.userArray.count == 0 {
                          print("No users were found")
                      } else {
                          self?.cellview.reloadData()
                      }
                  }
      }
      
      func getAllFriends(){
          FireBaseManager.shared.getAllFriends { [weak self] (array) in
              guard let friends = try? array else {
                  return
              }
              for friend in friends {
                  if let friendId = friend.userId {
                      self?.friendArray.append(friendId)
                  }
              }
              DispatchQueue.main.async {
                  self?.cellview.reloadData()
              }
          }
      }
      
      func checkIfFriend(_ uid: String) -> Bool {
          if friendArray.contains(uid){
              return true
          }
          return false
      }
      
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return userArray.count
      }
      
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserCollectionViewCell
          let user = userArray[indexPath.row]
        cell.updateCell(img: (user.userImage ?? defaultUserModel.shared.userImage), name: (user.name ?? "") + " " +  (user.lastName ?? ""), gender: user.gender ?? defaultUserModel.shared.gender, id: (user.userId ?? defaultUserModel.shared.userId))
          cell.addFriendBtn.isHidden = checkIfFriend(user.userId!)
          cell.delegate = self
          return cell
      }
      
      
      
      func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          var arrayOfPosts = [PostModel]()
          let user = userArray[indexPath.row]
          let st = UIStoryboard(name: "Main", bundle: nil)
          let vc = st.instantiateViewController(withIdentifier: "UserDetailViewController") as! UserDetailViewController
          vc.user = user
          vc.fullName = (user.name ?? "") + " " +  (user.lastName ?? "")
          FireBaseManager.shared.getAllPostsByUserId(id: user.userId!) { (array) in
              guard let postsArr = array else { return }
              arrayOfPosts = postsArr
              DispatchQueue.main.async {
                  vc.arrPosts = arrayOfPosts
                  vc.modalPresentationStyle = .fullScreen
                  self.present(vc, animated:  true)
              }

          }
      }
      func addFriend() {
          getAllFriends()
      }

}
