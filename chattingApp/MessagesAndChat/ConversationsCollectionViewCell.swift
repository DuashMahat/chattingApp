//
//  ConversationsCollectionViewCell.swift
//  chattingApp
//
//  Created by Duale on 3/21/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import SwipeCellKit

class ConversationsCollectionViewCell: UICollectionViewCell {
   
    @IBOutlet weak var checkmarkLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var usernamelabel: UILabel!
    override func awakeFromNib() {
           labelStyle(label: usernamelabel, color: .blue)
           roundedImg(image: userimage)
    }
    
    // ,  msgBody: String
    func updateCell(name : String, image: UIImage ){
           userimage.image = image
           usernamelabel.text = name
//           messageTextField.text =  msgBody
        
    }
    
    var isInEditingMode: Bool = false {
        didSet {
            checkmarkLabel.isHidden = !isInEditingMode
        }
    }

    // 2
    override var isSelected: Bool {
        didSet {
            if isInEditingMode {
                checkmarkLabel.text = isSelected ? "✓" : ""
            }
        }
    }
       
    
}
