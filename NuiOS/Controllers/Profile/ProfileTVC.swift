//
//  ProfileTVC.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit
import GoogleSignIn
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

extension ProfileVCViewModel{
    var connectedWithGoogle:Bool{
        guard let _ = user?.account?.google?.id else{
            return false
        }
        return true
    }
    
    var connectedWithFacebook:Bool{
        guard let _ = user?.account?.facebook?.id else{
            return false
        }
        return true
    }
}

class ProfileTVC: UITableViewController,UITextFieldDelegate,Listener,GIDSignInUIDelegate {
    var myListeners: [NSObjectProtocol] = []
    
    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var googleSwitch: UISwitch!
    @IBOutlet weak var faceSwitch: UISwitch!
    
    
    var viewModel:ProfileVCViewModel?
    var imagePickerManager:ImagePickerControllerManager = ImagePickerControllerManager()
    
    override func viewDidLoad() {
        GIDSignIn.sharedInstance().uiDelegate = self
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
    
    //MARK: - ActivityIndicatorAlertVC methods
    
    func showSocialNetworkAlert(completion:(()->Void)?){
        let alert = ActivityIndicatorAlertVC()
        self.present(alert, animated: true, completion:completion)
    }
    
    func hideSocialNetworkAlert(){
        
        if let alert = self.presentedViewController as? ActivityIndicatorAlertVC{
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Listener methods
    
    func setUpListeners() {
        addListener(ForName: AppNotifications.userInfoUpdate) { (weakSelf, notif) in
            weakSelf.viewModel?.reloadValues()
            weakSelf.loadUserData()
        }
        
        addListener(ForName: AppNotifications.connectedWithGoogle) { (weakSelf, notif) in
            weakSelf.hideSocialNetworkAlert()
            weakSelf.loadUserData()
            if let success = notif.userInfo?["success"] as? Bool{
                if !success{
                    GIDSignIn.sharedInstance().signOut()
                }
            }
        }
    }

    //MARK: - TextField methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let newName = textField.text ?? ""
        viewModel?.updateName(newName: newName, completion: nil)
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - UISwicth methods
    
    @IBAction func socialnetworksSwitchDidChange(_ sender: UISwitch) {
        if sender.isEqual(googleSwitch){
            if sender.isOn{
                self.showSocialNetworkAlert {
                    GIDSignIn.sharedInstance().signIn()
                }
            }
            else{
                //disconnect from google
                disconnectFromGoogle()
            }
        }
        else{
            if sender.isOn{
                
            }
            else{
                
            }
        }
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
        nameTF.text = viewModel?.name ?? nameTF.text
        emailLabel.text = viewModel?.email ?? emailLabel.text
        phoneNumberLabel.text = viewModel?.phoneNumber ?? phoneNumberLabel.text
        
        if let image = viewModel?.profilePicture{
            setImageWith(Image: image)
        }
        else if let url = viewModel?.pictureUrl{
            setImageWith(URL: url)
        }
        
        faceSwitch.isOn = viewModel?.connectedWithFacebook ?? false
        googleSwitch.isOn = viewModel?.connectedWithGoogle ?? false
    }
    
    func didTapLogOutCell(){
        
        UIAlertControllerShorcuts.showYesNoAlert(OnVC: self, Title: "logout".localized, Message: "want_to_continue?".localized,YesAction:{(_) in
            AppDelegate.logout()
        })
    
    }
    
    func disconnectFromGoogle(){
        func disconnect(){
            AppSingleton.shared.googleDiscconect { (success) in
                DispatchQueue.main.async {
                    if success{
                        GIDSignIn.sharedInstance().signOut()
                        self.loadUserData()
                    }
                }
            }
        }
        
        UIAlertControllerShorcuts.showYesNoAlert(OnVC: self, Title: "google_disconnect_title".localized, Message: "google_disconnect_mess".localized,YesAction:{
            (_) in
            
            disconnect()
            
        })
    }
    
}
