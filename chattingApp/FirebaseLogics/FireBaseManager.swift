//
//  FireBaseManager.swift
//  chattingApp
//
//  Created by Duale on 3/18/20.
//  Copyright © 2020 Duale. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import FBSDKCoreKit
import GoogleSignIn

class FireBaseManager  {
    let referenceDatabase = Database.database().reference()  // geting instance of firebase database from the root of firebase database
    let referenceStorage = Storage.storage().reference()     //  instance of storage reference for uploading and downloading binary objects
    static let shared = FireBaseManager()
    private init (){}
    
    func getUserData(completionHandler: @escaping (UserModel?) -> Void){
           let user = Auth.auth().currentUser
           referenceDatabase.child("User").child(user!.uid).observeSingleEvent(of: .value, with: {(snapshot) in
               guard let snap = snapshot.value as? [String : Any] else {
                       completionHandler(nil)
                       return
               }
               let userM = UserModel(userId: user!.uid, email: snap["email"] as? String, password: snap["password"] as? String, userImage: snap["image"] as? UIImage, name: snap["name"] as? String, lastName: snap["lastName"] as? String, gender: snap["gender"] as? String)
               completionHandler(userM)
           })
       }
    
    func addFriend(friendId: String, completionHandler: @escaping (Error?) -> Void) {
              let curUser = Auth.auth().currentUser
    referenceDatabase.child("User").child((curUser?.uid)!).child("Friends").child(friendId).updateChildValues([friendId : "friendId"] ){(error, ref) in
                  completionHandler(error)
              }
          }
    
    func deleteFriend(friendId: String, completionHandler: @escaping (Error?) -> Void){
        let curUser = Auth.auth().currentUser
referenceDatabase.child("User").child((curUser?.uid)!).child("Friends").child(friendId).removeValue(){(error, ref) in
            completionHandler(error)
        }
    }
}

//MARK- create a user

extension FireBaseManager {
    func createUser(user : UserModel, completionHandler: @escaping (Error?) -> Void){
           Auth.auth().createUser(withEmail: user.email!, password: user.password!) { (response, error) in
               if error != nil {
                   completionHandler(error)
               } else {
                   if let response = response?.user {
                       print("user successfully added, \(response.uid)")
                    let userDict = ["userId": response.uid, "email": user.email as Any, "password": user.password as Any, "name": user.name as Any, "lastName": user.lastName as Any , "gender": user.gender as Any] as [String : Any]
                       self.referenceDatabase.child("User").child(response.uid).setValue(userDict){(error1, ref) in
                           if error == nil{
                               Auth.auth().signIn(withEmail: userDict["email"] as! String, password: userDict["password"] as! String, completion: { (newUser, error) in
                                   if error == nil {
                                       print("succesfully signed in")
                                       completionHandler(nil)
                                   } else {
                                       completionHandler(error)
                                   }
                               })
                           } else {
                               completionHandler(error1)
                           }
                       }
                   }
               }
           }
       }
}


// MARK - Extension for sign in and sign out

extension FireBaseManager  {
           // MARK- For signining into the system with email and password
    func signIn(email: String, password: String, completionHandler: @escaping (Error?) -> Void){
           Auth.auth().signIn(withEmail: email, password: password) {(user, error) in
               if error != nil {
                   print(error?.localizedDescription ?? "error occured")
                   completionHandler(error)
//                   let alert = UIAlertController(title: "Sign In error", message: "", preferredStyle: UIAlertController.Style.alert)
//                   alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: nil))
//                   self.present(alert, animated: true, completion: nil)
               } else {
                   if let user = user?.user {
                       print(user.uid)
                   }
                   completionHandler(nil)
               }
           }
       }
    
          //MARK - For signing out from the systems
    func signOut(){
          if Auth.auth().currentUser != nil {
              do {
                  try Auth.auth().signOut()
              } catch{
                  print("Error occured signing out, \(error.localizedDescription)")
              }
          }
      }
      
}


// MARK - Extension for signup functionality

