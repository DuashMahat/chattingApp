//
//  SignViewModel.swift
//  chattingApp
//
//  Created by Duale on 3/18/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignViewModel: NSObject {
   
}
extension SignViewModel {
    func validateSignIn(email: String?, password: String?) -> Bool {
        if let email = email, !email.isEmpty, let password = password, !password.isEmpty {
            return true
        } else {
            print("Fill out all fields")
            return false
        }
    }
}


extension SignViewModel  {
    func signIn(email: String?, password: String?, completionHandler: @escaping (Error?) -> Void){
           FireBaseManager.shared.signIn(email: email ?? defaultUserModel.shared.email, password: password ?? defaultUserModel.shared.password) { (error) in
               if error != nil {
                   print(error?.localizedDescription ?? "could not sign in")
                   completionHandler(error)
               } else {
                   print("Succesfully signed in")
                   completionHandler(nil)
               }
           }
       }
}


extension SignViewModel  {
    func signUp(user : UserModel, completionHandler: @escaping (Error?) -> Void){
           FireBaseManager.shared.createUser(user: user) { (error) in
               if error == nil {
                   print("Created a user")
                   completionHandler(nil)
               } else {
                   completionHandler(error)
                   print("Could not create a user")
               }
           }
       }
}

extension SignViewModel  {
    func validateSignUp(email: String?, password: String?, name: String?,lastName: String?, confirmPassword: String? , gender : String? ) -> Bool{
           if let email = email, !email.isEmpty, let password = password, !password.isEmpty, let name = name, !name.isEmpty,  let lastName = lastName, !lastName.isEmpty, let confPass = confirmPassword, !confPass.isEmpty , let gender = gender, !gender.isEmpty {
               if email.isValidEmail {
                   if password == confPass {
                       return true
                   } else {
                       print("passwords do not match")
                       return false
                   }
               } else {
                   print("The email is not valid")
                   return false
               }
                   
           } else {
               print("Fill out all fields")
               return false
           }
       }
}

extension SignViewModel  {
    func resetPassword(email: String?, completionHandler: @escaping (Error?) -> Void){
           if let email = email, !email.isEmpty {
               if email.isValidEmail {
                   FireBaseManager.shared.resetPassword(email: email) { (error) in
                       if error != nil {
                           completionHandler(error)
                       } else {
                           completionHandler(nil)
                       }
                   }
               } else {
                   print("the email is not valid")
               }
           } else {
               print("Fill out all fields")
           }
       }
}
