//
//  ProfileTVC.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit
import SDWebImage

struct ProfileTVCCellsIDs{
    static let imageCell = "imageCell"
    static let nameCell = "nameCell"
    static let emailCell = "emailCell"
    static let phoneNumberCell = "phoneNumberCell"
}

protocol ProfileVCViewModel{
    var user:User?{get}
    var name:String?{get set}
    var email:String?{get}
    var phoneNumber:String?{get}
    
    var profilePicture:UIImage?{get}
    var pictureUrl:String?{get}
    
    func reloadValues()
    func updateName(newName:String,completion:((_ success:Bool)->Void)?)
    func updateProfilePicture(_ image:UIImage, completion:((Bool)->Void)?)
}

class ProfileTVC: UITableViewController,UITextFieldDelegate,Listener {
    var myListeners: [NSObjectProtocol] = []
    
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    var viewModel:ProfileVCViewModel?
    var imagePickerManager:ImagePickerControllerManager = ImagePickerControllerManager()
    
    override func viewDidLoad() {
        imagePickerManager.imagePickerVC.allowsEditing = true
        super.viewDidLoad()
        viewModel = ProfileVM()
        setUpListeners()
        setUpImageView()
        loadUserData()
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        rmListeners()
    }
    
    //MARK: - Listener methods
    
    func setUpListeners() {
        addListener(ForName: AppNotifications.userInfoUpdate) { (weakSelf, notif) in
            weakSelf.viewModel?.reloadValues()
            weakSelf.loadUserData()
        }
    }

    //MARK: - TextField methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let newName = textField.text ?? ""
        viewModel?.updateName(newName: newName, completion: nil)
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - ImageView methods
    
    func setImageWith(URL url:String){
        self.addImageLabel.isHidden = true
        self.userImageView.sd_addActivityIndicator()
        self.userImageView.sd_showActivityIndicatorView()
        self.userImageView.sd_setImage(with: URL(string: url))
    }

    func setImageWith(Image image:UIImage){
        self.addImageLabel.isHidden = true
        userImageView.image = image
    }
    
    func setUpImageView(){
        userImageView.layer.borderColor = userImageView.tintColor.cgColor
        userImageView.layer.borderWidth = 1
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(ProfileTVC.addImageAction(sender:)))
        userImageView.addGestureRecognizer(tapGes)
    }
    
    @objc
    func addImageAction(sender:UITapGestureRecognizer){
        
        func completion(file:Any?){
            if let picture = file as? UIImage, let vm = viewModel{
                vm.updateProfilePicture(picture) { (success) in
                    DispatchQueue.main.async {
                        if success{
                            self.setImageWith(Image: picture)
                        }
                    }
                }
            }
            else{
               
                UIAlertControllerShorcuts.showOKAlert(OnVC: self, Title: "picture_update".localized, Message: "err_using_selected_image".localized)
            }
        }
        
        let alertC = UIAlertController(title: "choose_image".localized, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "camera".localized, style: .default) { (_) in
            self.imagePickerManager.openCameraOnViewController(vc: self, completionHandler:completion)
        }
        let galleryAction = UIAlertAction(title: "gallery".localized, style: .default) { (_) in
            self.imagePickerManager.openPhotoLibraryOnViewController(vc: self, completionHandler:completion)
        }
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel) { (_) in}
        
        alertC.addAction(cameraAction)
        alertC.addAction(galleryAction)
        alertC.addAction(cancelAction)
        
        if let popoverController = alertC.popoverPresentationController {// IPAD
            popoverController.sourceView = sender.view ?? self.userImageView
            popoverController.sourceRect = sender.view?.bounds ?? self.userImageView.bounds
        }
        
        self.present(alertC, animated: true, completion: nil)
    }
    
    //MARK: - Methods
    
    func loadUserData(){
        nameTF.text = viewModel?.name
        emailLabel.text = viewModel?.email
        phoneNumberLabel.text = viewModel?.phoneNumber
        
        if let image = viewModel?.profilePicture{
            setImageWith(Image: image)
        }
        else if let url = viewModel?.pictureUrl{
            setImageWith(URL: url)
        }
    }
    
    func didTapLogOutCell(){
        
        UIAlertControllerShorcuts.showYesNoAlert(OnVC: self, Title: "logout".localized, Message: "want_to_continue?".localized,YesAction:{(_) in
            AppDelegate.logout()
        })
    
    }
    
}
