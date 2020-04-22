//
//  ChatSharedViewController.swift
//  chattingApp
//
//  Created by Duale on 3/20/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class ChatSharedViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var wheretosendMessage: UIView!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var usernamelabel: UILabel!
    @IBOutlet weak var messagebody: UITextView!
    @IBOutlet weak var sendMessageBtn: UIButton!
    
    let timestamp = NSDate().timeIntervalSince1970
    let dateId = generateDate()
    var userName : String?
    var userImage : UIImage?
    var userId : String?
    var messageArray = [[String : Any]]()
   override func viewDidLoad() {
        super.viewDidLoad()
        testViewStyle(txtView: messagebody, color: .blue)
        labelStyle(label: usernamelabel, color: .blue)
        buttonStyle(button:sendMessageBtn, color: .blue)
        roundedImg(image: userimage)
        userimage.image = userImage
        usernamelabel.text = userName

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getAllMessages(userId: String){
            messageArray = [[:]]
            FireBaseManager.shared.getAllMsgsForChat(recepientId: userId) { (arrayOfMsgs) in
                if arrayOfMsgs != nil {
                    self.messageArray = arrayOfMsgs!.sorted(by: { ($0["timestamp"] as! Double) < ($1["timestamp"] as! Double) })
                } else {
                    print("No chats yet")
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    
    

    @IBAction func sendMsg(_ sender: Any) {
        if let txtBody = messagebody.text, !(txtBody.isEmpty){
            let msg = MessageModel(timestamp: timestamp, recepientId: userId, date: dateId, msgBody: txtBody, status: "send")
           FireBaseManager.shared.sendMessage(msgModel: msg) { (error) in
                if error != nil {
                    print("Could not send message")
                } else {
                    print("Succesfully sent message")
                    FireBaseManager.shared.getAllMsgsForChat(recepientId: msg.recepientId!) { (arrayOfMsgs) in
                        if arrayOfMsgs != nil {
                            self.messageArray = arrayOfMsgs!.sorted(by: { ($0["timestamp"] as! Double) < ($1["timestamp"] as! Double) })
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        self.messagebody.text = ""
    }
}

extension ChatSharedViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return messageArray.count
        }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatSharedCellCollectionViewCell
            let msg = messageArray[indexPath.row]
            var msgBody : String?
            var msgStatus : String?
            let msgM = msg["msgModel"] as! MessageModel?
            if msgM != nil {
                msgBody = msgM?.msgBody
                msgStatus = msgM?.status
             cell.updateCell(msgBody: msgBody!, status: msgStatus!)
            }
            
         return cell
    }
    
}

