//
//  FeedViewModel.swift
//  chattingApp
//
//  Created by Duale on 3/19/20.
//  Copyright © 2020 Duale. All rights reserved.
//


import Foundation
import UIKit
class FeedViewModel {
    var arrPosts = [[String : Any]]()
    var postImg : UIImage?
    var postBody : String?
    var date : String?
    var userName : String?
    var userId : String?
    var userImg : UIImage?
    var userM : UserModel?
    var postM : PostModel?
    var postId : String?
    func getPosts(completionHandler: @escaping (([[String : Any]])?) -> Void){
        arrPosts = [[String:Any]]()
        FireBaseManager.shared.getAllPosts{ (posts) in
                    if posts != nil {
                        self.arrPosts = posts!.sorted(by: { ($0["timestamp"] as! Double) > ($1["timestamp"] as! Double) })
                        completionHandler(posts)
                    } else {
                      
                        print("no posts yet")
                    }
                }
    }
    
    func numberOfRows() -> Int {
        return arrPosts.count
    }
    
    func getUserPostAndPostIdAtIndex(index: Int) -> Void{
        let post = arrPosts[index]
        userM = post["user"] as! UserModel?
        postM = post["post"] as! PostModel?
        postId = post["postId"] as! String?
        if userM != nil {
            userImg = userM!.userImage ?? defaultImg(gender: (userM?.gender)!)
            userName = "\(userM!.name ?? "") \(userM!.lastName ?? "")"
        }
        if postM != nil {
            date = postM?.date ?? ""
            if let img = postM?.postImage{
                postImg = img
            } else {
                postImg = nil
            }
            if let body = postM?.postBody {
                postBody = body
            } else {
                postBody = nil
            }
        }
    }
    
    func setInfoForCell(index: Int, completionHandler: @escaping (Bool, Bool, Bool)-> Void) {
        let post = arrPosts[index]
        userM = post["user"] as! UserModel?
        postM = post["post"] as! PostModel?
        postId = post["postId"] as! String?
        if userM != nil {
            userImg = userM!.userImage ?? UIImage(named: "male")
            userName = "\(userM!.name ?? "") \(userM!.lastName ?? "")"
        }
        if postM != nil {
            date = postM?.date ?? ""
            if let img = postM?.postImage{
                postImg = img
            } else {
                postImg = nil
            }
            if let body = postM?.postBody {
                postBody = body
            } else {
                postBody = nil
            }
        }
        validateValuesBeforePassingPostInfo(postImgCheck: postImg, postBodyCheck: postBody) { (both, image, body) in
            if both && !image && !body {
                completionHandler(true, false, false)
            }
            if !both && image && !body {
                completionHandler(false, true, false)
            }
            if !both && !image && body {
                completionHandler (false, false, true)
            }
        }
    }
    
    func getPostAndUserInfoToPass(index: Int){
        let post = arrPosts[index]
        userM = post["user"] as! UserModel?
        postM = post["post"] as! PostModel?
        postId = post["postId"] as! String?
        if userM != nil {
            userId = userM?.userId!
            userImg = userM!.userImage ?? UIImage(named: "male")
            userName = "\(userM!.name ?? "") \(userM!.lastName ?? "")"
        }
        if postM != nil {
            postImg = postM?.postImage ?? defaultPostModel.shared.postImage
            postBody = postM?.postBody ?? ""
            date = postM?.date ?? ""
        }
    }
    
    func validateValuesBeforePassingPostInfo(postImgCheck: UIImage?, postBodyCheck: String?, completionHandler: @escaping (Bool, Bool, Bool)-> Void){
        if !(postImgCheck == nil) && !(postBodyCheck == nil){
            userImg = userImg ?? defaultUserModel.shared.userImage
            postImg = postImgCheck!
            userName = userName ?? "John"
            postBody = postBodyCheck!
            date = date ?? ""
            completionHandler(true, false, false)
        }
        if !(postImg == nil) && postBody == nil {
            userImg = userImg ?? defaultUserModel.shared.userImage
            postImg = postImg!
            userName = userName ?? defaultUserModel.shared.name
            date = date ?? ""
            completionHandler(false, true, false)
        }
        if postImg == nil && !(postBody == nil) {
            userImg = userImg ?? defaultUserModel.shared.userImage
            userName = userName ?? defaultUserModel.shared.name
            postBody = postBodyCheck!
            date = date ?? ""
            completionHandler(false, false, true)
        }
    }
    

    
}
