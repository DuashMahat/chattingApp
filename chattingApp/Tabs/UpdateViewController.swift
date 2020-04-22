//
//  UpdateViewController.swift
//  chattingApp
//
//  Created by Duale on 3/18/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import JGProgressHUD



class UpdateViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
     var gender : String?
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var uiimageview: UIView!
    @IBOutlet weak var gendertext: UITextField!
    var currentUser : UserModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageview.contentMode = .scaleAspectFill
        uiimageview.contentMode = .scaleAspectFill
        imagePicker.delegate = self
        placeholders()
    }

     override func viewWillAppear(_ animated: Bool) {
            getUserInfo()
        }

    @IBAction func onCameraClicked(_ sender: UIBarButtonItem) {
         present(imagePicker , animated: true , completion: nil)
    }

    func setupImagePicker() {
              imagePicker.delegate = self
              if UIImagePickerController.isSourceTypeAvailable(.camera) {
                  imagePicker.sourceType = .camera
              } else {
                  imagePicker.sourceType = .photoLibrary
              }
              imagePicker.allowsEditing = true
    }

    @IBAction func onPickImageClicked(_ sender: UIButton) {
         alertCamOrPhoto()
         self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func onUpdateClicked(_ sender: UIButton) {
        let updatedUserData = UserModel(userId: currentUser?.userId, email: currentUser?.email, password: currentUser?.password, userImage: imageview.image, name:firstname.text, lastName: lastname.text , gender: gendertext.text)
                FireBaseManager.shared.updateUser(user: updatedUserData) { (error) in
                    if error == nil {
                        print(self.gendertext.text!)
                        print("Succesfully updated user")
                        print(updatedUserData.email!)
                        print("Succesfully updated user")
                        let hud = JGProgressHUD(style: .extraLight)
                        hud.textLabel.text = "updating..."
                        hud.show(in: self.view)
                        hud.dismiss(afterDelay: 3.0)
                    } else {
                        print(error?.localizedDescription ?? "Could not update user")
                    }
                }
    }

    func getUserInfo(){
        FireBaseManager.shared.getUserData { (user) in
            if user != nil {
                self.currentUser = user
                self.firstname.text = user?.name
                self.lastname.text = user?.lastName
                self.gendertext.text = user?.gender
                self.getImage()
            } else {
                print("Error hapened")
            }
        }
    }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//                      guard let pickedimage = info[.editedImage] as? UIImage else {
//                                    print("image not found ===========")
//                                return
//                                }
//                            FireBaseManager.shared.saveUserImg(image: pickedimage) { (error) in
//                                if error == nil {
//                                    self.imageview.image = pickedimage
//                                    print("Succesfully updated image")
//                                } else {
//                                    print(error?.localizedDescription ?? "couldnt save image")
//                                }
//                            }

       if let image = info[.originalImage] as? UIImage {
          self.imageview.image = image
         FireBaseManager.shared.saveUserImg(image: image) { (error) in
                                       if error == nil {
                                           self.imageview.image = image
                                           print("Succesfully updated image")
                                       } else {
                                           print(error?.localizedDescription ?? "couldnt save image")
                                       }
                                   }
       }
       else  if let image = info[.editedImage] as? UIImage {
            self.imageview.image = image
          FireBaseManager.shared.saveUserImg(image: image) { (error) in
                                        if error == nil {
                                            self.imageview.image = image
                                            print("Succesfully updated image")
                                        } else {
                                            print(error?.localizedDescription ?? "couldnt save image")
                                        }
                                    }
       } else {
          print("ERROR")
       }
         self.dismiss(animated: true, completion: nil)
//        self.imagePicker.dismiss(animated: true, completion: nil)

       }

}





extension UpdateViewController  {
   func getImage(){
            FireBaseManager.shared.getUserImg { (data, error) in
                if error == nil {
                    self.imageview.image = UIImage(data: data!) ?? UIImage()
                } else {
                    self.imageview.image =  UIImage(named: "male")
                    print( error?.localizedDescription ?? "Could not fetch image")
                }
            }
        }
}



extension UpdateViewController {
    func placeholders() {
        gendertext.placeholder = "type your gender"
        firstname.placeholder = "First Name"
        lastname.placeholder = "Last Name"
    }
}

extension UpdateViewController {
    func alertCamOrPhoto () {
           let alert = UIAlertController(title: "Choose Image Source", message: "", preferredStyle: .actionSheet)
           alert.addAction(UIAlertAction(title: "Get image from camera", style: .default, handler: { (action: UIAlertAction) in
               self.getImageNeed(fromSourceType: .camera)
           }))

           alert.addAction(UIAlertAction(title: "Get image from Photo Album", style: .default, handler: { (action: UIAlertAction) in
               self.getImageNeed(fromSourceType: .photoLibrary)
           }))
           alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }

       func getImageNeed(fromSourceType sourceType: UIImagePickerController.SourceType) {
           imagePicker.sourceType = sourceType
           onCameraClicked(camera)
       }
}



