//
//  DetailPostViewController.swift
//  chattingApp
//
//  Created by Duale on 3/19/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseStorage

class DetailPostViewController: UIViewController,UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    let imagePicker = UIImagePickerController()
    let timestamp = NSDate().timeIntervalSince1970
    let dateId = generateDate()
    @IBOutlet weak var chooseBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var postBodyText: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var updatePostBtn: UIButton!
    @IBOutlet weak var postimageview: UIImageView!
    @IBOutlet weak var usernamelabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var deleteBtn: UIButton!
    var imgPost : UIImage? , imgUser : UIImage? , userName : String? ,date : String? ,postBody: String? ,postId : String? , userId : String? , isCurrentUser : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        postBodyText.delegate = self
               let fixedWidth = postBodyText.frame.size.width
               let newSize = postBodyText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
               postBodyText.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
           checkIfCurent(userId: userId!)
                  
                  if isCurrentUser == true {
                      postBodyText.isEditable = true
                      setUpImagePicker()
                  } else {
                      deleteBtn.isHidden = true
                      updatePostBtn.isHidden = true
                      chooseBtn.isEnabled = false
                  }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
          present(imagePicker, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
          onViewAppear()
       }
    
    @IBAction func deletePost(_ sender: Any) {
               FireBaseManager.shared.deletePost(postId: postId!) { (error) in
                   if error == nil{
                       print("Succesfully deleted post")
                   } else {
                       print(error?.localizedDescription ?? "Could not delete post")
                   }
               }
               self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onUpdateClicked(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        let postM = PostModel(timestamp: timestamp, userId: uid, postBody:postBodyText.text, date: dateId, postImage: nil, postId: postId)
        FireBaseManager.shared.updatePost(post: postM) { (error) in
            if error == nil {
                FireBaseManager.shared.savePostImg(date: self.dateId, image: self.postimageview.image!) { (error) in
                if error == nil {
                    print("Succesfully uploaded and updated image")
                } else {
                    print(error?.localizedDescription ?? "Couldnt save image")
                    }
                }
                print("Succesfuly updated post")
            } else {
                print("Could not update the post")
            }
        }
    }
    
    @IBAction func goToFeed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailPostViewController  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let addedImg = info[.editedImage] as? UIImage else {
            print("Error, image is not")
            return
        }
        
        FireBaseManager.shared.savePostImg(date: self.dateId, image: addedImg) { (error) in
            if error == nil {
                self.postimageview.image = addedImg
                print("Succesfully uploaded and updated image")
            } else {
                print(error?.localizedDescription ?? "Couldnt save image")
                }
            }
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}


extension DetailPostViewController  {
    func checkIfCurent(userId: String){
           let currUserId = Auth.auth().currentUser?.uid
           if currUserId == userId {
               isCurrentUser = true
           } else {
               isCurrentUser = false
           }
       }
}

extension DetailPostViewController  {
    func setUpImagePicker(){
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.allowsEditing = true
    }
}

extension DetailPostViewController {
    func onViewAppear() {
        postimageview.image = imgPost
        userImage.image = imgUser
        usernamelabel.text = userName
        dateLabel.text = date
        postBodyText.text = postBody
    }
}
