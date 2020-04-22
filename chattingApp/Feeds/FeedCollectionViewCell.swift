//
//  FeedCollectionViewCell.swift
//  chattingApp
//
//  Created by Duale on 3/19/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell , UITextViewDelegate {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var posttext: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    var postId : String?
    override func awakeFromNib() {
          super.awakeFromNib()
        roundedImg(image: userImage)
        postImage.clipsToBounds = true
        let fixedWidth = posttext.frame.size.width
        let newSize = posttext.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        posttext.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }

    func updateCellWOImg(userImg: UIImage, userName: String, postBody: String, date: String){
          self.userImage.image = userImg
          self.userNameLabel.text = userName
          self.posttext.text = postBody
          self.dateLabel.text = date
          self.postImage.isHidden = true
          self.posttext.isHidden = false

      }
    func updateCellWOText (userImg: UIImage, postImg: UIImage, userName: String, date: String){
           self.userImage.image = userImg
           self.postImage.image = postImg
           self.userNameLabel.text = userName
           self.dateLabel.text = date
           self.postImage.isHidden = true
           self.posttext.isHidden = false
       }
       func updateCell(userImg: UIImage, postImg: UIImage, userName: String, postBody: String, date: String){
           self.userImage.image = userImg
           self.postImage.image = UIImage(named: "male")
           self.userNameLabel.text = userName
           self.posttext.text = postBody
           self.dateLabel.text = date

         self.postImage.isHidden = false
         self.posttext.isHidden = false
       }

}
