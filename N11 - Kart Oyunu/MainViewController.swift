//
//  MainViewController.swift
//  N11 - Kart Oyunu
//
//  Created by fahri.bilici on 17.07.2019.
//  Copyright © 2019 fahri.bilici. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleMobileAds

class MainViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var ProfilePic: UIImageView!
    @IBOutlet weak var NickNameLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var HighScoreLabel: UILabel!
    var isRegistered : Bool?
    var hasPicture : Bool?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func PlayBtn(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "Game")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var BannerAd: GADBannerView!
    @IBAction func LeadersBtn(_ sender: Any) {
        
        let vc = storyboard!.instantiateViewController(withIdentifier: "Leaderboard")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func LogoutBtn(_ sender: Any) {
        logOut()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfilePic = imgRounder(imgView: ProfilePic)
        registerationListener()
        BannerAd.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        BannerAd.rootViewController = self
        BannerAd.load(GADRequest())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        redirectToRegisterPage()
            if let userID = UserDefaults.standard.value(forKey: "userID")
            {
                getUserInfoFromFirebase(userID : userID as! String,success:
                    {
                        self.activityIndicator.stopAnimating()
                })
            }
        if ProfilePic.image == UIImage(named: "DefaultPP")
        {
            activityIndicator.startAnimating()
        }
    }
    func redirectToRegisterPage()
    {
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
    }
    func registerationListener()
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
    
    func getUserInfoFromFirebase(userID : String, success: @escaping () -> Void)
    {
        Service.shared.getUserInfo(userID: userID , success: ({userInfo in
            self.NickNameLabel.text = userInfo[0]
            self.HighScoreLabel.text = "High Score : \(String(userInfo[2]))"
            Service.shared.geUserPhoto(userID: userID , success: ({image in
                self.ProfilePic.image = image
            }))
            success()
        }))
    }
    func logOut()
    {
        removeUserInfoFromPhone()
        try! Auth.auth().signOut()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterStoryboard")
        self.present(vc!, animated:true, completion:nil)
    }
    func removeUserInfoFromPhone()
    {
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "nickName")
        UserDefaults.standard.removeObject(forKey: "highscore")
        self.NickNameLabel.text = ""
        self.ProfilePic.image = nil
    }
    
    
}