extension FireBaseManager {
    func signUp ( user : UserModel , completionHandler: @escaping (Error?) -> Void ) {
        Auth.auth().createUser(withEmail: user.email!, password: user.password!) { (response, error) in
            if (error != nil ) {
               completionHandler(error)
//               let alert = UIAlertController(title: "Signup error", message: "", preferredStyle: UIAlertController.Style.alert)
//               alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: nil))
//               self.present(alert, animated: true, completion: nil)
            } else {
                if let response =  response?.user {
                      print("result added  \(response.uid)")
                      /*
                        let userId : String? ,  email : String?  , password : String?
                        var firstName : String? , lastName: String? , userImage : UIImage? , gender: String?
                      */
                    let userDetailContainer = ["userId": response.uid, "Email": user.email as Any, "Password": user.password as Any, "FirstName": user.name as Any, "LastName": user.lastName as Any] as [String : Any]
                    self.referenceDatabase.child("User").child(response.uid).setValue(userDetailContainer){(errorrecieved , reference) in
                        if errorrecieved == nil {
                            Auth.auth().signIn(withEmail: userDetailContainer["Email"] as! String, password: userDetailContainer["Password"] as! String , completion:  { (newUser , errorgotten ) in
                                if errorgotten == nil {
//                                    print(errorgotten)
                                    completionHandler(errorgotten)
                                } else {
                                    completionHandler(nil)
                                }
                            })
                        } else {
                          completionHandler(error)
                        }
                    }
                 
                }
            }
        }
    }
}



//MARK- FOR GOOGLE SIGN IN AND AUTOMATIC CREATION
    /*
         Firebase documentation
    You create a new user in your Firebase project by calling the createUserWithEmail:password:completion: method or by signing in a user for the first time using a federated identity provider, such as Google Sign-In or Facebook Login.
 */


extension FireBaseManager  {
    
}



//MARK - FOR FACEBOOK SIGN IN AND AUTOMATIC CREATION

   /*
 
    You create a new user in your Firebase project by calling the createUserWithEmail:password:completion: method or by signing in a user for the first time using a federated identity provider, such as Google Sign-In or Facebook Login.
 */

extension FireBaseManager  {
    
    
}


// MARK - reset password

extension FireBaseManager  {
    func resetPassword(email: String, completionHandler: @escaping (Error?) -> Void){
           Auth.auth().sendPasswordReset(withEmail: email) { (error) in
               completionHandler(error)
           }
       }
}


// MARK - Update the user details

extension FireBaseManager {
    func updateUser(user: UserModel, completionHandler: @escaping (Error?) -> Void) {
           let userID = (Auth.auth().currentUser?.uid)!
           let userDict = ["name": user.name!, "email" : user.email!, "password" : user.password!,  "lastName": user.lastName as Any ,
            "gender": user.gender as Any] as [String : Any]
           referenceDatabase.child("User").child(userID).updateChildValues(userDict) {(error, ref) in
               if error != nil{
                   completionHandler(error)
               } else {
                   completionHandler(nil)
               }
           }
       }
}



// MARK - Saving user image and get image


extension FireBaseManager  {
    func saveUserImg(image: UIImage, completionHandler: @escaping (Error?) -> Void){
           let user = Auth.auth().currentUser
           let imageData = image.jpegData(compressionQuality: 0)
           let metaData = StorageMetadata()
           metaData.contentType = "image/jpeg"
           let imageName = "UserImg/\(String(describing: user!.uid)).jpeg"
           self.referenceStorage.child(imageName).putData(imageData!, metadata: metaData) {(data, error) in
               print ("The path is \(imageName)  and error is \(error)")
               completionHandler(error)
           }
       }
    
    func getUserImg(completionHandler: @escaping (Data?, Error?) -> Void){
           let user = Auth.auth().currentUser
           let imageName = "UserImg/\(String(describing: user!.uid)).jpeg"
           referenceStorage.child(imageName).getData(maxSize: 1*500*500, completion: {(data, error) in
               completionHandler(data, error)
           })
       }
}


