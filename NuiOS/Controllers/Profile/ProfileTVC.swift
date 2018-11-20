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
import FBSDKLoginKit

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
    
    @IBOutlet weak var addImageButton: UIButton!
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
        setUpAddImageButton()
        setUpListeners()
        loadUserData()
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
    
    func hideSocialNetworkAlert(completion:(()->Void)?=nil){
        
        if let alert = self.presentedViewController as? ActivityIndicatorAlertVC{
            alert.dismiss(animated: true, completion: completion)
        }
    }
    
    //MARK: - Listener methods
    
    func setUpListeners() {
        addListener(ForName: AppNotifications.userInfoUpdate) { (weakSelf, notif) in
            weakSelf.reloadUserData()
        }
        
        addListener(ForName: AppNotifications.connectedWithGoogle) { (weakSelf, notif) in
            weakSelf.hideSocialNetworkAlert()
            weakSelf.reloadUserData()
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
                self.showSocialNetworkAlert {
                    self.connectWithFacebook()
                }
            }
            else{
                disconnectFromFacebook()
            }
        }
    }
    
    //MARK: - ChooseImageButton methods
    
    func setUpAddImageButton(){
        guard let _ = viewModel?.pictureUrl else{
            addImgButton(Show: true)
            return
        }
        addImgButton(Show: false)
    }
    
    func addImgButton(Show show:Bool){
        self.addImageButton.isSelected = !show
    }
    
    @IBAction func adImageBtnAction(_ sender: UIButton) {
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
            popoverController.sourceView = self.userImageView
            popoverController.sourceRect = self.userImageView.bounds
        }
        
        self.present(alertC, animated: true, completion: nil)
    }
    
    
    //MARK: - ImageView methods
    
    func setImageWith(URL url:String){
        addImgButton(Show: false)
        self.userImageView.sd_addActivityIndicator()
        self.userImageView.sd_showActivityIndicatorView()
        self.userImageView.sd_setImage(with: URL(string: url))
    }

    func setImageWith(Image image:UIImage){
        addImgButton(Show: false)
        userImageView.image = image
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
    
    func reloadUserData(){
        viewModel?.reloadValues()
        self.loadUserData()
    }
    
    func didTapLogOutCell(){
        
        UIAlertControllerShorcuts.showYesNoAlert(OnVC: self, Title: "logout".localized, Message: "want_to_continue?".localized,YesAction:{(_) in
            AppDelegate.logout()
        })
    
    }
    
    func disconnectFromGoogle(){
        func disconnect(){
            AppSingleton.shared.googleDisconnect { (success) in
                DispatchQueue.main.async {
                    if success{
                        GIDSignIn.sharedInstance().signOut()
                        self.reloadUserData()
                    }
                }
            }
        }
        
        UIAlertControllerShorcuts.showYesNoAlert(OnVC: self, Title: "disconnect_title".localized, Message: "google_disconnect_mess".localized,YesAction:{
            (_) in
            
            disconnect()
            
        })
    }
    
    func disconnectFromFacebook(){
        func disconnect(){
            AppSingleton.shared.facebookDisconnect { (success) in
                DispatchQueue.main.async {
                    if success{
                        FBSDKLoginManager().logOut()
                    }
                    self.reloadUserData()
                }
            }
        }
        
        UIAlertControllerShorcuts.showYesNoAlert(OnVC: self, Title: "disconnect_title".localized, Message: "facebook_disconnect_mess".localized,YesAction:{
            (_) in
            disconnect()
        })
    }
    
    func connectWithFacebook(){
        func completion(success:Bool){
            DispatchQueue.main.async {
                self.hideSocialNetworkAlert{
                    self.reloadUserData()
                }
            }
        }
        
        AppDelegate.Facebook.login(OnVC: self) { (success) in
            if let token = FBSDKAccessToken.current(), let tokenString = token.tokenString{
                AppSingleton.shared.facebookConnect(idToken: tokenString, completion: { (success) in
                    completion(success: success)
                })
            }
            else{
                completion(success: false)
            }
        }
    }
    
}
