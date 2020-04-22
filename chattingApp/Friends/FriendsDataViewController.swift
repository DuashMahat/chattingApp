//
//  FriendsDataViewController.swift
//  chattingApp
//
//  Created by Duale on 3/19/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit

class FriendsDataViewController: UIViewController {

    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var deletebtn: UIButton!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var sendbtn: UIButton!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var userImage : UIImage?
    var arrPosts = [PostModel]()
    var fullName : String?
    var user : UserModel?
    @IBAction func goBack(_ sender: UIButton) {
          self.dismiss(animated: true, completion: nil)
    }

    @IBAction func deleteFr(_ sender: UIButton) {
        guard  let id = user?.userId else {
                        return
                 }
                 FireBaseManager.shared.deleteFriend(friendId: id) { (error) in
                 if error != nil {
                     print(error?.localizedDescription ?? "Could not delete a friend")
                 } else {
                     print("Succesfully removed a friend")
                 }
             }
             self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let csVC = storyBoard.instantiateViewController(identifier: "ChatSharedViewController") as? ChatSharedViewController else { return }
            csVC.userId = user?.userId ?? defaultUserModel.shared.userId
            csVC.userName = fullName ?? defaultUserModel.shared.userId
            csVC.userImage = imageview.image ?? UIImage(named: "male")
            csVC.getAllMessages(userId: (user?.userId) ?? defaultUserModel.shared.userId)
           self.present(csVC, animated: true, completion: nil)
    }
    
  

}


extension FriendsDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return arrPosts.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let post = arrPosts[indexPath.row]
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           cell.textLabel?.text = post.postBody ?? defaultPostModel.shared.postBody
           cell.imageView?.image = post.postImage ?? UIImage(named: "male")
           cell.detailTextLabel?.text = post.date ?? ""
           return cell
       }
       
       func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }
       func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
           return "Posts By \(user?.name ?? defaultUserModel.shared.name)"
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let post = arrPosts[indexPath.row]
           let userM = user
           let postId = post.postId
           var postImg : UIImage?
           var postBody : String?
           var date : String?
           var userImg : UIImage?
           var userName : String?
           let userId  = userM?.userId ?? defaultUserModel.shared.userId
           let defaultImage = UIImage(named: "male")
           userImg = userM?.userImage ?? UIImage(named: "male")
           userName = "\(userM!.name ?? "") \(userM!.lastName ?? "")"
           postImg = post.postImage ?? defaultImage
           postBody = post.postBody ?? ""
           date = post.date ?? ""
           let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DetailPostViewController") as! DetailPostViewController
           vc.imgPost = postImg
           vc.imgUser = userImg
           vc.userName = userName
           vc.date = date
           vc.postBody = postBody
           vc.userId = userId
           vc.postId = postId!
           present(vc, animated: true, completion: nil)
       }
}