//MARK - Posts
extension FireBaseManager {
    func savePost (post: PostModel, completionHandler: @escaping (Error?) -> Void){
        let postKey = referenceDatabase.child("Posts").childByAutoId().key
        let postDict = ["postId" : postKey!, "userId" : post.userId!, "postBody" : post.postBody!, "date" : post.date!, "timestamp" : post.timestamp as Any] as [String : Any]
        referenceDatabase.child("User").child(post.userId!).child("Posts").child(postKey!).setValue(postDict)
        referenceDatabase.child("Posts").child(postKey!).setValue(postDict)
            { (error, ref) in
            completionHandler(error)
        }
        
    }
    
    
    
    func updatePost(post: PostModel, completionHandler: @escaping (Error?) -> Void){
           let postDict = ["postId" : post.postId!, "userId" : post.userId!, "postBody" : post.postBody!, "date" : post.date!, "timestamp" : post.timestamp as Any] as [String : Any]
           referenceDatabase.child("Posts").child(postDict["postId"] as! String).updateChildValues(postDict){(error, ref) in
               if error == nil{
                   completionHandler(nil)
               } else {
                   completionHandler(error)
               }
           }
    }
       
    
    func deletePost(postId: String, completionHandler: @escaping (Error?) -> Void){
        referenceDatabase.child("Posts").child(postId).removeValue(){(error, ref) in
            if error == nil{
            completionHandler(nil)
            } else {
                completionHandler(error)
            }
        }
    }
    
}


extension FireBaseManager {
    func getAllPostsByUserId(id: String, completionHandler: @escaping ([PostModel]?) -> Void){
           let postGroup = DispatchGroup()
           let imageGroup = DispatchGroup()
           postGroup.enter()
           referenceDatabase.child("Posts").observeSingleEvent(of: .value) { (snapshot) in
               var arrPosts = [PostModel]()
               if let posts = snapshot.value as? [String : Any]{
                   for record in posts {
                       let pid = record.key
                       let post = posts[pid] as! [String : Any]
                       var postM = PostModel(timestamp: post["timestamp"] as? Double, userId: post["userId"] as? String, postBody: post["postBody"] as? String, date: post["date"] as? String, postImage: nil, postId: pid)
                       imageGroup.enter()
                       self.getPostImg(userId: postM.userId!, date: postM.date!) { (data, error) in
                           if error == nil && !(data == nil) {
                               postM.postImage = UIImage(data: data!)
                           }
                          if postM.userId == id {
                              arrPosts.append(postM)
                          }
                       }
                         imageGroup.leave()
                   }
                   imageGroup.notify(queue: .main){
//                       postGroup.leave()
                   }
                   postGroup.notify(queue: .main){
                       completionHandler(arrPosts)
                   }
               }
           }
            postGroup.leave()
       }
       
      func getAllPosts(completionHandler: @escaping ([[String : Any]]?) -> Void){
           let postsDispatchGroup = DispatchGroup()
           let userDispatchGroup = DispatchGroup()
           var postsArr = [[String : Any]]()
           referenceDatabase.child("Posts").observeSingleEvent(of: .value) { (snapshot, error) in
               if error == nil {
                   guard let response = snapshot.value as? [String : Any] else {
                       completionHandler(nil)
                       return
                   }
                   for record in response {
                       var postDict = [String : Any]()
                       postsDispatchGroup.enter()
                       let pid = record.key
                       let post = response[pid] as! [String : Any]
                       userDispatchGroup.enter()
                       self.getUserById(userId: post["userId"] as! String) { (user) in
                          postDict["user"] = user
                          userDispatchGroup.leave()
                       }
                 
                       var postM = PostModel(timestamp: post["timestamp"] as? Double, userId: post["userId"] as? String, postBody: post["postBody"] as? String, date: post["date"] as? String, postImage: nil, postId: post["postId"] as? String)
                       
                       postDict["postId"] = pid
                       postDict["timestamp"] = postM.timestamp
                       
                       self.getPostImg(userId: postM.userId!, date: postM.date!) { (data, error) in
                           if !(data == nil) && error == nil{
                               postM.postImage = UIImage(data: data!)
                           }
                           
                           postDict["post"] = postM
                           
                       }
                       userDispatchGroup.notify(queue: .main){
                           postsArr.append(postDict)
                           postsDispatchGroup.leave()
                       }
                   }
                   postsDispatchGroup.notify(queue: .main){
                       completionHandler(postsArr)
                   }
               }
               
           }
       }

}


    
    
