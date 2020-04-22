//
//  UserCollectionViewCell.swift
//  chattingApp
//
//  Created by Duale on 3/19/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase



protocol FriendsDelegate {
    func addFriend()
}


class UserCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var genderlabel: UILabel!
    @IBOutlet weak var addFriendBtn: UIButton!
    
    var isFriend : Bool?
    var userId : String?
    var delegate : UsersViewController?
    override func awakeFromNib() {
        super.awakeFromNib()
        labelStyle(label: fullname, color: .blue)
        labelStyle(label: genderlabel, color: .blue)
        buttonStyle(button: addFriendBtn, color: .blue)
        frame.size.height = 119
        roundedImg(image: userimage)
//        addFriendBtn.setImage(UIImage(named: "add"), for: UICONT)
    }
    
    func updateCell(img : UIImage, name: String,  gender: String, id: String){
        fullname.text = name
        genderlabel.text = gender
        userimage.image = img
        userId = id
    }
    
    @IBAction func addFriend(_ sender: Any) {
        guard let id = userId else { return }
        FireBaseManager.shared.addFriend(friendId: id) { (error) in
            if error != nil {
                print(error?.localizedDescription ?? "Could not add a friend")
            } else {
                
                print("Succesfully added a friend")
            }
            self.delegate?.addFriend()
        }
    }
    
    
}
