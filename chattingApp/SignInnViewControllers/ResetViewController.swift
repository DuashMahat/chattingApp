//
//  ResetViewController.swift
//  chattingApp
//
//  Created by Duale on 3/18/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit

class ResetViewController: UIViewController {
     let viewModel = SignViewModel()
    @IBOutlet weak var loginlink: UIButton!
    @IBOutlet weak var emailtext: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onLoginLink(_ sender: Any) {
        viewModel.resetPassword(email: emailtext.text) { (error) in
                   if error != nil {

                       print("The link to reset the password is sent to the email")
                   } else {
                   }
                   self.emailtext.text = ""

               }
    }
    
    
    @IBAction func onBackToSigninn(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
               guard let mainVc = storyBoard.instantiateViewController(identifier: "MainViewController") as? MainViewController else {
                  return
               }
               self.present(mainVc, animated: true, completion: nil)
    }
    
}

extension  ResetViewController  {
    func placeholders() {
         emailtext.placeholder = "Enter email to reset"
      }
}
