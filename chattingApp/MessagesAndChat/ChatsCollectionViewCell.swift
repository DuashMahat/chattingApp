//
//  ChatsCollectionViewCell.swift
//  chattingApp
//
//  Created by Duale on 3/21/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit

class ChatsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var TopRecieved: NSLayoutConstraint!
    @IBOutlet weak var BottomRecieved: NSLayoutConstraint!
    @IBOutlet weak var leadingRecieved: NSLayoutConstraint!
    @IBOutlet weak var TrailingRecieved: NSLayoutConstraint!
    @IBOutlet weak var leadingSent: NSLayoutConstraint!
    @IBOutlet weak var BottomSent: NSLayoutConstraint!
    @IBOutlet weak var TopSent: NSLayoutConstraint!
    @IBOutlet weak var TrailingSent: NSLayoutConstraint!
    @IBOutlet weak var messageSentTxt: UITextView!
    @IBOutlet weak var messageRecievedText: UITextView!
    override func awakeFromNib() {
           testViewStyle(txtView: messageRecievedText, color: .blue)
           testViewStyle(txtView: messageSentTxt, color: .blue)
       }
    
      
       func updateCell(msgBody: String, status: String){
           if status == "send"{
              messageSentTxt.isHidden = false
               messageRecievedText.isHidden = true
              messageSentTxt.text = msgBody
           } else {
            messageRecievedText.isHidden = false
               messageSentTxt.isHidden = true
              messageRecievedText.text = msgBody
           }
       }
}
