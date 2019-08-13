//
//  File.swift
//  socialpeak
//
//  Created by fleexx on 2019-06-20.
//  Copyright © 2019 Peakz Entertainment. All rights reserved.
//

import Foundation

class PostCapModel {
    var PostCaption: String?
    var PostImage: String?
    
    init(PostCaption: String?, PostImage: String?){
    self.PostCaption = PostCaption
    self.PostImage = PostImage
    }
}

class UserModel {
    var NameDisplay: String?
    
    init(NameDisplay: String?){
        self.NameDisplay = NameDisplay
    }
}

class TestNodel {
    var tesCap: String?
    
    init(tesCap: String?){
        self.tesCap = tesCap
    }
}

class Post {
    var Tcaption: String
    var Tphotourl: String
    var Tname: String
    
    
    init(CaptionText: String, PhotoString: String, TnameText: String){
        Tcaption = CaptionText
        Tphotourl = PhotoString
        Tname = TnameText
    }
    
}

class Thumbnail {
    var thumbImg: String
    
    init(thumbImage: String){
        thumbImg = thumbImage
    }
}

class LikePost {
    var Tlike: String
    var Tid: String
    var TlikeInt: Int
    
    init(TlikeKey: String, uidKey: String, LikeInt: Int ){
        Tlike = TlikeKey
        Tid = uidKey
        TlikeInt = LikeInt
    }
}

class postID {
    var pID: String
    
    init(pIDkey: String){
        pID = pIDkey
    }
}

class PostComments {
    var comments: String
    
    init(comment: String){
        comments = comment
    }
}

