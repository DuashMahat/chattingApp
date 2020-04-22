//
//  FriendsViewController.swift
//  chattingApp
//
//  Created by Duale on 3/19/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore

//, UICollectionViewDelegate, UICollectionViewDataSource, FriendDelDelegate

class FriendsViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, FriendDelDelegate {
    @IBOutlet weak var colview: UICollectionView!
    var userId: String?
    var userName: String?
    var userImgName: UIImage?
    var isFriend = [Bool]()
    var arrFriends = [UserModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        colview.backgroundColor = .black
         getAllFriends()
    }

    override func viewWillAppear(_ animated: Bool) {
        getAllFriends()
    }

    func getAllFriends(){
           FireBaseManager.shared.getAllFriends { [weak self] (arrOfFriends) in
               guard let array = try? arrOfFriends else {
                   print("Could not get Friends")
                   self!.arrFriends = []
                   return
               }
               self?.arrFriends = array
               if self?.arrFriends.count == 0 {
                   print("No Friends were found")
               } else {
                   print("==========*****=========***========")
                   let friend = arrOfFriends[0].lastName
                         print("friend lastname \(friend)")
                           print( "friend arry in collection \(self?.arrFriends[0].lastName)")
                    print("==========+++++= ========+++========")
                   self?.colview.reloadData()

               }
           }
       }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrFriends.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FriendsCollectionViewCell
        let friend = arrFriends[indexPath.row]
        let defaultImage = UIImage(named: "male")
        cell.userId = friend.userId
        cell.userImgName = friend.userImage ?? UIImage(named: "camera")
        cell.userName = (friend.name ?? "") + " " +  (friend.lastName ?? "")
        cell.updateCell(img: friend.userImage ?? defaultImg(gender: friend.gender!), name: friend.name! + " " +  friend.lastName!, id: friend.userId!)
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var arrayOfPosts = [PostModel]()
        let user = arrFriends[indexPath.row]
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "FriendsDataViewController") as! FriendsDataViewController
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

  func openConversation() {
    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
    guard let cvc = storyBoard.instantiateViewController(identifier: "ChatSharedViewController") as? ChatSharedViewController else {return}
    cvc.userId = userId!
    cvc.userName = userName!
    cvc.userImage = userImgName
    cvc.getAllMessages(userId: userId!)
    present(cvc, animated: true)
   }
    
    
    
   func deleteFriend() {
            arrFriends = []
            getAllFriends()
            colview.reloadData()
   }

}


 
 
