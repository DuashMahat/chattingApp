//
//  ChatViewController.swift
//  chattingApp
//
//  Created by Duale on 3/20/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import UIKit
import iOSDropDown
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChatViewController: UIViewController {

    
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageBodyTextV: UITextView!
    @IBOutlet weak var userimage: UIImageView!
    @IBOutlet weak var friendsDropdown: DropDown!
    var idsDict = [String : Any]()
    var choseUser : Bool?
    let timestamp = NSDate().timeIntervalSince1970
    let dateId = generateDate()
    var arrFriends = [UserModel]()
    var friendsInfo = [[String: Any]]()
    var options = [String]()
    var optionsKeys = [Int]()
    var optionsImgs = [UIImage]()
    var timer = Timer()
    var userId : String?
    var arrMsgs = [[String : Any]]()
        override func viewDidLoad() {
            super.viewDidLoad()
            buttonStyle(button: sendBtn, color: .blue)
            testViewStyle(txtView:messageBodyTextV, color: .blue)
            textFieldStyle(txtField: friendsDropdown, color: .blue)
            roundedImg(image: userimage)
            buttonStyle(button: sendBtn, color: .blue)
            userimage.image = UIImage(named: "male")
            friendsDropdown.didSelect { (name, index, id) in
                self.userimage.image = self.optionsImgs[index]
                self.userId = self.idsDict[name] as? String
                self.getAllMessages(userId: self.userId!)
                self.choseUser = true 
            }

            if choseUser == true {
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(getMessages), userInfo: nil, repeats: true)
            }
        }

        override func viewWillDisappear(_ animated: Bool) {
            timer.invalidate()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            getFriend()
        }

        func getFriend(){
            FireBaseManager.shared.getAllFriends { (arrOfUsers) in
                guard let users = try? arrOfUsers else {
                    print("Could not get friends")
                    return
                }
                self.arrFriends = users
                print(self.arrFriends)
                for friend in self.arrFriends {
                    let friendDict = ["friendName": (friend.name ?? "") + " " +  (friend.lastName ?? ""), "userId" : friend.userId as Any, "userImg": friend.userImage as Any, "gender": friend.gender as Any ] as [String : Any]
                    self.idsDict = [friendDict["friendName"] as! String : friendDict["userId"] as! String]
                    self.friendsInfo.append(friendDict)

                       }
                for dict in self.friendsInfo {
                    let image = (dict["userImg"] as? UIImage) ?? UIImage(named: "camera")
                    self.optionsImgs.append(image!)

                    self.options.append(dict["friendName"] as! String)
                }
                DispatchQueue.main.async {
                    self.friendsDropdown.optionArray = self.options
                }
            }
        }


        @objc func getMessages(){
            arrMsgs = [[:]]
            FireBaseManager.shared.getAllMsgsForChat(recepientId: userId!) { (arrayOfMsgs) in
                if arrayOfMsgs != nil {
                    self.arrMsgs = arrayOfMsgs!.sorted(by: { ($0["timestamp"] as! Double) < ($1["timestamp"] as! Double) })
                } else {
                    print("No chats yet")
                }
                DispatchQueue.main.async {
                     self.chatCollectionView.reloadData()
                 }
            }
        }
        func getAllMessages(userId: String){
            arrMsgs = [[:]]
            FireBaseManager.shared.getAllMsgsForChat(recepientId: userId) { (arrayOfMsgs) in
                if arrayOfMsgs != nil {
                    self.arrMsgs = arrayOfMsgs!.sorted(by: { ($0["timestamp"] as! Double) < ($1["timestamp"] as! Double) })
                } else {
                    print("No chats yet")
                }
                DispatchQueue.main.async {
                     self.chatCollectionView.reloadData()
                 }
            }
        }



        @IBAction func sendMessage(_ sender: Any) {
            self.arrMsgs = [[:]]
            if let txtBody = messageBodyTextV.text, !(txtBody.isEmpty){
                let msg = MessageModel(timestamp: timestamp, recepientId: userId, date: dateId, msgBody: txtBody, status: "send")
            FireBaseManager.shared.sendMessage(msgModel: msg) { (error) in
                    if error != nil {
                        print("Could not send message")
                    } else {
                        print("Succesfully sent message")
                        FireBaseManager.shared.getAllMsgsForChat(recepientId: msg.recepientId!) { (arrayOfMsgs) in
                            if arrayOfMsgs != nil {
                                self.arrMsgs = arrayOfMsgs!.sorted(by: { ($0["timestamp"] as! Double) < ($1["timestamp"] as! Double) })
                                DispatchQueue.main.async {
                                    self.chatCollectionView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
            self.messageBodyTextV.text = ""
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return arrMsgs.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChatsCollectionViewCell
            let msg = arrMsgs[indexPath.row]
            var msgBody : String?
            var msgStatus : String?
            let msgM = msg["msgModel"] as! MessageModel?
            if msgM != nil {
                msgBody = msgM?.msgBody
                msgStatus = msgM?.status
            }
            cell.updateCell(msgBody: msgBody!, status: msgStatus!)
            return cell
        }
    }