extension FireBaseManager  {
    func getUserById(userId: String, completionHandler: @escaping (UserModel?) -> Void){
        referenceDatabase.child("User").child(userId).observeSingleEvent(of: .value, with: {(snapshot) in
            guard let record = snapshot.value as? [String : Any] else {
                    completionHandler(nil)
                    return
                }
            self.getUserImgById(id: userId, completionHandler: {(data, error) in
                print("+=========++++++++")
                print(error?.localizedDescription)
                  print("+=========++++++++")
                    if error == nil && !(data == nil) {
                        let user = UserModel(userId: userId, email: record["email"] as? String, password: record["password"] as? String, userImage: UIImage(data: data ?? Data()), name: record["name"] as? String, lastName: record["lastName"] as? String, gender: record["gender"] as? String)
                        completionHandler(user)
                    }
                    else {
                        let user = UserModel(userId: userId, email: record["email"] as? String, password: record["password"] as? String, userImage: nil, name: record["name"] as? String, lastName: record["lastName"] as? String, gender: record["gender"] as? String)
                        completionHandler(user)
                }
            })
        })
    }
}

extension FireBaseManager  {
    
    func getPostImg(userId: String, date: String, completionHandler: @escaping (Data?, Error?) -> Void){
        let imgName = "PostImg/\(String(describing: userId))/\(String(describing: date)).jpeg"
        referenceStorage.child(imgName).getData(maxSize: 1*500*500) { (data, error) in
            completionHandler(data, error)
        }
    }
    
    
    func savePostImg(date: String, image: UIImage, completionHandler: @escaping (Error?) -> Void){
        let user = Auth.auth().currentUser
        let img = image
        let imgData = img.jpegData(compressionQuality: 0)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let imgName = "PostImg/\(user!.uid)/\(String(describing: date)).jpeg"
        referenceStorage.child(imgName).putData(imgData!, metadata: metaData) { (data, error) in
            completionHandler(error)
        }
    }
    
    func getUserImgById(id: String, completionHandler: @escaping (Data?, Error?)->Void){
          
           let imageName = "UserImg/\(id).jpeg"
           referenceStorage.child(imageName).getData(maxSize: 15 * 1024 * 1024, completion: {(data, error) in
//               print("error ======== +++++   \(error)" )
               completionHandler(data, error)
           })
       }
}


