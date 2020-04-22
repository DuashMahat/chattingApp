//
//  MainViewController.swift
//  chattingApp
//
//  Created by Duale on 3/18/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import JGProgressHUD
import FirebaseAuth
import Firebase
class MainViewController: UIViewController {
    var email : String = ""
    var password : String = ""
    let userDetails =  UserDefaults.standard
        let signInVM = SignViewModel()
        @IBOutlet weak var emailtext: UITextField!
        @IBOutlet weak var passwordtext: UITextField!
    @IBOutlet weak var switchoutlet: UISwitch!
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            secureTextEntry()
            setPlaceHolder()
        if (Auth.auth().currentUser == nil ) {
            switchoutlet.setOn(false, animated: true)
        }
    
        }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        if ( Auth.auth().currentUser != nil) {
          let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let tbVc = storyBoard.instantiateViewController(identifier: "MainTabBarViewController")  as? MainTabBarViewController else  {
               return
            }
           tbVc .modalPresentationStyle = .fullScreen
           self.present(tbVc , animated: true, completion: nil)
        }
    }
   
    
   @IBAction func onsignUp(_ sender: UIButton) {
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let signVc = storyBoard.instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController else {
                return
            }
            signVc.modalPresentationStyle = .fullScreen
           self.present(signVc, animated: true, completion: nil)
    }
   
    @IBAction func onsignInn(_ sender: UIButton) {
            jdvalidations(issue: "Signing in")
            if signInVM.validateSignIn(email: emailtext.text, password: passwordtext.text){
                       signInVM.signIn(email: emailtext.text, password: passwordtext.text) { (error) in
                           if error == nil {
                            let curUser = Auth.auth().currentUser
                            print("==================current user")
                            print(curUser)
                            print("==================current user")
                            self.email = self.emailtext.text!
                            self.password = self.passwordtext.text!
                            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                             guard let tbVc = storyBoard.instantiateViewController(identifier: "MainTabBarViewController")  as? MainTabBarViewController else  {
                                return
                             }
                            tbVc .modalPresentationStyle = .fullScreen
                            self.present(tbVc , animated: true, completion: nil)
                           } else {
                            self.jdvalidations(issue: "Error in signing")
                           }
                       }
                  } else {
                   }
        }
    
    
    @IBAction func resetButtonClicked(_ sender: UIButton) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                      guard let resetVc = storyBoard.instantiateViewController(identifier: "ResetViewController") as? ResetViewController else {
                         return
                      }
                      self.present(resetVc, animated: true, completion: nil)
    }
    
    
    
    @IBAction func onRememberMe(_ sender: UISwitch) {
        if sender.isOn  {
            let curUser = Auth.auth().currentUser
            print("is on")
        } else {
            print("is off")
        }
    }
    
}



extension MainViewController {
    func  setPlaceHolder() {
        emailtext.placeholder = "Email"
        passwordtext.placeholder = "Password"
    }
}


extension MainViewController {
    func secureTextEntry() {
        passwordtext.isSecureTextEntry = !passwordtext.isSecureTextEntry
    }
}


extension MainViewController {
    func jdvalidations (issue: String) {
        let hud = JGProgressHUD(style: .extraLight)
      hud.textLabel.text = issue
      hud.show(in: self.view)
      hud.dismiss(afterDelay: 3.0)
    }
}

