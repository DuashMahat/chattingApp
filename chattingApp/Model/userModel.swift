//
//  userModel.swift
//  chattingApp
//
//  Created by Duale on 3/18/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import Foundation
import UIKit
struct UserModel {
    let userId : String? , email : String? , password : String?
    var userImage : UIImage? , name : String? , lastName : String? , gender : String?
}

struct PostModel {
    let timestamp : Double?
    let userId : String?
    var postBody : String?
    let date : String?
    var postImage : UIImage?
    var postId : String?
}

struct MessageModel {
    let timestamp : Double?
    let recepientId : String?
    let date : String?
    var msgBody : String?
    let status : String?
}