extension FireBaseManager  {
    func getAllUsers(completionHandler: @escaping ([UserModel]) -> Void){
           let currentUser = Auth.auth().currentUser
           let fetchUserGroup = DispatchGroup()
           let fetchUserComponentGroup = DispatchGroup()
           fetchUserGroup.enter()
           referenceDatabase.child("User").observeSingleEvent(of: .value) {(snapshot, error) in
               if error != nil {
                   print(error ?? "Error happened fetching users")
               } else {
                   var userArr = [UserModel]()
                   guard let response = snapshot.value as? [String : Any] else {
                       return
                   }
                   for record in response {
                       let uid : String = record.key
                       if currentUser!.uid != uid {
                           let user = response[uid] as! [String : Any]
                           print(user)
                           var userM = UserModel(userId: uid, email: user["email"] as? String, password: user["password"] as? String, userImage: nil, name: user["name"] as? String, lastName: user["lastName"] as? String, gender: user["gender"] as? String)
                           fetchUserComponentGroup.enter()
                           self.getUserImgById(id: uid) { (data, error) in
                               if error == nil && !(data == nil){
                                   userM.userImage = UIImage(data: data!) ?? UIImage()
                               }
                               else {
                                   userM.userImage = UIImage(named: "male")
                               }
                                userArr.append(userM)
                                fetchUserComponentGroup.leave()
                           }
                       }
                   }
                   fetchUserComponentGroup.notify(queue: .main){
                       fetchUserGroup.leave()
                   }
                   fetchUserGroup.notify(queue: .main){
                       completionHandler(userArr)
                   }
               }
           }
       }
    
    
    func getAllFriends(completionHandler: @escaping ([UserModel]) -> Void){
        let currentUser = Auth.auth().currentUser
         var friendArr = [UserModel]()
         let friendDispatchGroup = DispatchGroup()  //
         referenceDatabase.child("User").child(currentUser!.uid).child("Friends").observeSingleEvent(of: .value) { (snapshot) in
             if let friends = snapshot.value as? [String : Any] {
                 for friend in friends {
                     friendDispatchGroup.enter()
                    self.referenceDatabase.child("User").child(friend.key).observeSingleEvent(of: .value) { (friendSnapshot) in
                         guard let singleFriend = friendSnapshot.value as? [String : Any] else {return}
                         var userM = UserModel(userId: friend.key, email: singleFriend["email"] as? String, password: singleFriend["password"] as? String, userImage: nil, name: singleFriend["name"] as? String, lastName: singleFriend["lastName"] as? String,gender: singleFriend["gender"] as? String)
                         self.getUserImgById(id: userM.userId!) { (data, error) in
                             if error == nil && !(data == nil){
                                 userM.userImage = UIImage(data: data!) ?? UIImage()
                             }
                            else {
                                userM.userImage =  UIImage(named: "male")
                            }
                             friendArr.append(userM)
                             friendDispatchGroup.leave()
                         }
                     }
                    friendDispatchGroup.notify(queue: .main){
                        completionHandler(friendArr)
                    }
                 }
                 
             }
         }
     }
    
}


extension FireBaseManager  {
      func getAllMsgsForChat(recepientId: String, completionHandler: @escaping  ([[String : Any]]?) -> Void){
            let uid = Auth.auth().currentUser?.uid
            let chatsGroup = DispatchGroup()
            var chatsArray = [[String : Any]]()

            chatsGroup.enter()
            referenceDatabase.child("User").child(uid!).child("Chats").child(recepientId).observeSingleEvent(of: .value) { (snapshot, error) in
                if error != nil {
                    print(error ?? "Error happened fetching chats")
                } else {
                    guard let records = snapshot.value as? [String : Any] else { return }
                    for record in records {
                        let cid = record.key
                        let chat = records[cid] as! [String : Any]
                        var chatDict = [String: Any]()
                        let chatM = MessageModel(timestamp: chat["timestamp"] as? Double, recepientId: chat["recepientId"] as? String, date: chat["date"] as? String, msgBody: chat["msgBody"] as? String, status: chat["status"] as? String)
                        chatDict["timestamp"] = chat["timestamp"] as? Double
                        chatDict["msgModel"] = chatM
                        chatsArray.append(chatDict)
                    }
                }
                chatsGroup.leave()
            }
            chatsGroup.notify(queue: .main){
                completionHandler(chatsArray)
            }
        }
    
    
    
        func sendMessage(msgModel : MessageModel, completionHandler: @escaping (Error?) -> Void){
               let uid = Auth.auth().currentUser?.uid
       //        let messageSent = DispatchGroup()
               let sendMessagesGroup = DispatchGroup()
               let messageId = referenceDatabase.child("Users").child(uid!).child("Chats").child(msgModel.recepientId!).childByAutoId().key
               let senderDict = ["timestamp": msgModel.timestamp!, "recepientId": msgModel.recepientId!, "date" : msgModel.date!, "msgBody": msgModel.msgBody!, "status": msgModel.status!] as [String : Any]
               
               let recepientDict = ["timestamp": msgModel.timestamp!, "recepientId": msgModel.recepientId!, "date" : msgModel.date!, "msgBody": msgModel.msgBody!, "status": "received"] as [String : Any]
               referenceDatabase.child("User").child(uid!).child("Chats").child(msgModel.recepientId!).child(messageId!).setValue(senderDict){(error, ref) in
                   if error != nil {
                       print("Succesfully sent a message")
                   } else {
                       completionHandler(error)
                   }
               }
               referenceDatabase.child("User").child(msgModel.recepientId!).child("Chats").child(uid!).child(messageId!).setValue(recepientDict){(error, ref) in
                   if error != nil {
                       print("Succesfully sent a message")
                   } else {
                       completionHandler(error)
                   }
               }

           }
        
}

