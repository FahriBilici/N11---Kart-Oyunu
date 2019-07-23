//
//  RegisterViewController.swift
//  N11 - Kart Oyunu
//
//  Created by fahri.bilici on 16.07.2019.
//  Copyright © 2019 fahri.bilici. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var ProfilePicture: UIImageView!
    @IBOutlet weak var NickNameLabel: UITextField!
    @IBOutlet weak var PasswordLabel: UITextField!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        ref = Database.database().reference()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func Register(_ sender: Any) {
        if let nick = NickNameLabel.text, nick.isEmpty == false
        {
            if let password = PasswordLabel.text, password.isEmpty == false
            {
                Service.shared.registerUser(nickName: nick, password: password)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Registered"), object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
