//
//  MainViewController.swift
//  N11 - Kart Oyunu
//
//  Created by fahri.bilici on 17.07.2019.
//  Copyright © 2019 fahri.bilici. All rights reserved.
//

import UIKit
import FirebaseAuth


class MainViewController: UIViewController {

    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var NickNameLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var HighScoreLabel: UILabel!
    var isRegistered : Bool?
    var hasPicture : Bool?
    @IBAction func PlayBtn(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "Game")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func LeadersBtn(_ sender: Any) {
    }
    
    @IBAction func LogoutBtn(_ sender: Any) {
        logOut()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfilePic = imgRounder(imgView: ProfilePic)
        registerationController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if UserDefaults.standard.value(forKey: "userID") == nil && isRegistered == nil
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterStoryboard")
            self.present(vc!, animated:true, completion:nil)
        }
        else if isRegistered != nil && hasPicture == nil
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectProfilePicture")
            self.present(vc!, animated:true, completion:nil)
        }
        if let userID = UserDefaults.standard.value(forKey: "userID")
        {
            getUserInfo(userID : userID as! String)
        }
    }
    func registerationController()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(isRegisterationFinished), name: NSNotification.Name(rawValue: "Registered"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(isPictureUploaded), name: NSNotification.Name(rawValue: "uploaded"), object: nil)
    }
    @objc func isRegisterationFinished()
    {
        isRegistered = true
    }
    @objc func isPictureUploaded()
    {
        hasPicture = true
    }
    
    func getUserInfo(userID : String)
    {
        Service.shared.getUserInfo(userID: userID , success: ({userInfo in
            self.NickNameLabel.text = userInfo[0]
            Service.shared.geUserPhoto(userID: userID , success: ({image in
                self.ProfilePic.image = image
            }))
        }))
        
    }
    func logOut()
    {
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "nickName")
        self.NickNameLabel.text = ""
        self.ProfilePic.image = nil
        try! Auth.auth().signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterStoryboard")
        self.present(vc!, animated:true, completion:nil)
    }

}