extension FireBaseManager {
        func getAllConversationsForUser(completionHandler: @escaping ([[String : Any]]?) -> Void){
            let currentUser = Auth.auth().currentUser
            let usersGroup = DispatchGroup()
            let componentsUserGroup = DispatchGroup()
            var arrOfUsersWithConv = [[String: Any]]()
            
            referenceDatabase.child("User").child(currentUser!.uid).child("Chats").observeSingleEvent(of: .value) { (snapshot) in
                if let conversations = snapshot.value as? [String : Any]{
                    for conversation in conversations {
                        usersGroup.enter()
                        self.referenceDatabase.child("User").child(conversation.key).observeSingleEvent(of: .value) { (userSnapshot) in
                            var userDict = [String : Any]()
                            guard let singleUser = userSnapshot.value as? [String : Any] else {
                                return}
                                print("=============||||||||||+++============")
//                            print("|||||||||\(singleUser["Chats"]?[0])")
                                print("=============||||||||||+++============")
                            userDict["name"] = singleUser["name"] as? String
                            userDict["lastName"] = singleUser["lastName"]
                            userDict["userId"] = singleUser["userId"]
//                            userDict["msgBody"] = singleUser["msgBody"]
//                            userDict["msgBody"] = singleUser["Chats"]
                            self.getUserImgById(id: userDict["userId"] as! String) { (data, error) in
                                if error == nil && !(data == nil){
                                    userDict["userImg"] = UIImage(data: data!) ?? UIImage()
                                }
    //                            if error == nil && data == nil {
    //                                userDict["userImg"] = defaultImg(gender: (singleUser["gender"] as? String)!)
    //                            }
                                arrOfUsersWithConv.append(userDict)
                                usersGroup.leave()
                            }
                        }
                    }
                    usersGroup.notify(queue: .main){
                        completionHandler(arrOfUsersWithConv)
                    }
                }
                
            }
        }
        
}

//["gender": male, "name": duale , "Posts": {
//    "-M2t9lhVG6bLDebGt-Fx" =     {
//        date = "March-20-2020 13:18";
//        postBody = "Add post";
//        postId = "-M2t9lhVG6bLDebGt-Fx";
//        timestamp = "1584728314.815899";
//        userId = Y5ywYIx1LrQK28s9KFJVp5zO5jk1;
//    };
//    "-M2tAeKQ94HE9hTAVUW9" =     {
//        date = "March-20-2020 13:22";
//        postBody = Hgdgfdghdf;
//        postId = "-M2tAeKQ94HE9hTAVUW9";
//        timestamp = "1584728544.201412";
//        userId = Y5ywYIx1LrQK28s9KFJVp5zO5jk1;
//    };
//    "-M2tRuFVMuYQPHDfArZd" =     {
//        date = "March-20-2020 14:37";
//        postBody = "What up man ";
//        postId = "-M2tRuFVMuYQPHDfArZd";
//        timestamp = "1584733060.725669";
//        userId = Y5ywYIx1LrQK28s9KFJVp5zO5jk1;
//    };
//}, "userId": Y5ywYIx1LrQK28s9KFJVp5zO5jk1, "email": s@s.com, "Chats": {
//    S6gwPNsRjBQU66rrRfocxbUYZxZ2 =     {
//        "-M33QlvWsuz8gFpB17T4" =         {
//            date = "March-22-2020 17:48";
//            msgBody = "Bro WhatsApp ";
//            recepientId = Y5ywYIx1LrQK28s9KFJVp5zO5jk1;
//            status = received;
//            timestamp = "1584917315.393001";
//        };
//    };
//}, "password": 123456@, "lastName": mahat ]






