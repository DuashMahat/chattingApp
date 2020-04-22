//
//  CreatePostViewController.swift
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
import ProgressHUD
import  JGProgressHUD



class CreatePostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let timestamp = NSDate().timeIntervalSince1970
    let imagePicker = UIImagePickerController()
    let dateId = generateDate()
    @IBOutlet weak var chooseImageBtn: UIButton!
    @IBOutlet weak var posttext: UITextView!
    @IBOutlet weak var postImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        posttext.delegate = self
        imagePicker.delegate = self
        setUpImagePicker()
        postImage.image = UIImage(named: "camera")
        posttext.text = "Add post"
         posttext.textColor = .blue
        let fixedWidth = posttext.frame.size.width
               let newSize = posttext.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
               posttext.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
          self.present(imagePicker, animated: true, completion:  nil)
    }
    
    @IBAction func createPost(_ sender: Any) {
         savepost()
         navigationController?.popViewController(animated: true)
    }
}


extension CreatePostViewController  {
    func setUpImagePicker() {
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        imagePicker.allowsEditing = true
    }
}

extension CreatePostViewController {
    func savepost(){
        let user = Auth.auth().currentUser
        let postM = PostModel(timestamp: timestamp, userId: user?.uid, postBody: posttext.text, date: dateId, postImage: nil, postId: nil)
        FireBaseManager.shared.savePost(post: postM) { (error) in
            if error == nil {
                print("Succesfully created post")
                self.useJGhud(issue: "Posted succesfully")
                return
            } else {
               self.useJGhud(issue: "Post error")
            }
        }
    }
}

extension CreatePostViewController  {
    func textViewDidBeginEditing(_ textView: UITextView) {
           if textView.text.isEmpty {
               posttext.text = "dd some post "
               posttext.textColor = .lightGray
           } else {
               if textView.textColor == .blue {
                   textView.text = nil
                   textView.textColor = .black
               }
           }
           
       }
}



extension  CreatePostViewController  {
    func useJGhud (issue: String ) {
        let hud = JGProgressHUD(style: .extraLight)
        hud.textLabel.text = issue
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 5.0)
    }
}


