//
//  FriendsCollectionViewCell.swift
//  chattingApp
//
//  Created by Duale on 3/19/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import UIKit
import FirebaseAuth
import  FirebaseDatabase


protocol FriendDelDelegate {
    func deleteFriend()
    func openConversation()
    var userId : String? {get set}
    var userName : String? {get set}
    var userImgName : UIImage? {get set}
}


class FriendsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var textlabel: UILabel!
    @IBOutlet weak var messagebtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var delegate : FriendsViewController?
    var userId : String?
    var userName : String?
    var userImgName : UIImage?
    
    var isFriend : Bool?
    
    override func awakeFromNib() {
           super.awakeFromNib()
           
           labelStyle(label: textlabel, color: .blue)
           buttonStyle(button: messagebtn, color: .blue)
           buttonStyle(button: deleteBtn, color: .blue)
           frame.size.height = 119
           roundedImg(image: userimage)
       }
       
       func updateCell(img: UIImage, name: String, id: String){
           textlabel.text = name
           userimage.image = img
           userId = id
       }
       
       
       @IBAction func openMsgScreen(_ sender: Any) {
           self.delegate?.userId = userId!
           self.delegate?.userName = userName!
           self.delegate?.userImgName = userimage.image!
           self.delegate?.openConversation()
       }
       
       
       @IBAction func deleteFriend(_ sender: Any) {

           guard  let id = userId else {
               return
           }
           FireBaseManager.shared.deleteFriend(friendId: id) { (error) in
               if error != nil {
                   print(error?.localizedDescription ?? "Could not delete a friend")
               } else {
                   print("Succesfully removed a friend")
               }
               self.delegate?.deleteFriend()
           }
       }
    
}
