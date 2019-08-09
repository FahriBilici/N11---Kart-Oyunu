//
//  SetProfilePicturePopUpViewController.swift
//  N11 - Kart Oyunu
//
//  Created by fahri.bilici on 18.07.2019.
//  Copyright © 2019 fahri.bilici. All rights reserved.
//

import UIKit

class SetProfilePicturePopUpViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var defaultPictures = ["man1","man2","man3","man4","girl1","girl2",]
    var selectedPicture :String?
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    @IBAction func setAvatar(_ sender: Any) {
        if let pic = selectedPicture
        {
            let userID = UserDefaults.standard.value(forKey: "userID") as! String
            if let choosenPic = UIImage(named: pic)
            {
                Service.shared.savePhotoToCloud(pic: choosenPic, userID: userID, success: {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
                self.dismiss(animated: true, completion: nil)
                })
            }
        }
    }
    @IBAction func chooseImageFromGalleryOrCamera (_ sender: Any) {
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose Source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera)
            {
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
            }
            else
            {
                print("Camera not avaible")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
            {
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            }
            else
            {
                print("Photo Library not avaible")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        let userID = UserDefaults.standard.value(forKey: "userID") as! String
        Service.shared.savePhotoToCloud(pic: image, userID: userID, success: {
        picker.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
        self.dismiss(animated: true, completion: nil)
        })
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return defaultPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultPictureCell", for: indexPath) as! DefaultProfilePicCollectionViewCell
        cell.defaultProfilePicture.image = UIImage(named: defaultPictures[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 3
        cell?.layer.borderColor = UIColor.init(red: 0, green: 181, blue: 238, alpha: 1).cgColor
        cell?.layer.cornerRadius = (cell?.frame.size.width)! / 2
        selectedPicture = defaultPictures[indexPath.row]
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
    }
    

}

