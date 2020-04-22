//
//  ChatSharedCellCollectionViewCell.swift
//  chattingApp
//
//  Created by Duale on 3/20/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit

class ChatSharedCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var messageRecievedTextV: UITextView!
    @IBOutlet weak var messageSentTextV: UITextView!
    override func awakeFromNib() {
              testViewStyle(txtView: messageRecievedTextV, color: .blue)
           testViewStyle(txtView: messageSentTextV, color: .blue)
           
       }
       func updateCell(msgBody: String, status: String){
           if status == "send"{
               messageRecievedTextV.isHidden = true
               messageSentTextV.isHidden = false
               messageSentTextV.text = msgBody
           }
        
           if status == "received"{
               messageSentTextV.isHidden = true
               messageRecievedTextV.isHidden = false
                messageRecievedTextV.text = msgBody
           }
        
       }
    
}
