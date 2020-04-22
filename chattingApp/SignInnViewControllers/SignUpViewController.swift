//
//  SignUpViewController.swift
//  chattingApp
//
//  Created by Duale on 3/18/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import GoogleSignIn
import JGProgressHUD

class SignUpViewController: UIViewController {
    var datePicker = UIDatePicker()
    let signViewModel = SignViewModel()
    let userDetails = UserDefaults.standard
    @IBOutlet weak var emailtext: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var dateofbirth: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmpassword: UITextField!
    @IBOutlet weak var gender: UITextField!
    
    override func viewDidLoad() {
         super.viewDidLoad()
               placeholders()
               datePicker = UIDatePicker()
               datePicker.datePickerMode = .date
               dateofbirth.inputView = datePicker
               secureText()
                  let tapGest = UITapGestureRecognizer(target: self, action: #selector(tapped(gesture: )))
                   view.addGestureRecognizer(tapGest)
               datePicker.addTarget(self, action: #selector(datechange(datepicker:)) ,for: .valueChanged)
                 
               }
               
               @objc func tapped( gesture: UITapGestureRecognizer) {
                   view.endEditing(true)
               }

               @objc func datechange (datepicker: UIDatePicker ) {
                   let formatter = DateFormatter()
                   formatter.dateFormat = "dd/MM/yyyy"
                   dateofbirth.text = formatter.string(from: datepicker.date)
                   view.endEditing(true)
                   
        }

    @IBAction func onSignUpClicked(_ sender: UIButton) {
        if signViewModel.validateSignUp(email: emailtext.text, password: password.text, name: firstname.text, lastName:lastname.text,confirmPassword: confirmpassword.text , gender:  gender.text){
    
            let user = UserModel(userId: nil, email: emailtext.text ?? defaultUserModel.shared.email, password: password.text ?? defaultUserModel.shared.password, userImage: nil, name: firstname.text ?? defaultUserModel.shared.name, lastName: lastname.text ?? defaultUserModel.shared.lastName , gender: gender.text ?? defaultUserModel.shared.gender)
            let hud = JGProgressHUD(style: .extraLight)
                                                   hud.textLabel.text = "signing up"
                                                   hud.show(in: self.view)
                                                   hud.dismiss(afterDelay: 3.0)
            signViewModel.signUp(user: user) { (error) in
                if error == nil{
                    let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                    guard let mainTb = storyBoard.instantiateViewController(identifier: "MainTabBarViewController") as? MainTabBarViewController else {
                    return
                    }
                    mainTb.modalPresentationStyle = .fullScreen
                    self.present(mainTb, animated: true, completion: nil)
                }
                else {
                   print(error)
                }
            }
        }
        clearTexts()
    }
    
    
    @IBAction func backToSignIn(_ sender: Any) {
           let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                         guard let mainVc = storyBoard.instantiateViewController(identifier: "MainViewController") as? MainViewController else {
                            return
                         }
                         self.present(mainVc, animated: true, completion: nil)
    }
    
    
  
   
    @IBAction func onRememberMe(_ sender: UISwitch) {
        if sender.isOn  {
//            userDetails.set(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        } else {
            
        }
    }
    
    
}


extension  SignUpViewController  {
    func secureText() {
          password.isSecureTextEntry = !password.isSecureTextEntry
           confirmpassword.isSecureTextEntry = !confirmpassword.isSecureTextEntry
       }
}


extension  SignUpViewController  {

    func placeholders() {
          dateofbirth.placeholder = "Date of Birth"
          firstname.placeholder = "First Name"
          lastname.placeholder = "Last Name"
          confirmpassword.placeholder = "Confirm Password"
          emailtext.placeholder = "Email"
          password.placeholder = "Password"
          gender.placeholder = "Gender"
      }
    
    
    func clearTexts() {
        dateofbirth.text = ""
                 firstname.text = ""
                 lastname.text = ""
                 confirmpassword.text = ""
                 emailtext.text = ""
                 password.text = ""
                 gender.text = ""
    }
}


extension  SignUpViewController  {
    func incorrectSignUp() {
         let alert = UIAlertController(title: "Incorrect sign up", message: "retry", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
     }
}
