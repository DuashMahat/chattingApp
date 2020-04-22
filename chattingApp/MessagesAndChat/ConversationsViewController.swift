//
//  ConversationsViewController.swift
//  chattingApp
//
//  Created by Duale on 3/20/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import  FirebaseDatabase
import FirebaseStorage
import SwipeCellKit

class ConversationsViewController: UIViewController {
    var arrUserConvers = [[String : Any]]()
    @IBOutlet weak var chartscollection: UICollectionView!
    override func viewDidLoad() {
           super.viewDidLoad()
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
                   self.chartscollection.reloadData()
               }
           }
       }
    
    @IBAction func deleteMessage(_ sender: UIBarButtonItem) {
        
    }
    
}

extension ConversationsViewController :  UICollectionViewDelegate, UICollectionViewDataSource  {
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrUserConvers.count
          }
          
          func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ConversationsCollectionViewCell
//            cell.delegate = self
            let user = arrUserConvers[indexPath.row]
            var userImg : UIImage?
//            let message = "\(user["msgBody"] as! String ?? "")"
            let userName = "\(user["name"] as! String ?? "") \(user["lastName"] as! String ?? "")"
            if let image = user["userImg"] as? UIImage {
                userImg = image
            }
             else {
                userImg = UIImage(named: "male")
            }
            
            cell.updateCell(name: userName, image: userImg!)
            return cell
          }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
    
      
    
}
