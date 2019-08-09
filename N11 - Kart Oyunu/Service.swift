//
//  Service.swift
//  N11 - Kart Oyunu
//
//  Created by fahri.bilici on 16.07.2019.
//  Copyright © 2019 fahri.bilici. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

var dbref: DatabaseReference!
let storegaRef = Storage.storage().reference()

class Service {
    static let shared = Service()
    func registerUser(nickName : String, password : String)
    {
        var userID = String()
        dbref = Database.database().reference()
        Auth.auth().signInAnonymously
            { (result, error) in
            if let id = result?.user.uid
            {
                userID = id
                let userAdder = dbref.child("users").child(userID)
                userAdder.setValue(["username" : nickName,"password" : password,"highscore" : "0"])
                print(nickName)
                UserDefaults.standard.setValue(userID, forKey: "userID")
                UserDefaults.standard.setValue(nickName, forKey: "nickName")
            }
            }
    }
    
    func savePhotoToCloud(pic : UIImage,userID : String, success: @escaping () -> ())
    {
        let imageRef = storegaRef.child(userID+".png")
        if let uploadData = pic.jpegData(compressionQuality: 0.25)
        {
            imageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard error == nil
                else
                {
                    print(error)
                    return
                }
                imageRef.downloadURL(completion: { (url, error) in
                    self.setImageToUser(userID: userID,path: url!.absoluteString)
                    success()
                })
            }
        }
    }
    
    func setImageToUser(userID : String,path : String)
    {
        dbref = Database.database().reference()
    dbref.child("users").child(userID).updateChildValues(["profile_pic" : path])
    }
    
    
    func getUserInfo(userID : String , success: @escaping ([String]) -> ())
    {
        var infoStorgage : [String] = []
        dbref = Database.database().reference()
        dbref.child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
        let value = snapshot.value as? NSDictionary
            infoStorgage.append(value?["username"] as? String ?? "")
            infoStorgage.append(value?["profile_pic"] as? String ?? "")
            infoStorgage.append(value?["highscore"] as? String ?? "0")
            infoStorgage.append(value?["lastScore"] as? String ?? "")

            success(infoStorgage)
        }
    }
    func geUserPhoto(userID : String , success: @escaping (UIImage) -> ())
    {
        let photoref = storegaRef.child(userID+".png")
        photoref.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error
            {
                print(error)
            }
            else
            {
                let image = UIImage(data: data!)
                success(image!)
            }
        }

    }
    
    func saveScore(userID : String,/*score : Int,*/ highScore : String, success: @escaping () -> ())
    {
        dbref = Database.database().reference()
        dbref.child("users").child(userID).updateChildValues(["highscore" : highScore])
        success()
    }
    
    func getLeaderbord(success: @escaping ([Player]) -> ())
    {
        dbref = Database.database().reference()
        var userList : [Player] = []
        let userRef = dbref.child("users")
        userRef.observe(.value) { (snapshot) in
            for users in snapshot.children.allObjects as! [DataSnapshot]
            {
                let userObject = users.value as? [String : AnyObject]
                let username = userObject?["username"]
                let profile_pic = userObject?["profile_pic"]
                let highscore = userObject?["highscore"]
                let player = Player(username: username as! String, highscore: highscore as! String, profile_pic: profile_pic as! String)
                
                userList.append(player)
            }
            userList = self.sortPlayersByHighScore(playerList: userList)
            success(userList)
        }
    }
    func sortPlayersByHighScore (playerList : [Player]) -> [Player]
    {
        let sortedPlayers = playerList.sorted(by: { Int($0.highscore)! > Int($1.highscore)! })
        return sortedPlayers
    }
    func downloadImgFromUrl(url : String) -> NSData
    {
        let imageUrl = URL(string: url)!
        let imageData : NSData = NSData(contentsOf: imageUrl)!
        return imageData
    
    }
}

func imgRounder(imgView : UIImageView) -> UIImageView
{
    imgView.layer.cornerRadius = imgView.frame.size.width / 2
    
    return imgView
}

