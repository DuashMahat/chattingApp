//
//  UserDetailViewController.swift
//  chattingApp
//
//  Created by Duale on 3/19/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit


class UserDetailViewController: UIViewController {
    var userImage : UIImage?
    var arrPosts = [PostModel]()
    var fullName : String?
    var user : UserModel?
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var postTableview: UITableView!
    @IBOutlet weak var messageBtn: UIButton!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        userImg.layer.borderWidth = 3
        userImg.layer.cornerRadius = userImg.frame.size.width / 2
        userImg.clipsToBounds = true
        let defaultImage = defaultImg(gender: (user?.gender ?? defaultUserModel.shared.gender))
               let imgDef = user?.userImage ?? defaultImage
               userImg.image = imgDef ?? defaultUserModel.shared.userImage
            usernameLbl.text = fullName ?? (defaultUserModel.shared.name + defaultUserModel.shared.lastName)
            postTableview.reloadData()
    }
    
//
//      let timestamp = NSDate().timeIntervalSince1970
//      let dateId = generateDate()
//      var userName : String?
//      var userImage : UIImage?
//      var userId : String?
//      var messageArray = [[String : Any]]()
    
    @IBAction func onChatClicked(_ sender: UIButton) {
        let st = UIStoryboard(name: "Main", bundle: nil)
               let vc = st.instantiateViewController(withIdentifier: "ChatSharedViewController") as! ChatSharedViewController
               vc.userId = user?.userId ?? defaultUserModel.shared.userId
               vc.userName = fullName ?? defaultUserModel.shared.userId
               vc.userImage = userImg.image ?? defaultUserModel.shared.userImage
               vc.getAllMessages(userId: (user?.userId) ?? defaultUserModel.shared.userId)
               self.present(vc, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           postTableview.reloadData()
          
       }
    
    @IBAction func onClickGoBack(_ sender: UIButton) {
          self.dismiss(animated: true, completion: nil)
    }
    
}


extension UserDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              let post = arrPosts[indexPath.row]
              let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
              cell.textLabel?.text = post.postBody ?? defaultPostModel.shared.postBody
              cell.imageView?.image = post.postImage ?? defaultPostModel.shared.postImage
              cell.detailTextLabel?.text = post.date ?? ""
              return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Posts By \(user?.name! ?? defaultUserModel.shared.name)"
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
        let defaultImage = defaultImg(gender: (user?.gender ?? defaultUserModel.shared.gender))
        userImg = userM?.userImage ?? defaultImage
        userName = "\(userM!.name ?? "") \(userM!.lastName ?? "")"
        postImg = post.postImage ?? UIImage()
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
