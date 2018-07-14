//
//  ProfileTVC.swift
//  NuiOS
//
//  Created by Nucleus on 13/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit

struct ProfileTVCCellsIDs{
    static let imageCell = "imageCell"
    static let nameCell = "nameCell"
    static let emailCell = "emailCell"
    static let phoneNumberCell = "phoneNumberCell"
}

class ProfileTVC: UITableViewController {

    @IBOutlet weak var addImageLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImageView()
        loadUserData()
        self.tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - ImageView methods
    
    func setImageWith(URL url:String){
        self.addImageLabel.isHidden = true
    }
    
    func setUpImageView(){
        userImageView.layer.borderColor = userImageView.tintColor.cgColor
        userImageView.layer.borderWidth = 1
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(ProfileTVC.addImageAction))
        userImageView.addGestureRecognizer(tapGes)
    }
    
    @objc
    func addImageAction(){
        let alertC = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default) { (_) in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        alertC.addAction(cameraAction)
        alertC.addAction(galleryAction)
        alertC.addAction(cancelAction)
        
        self.present(alertC, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Methods
    
    func loadUserData(){
        let account = AppSingleton.shared.user?.account
        nameTF.text = account?.name
        emailLabel.text = account?.email
        phoneNumberLabel.text = account?.phoneNumber
    }
    
    private func logout(){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            AppSingleton.shared.logout()
            appDelegate.window?.rootViewController = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateInitialViewController()
        }
    }
    func didTapLogOutCell(){
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (_) in
            self.logout()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        let alertC = UIAlertController(title: "Logout", message: "Do you want to continue ?", preferredStyle: .alert)
        alertC.addAction(yesAction)
        alertC.addAction(noAction)
        
        self.present(alertC, animated: true, completion: nil)
    }

    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 5 : 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.01
        }
        return super.tableView(tableView, heightForHeaderInSection: section)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        if section == 1{
            if row == 0{
                didTapLogOutCell()
            }
        }
    }

}
