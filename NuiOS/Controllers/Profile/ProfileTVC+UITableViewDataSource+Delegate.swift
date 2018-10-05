//
//  ProfileTVC+UITableViewDataSource+Delegate.swift
//  NuiOS
//
//  Created by Nucleus on 18/07/2018.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit
import GoogleSignIn

extension ProfileTVC{
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 5 : 2
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
            else if row == 1{
                
                if let user = GIDSignIn.sharedInstance().currentUser, let token = user.authentication.idToken{
                    let serverCode = user.serverAuthCode ?? ""
                    let info = "-> idToken: "+token+"\n\n -> serverAuthCode: "+serverCode
                    
                    let activityVC = UIActivityViewController(activityItems: [info], applicationActivities: [])
                    
                    activityVC.excludedActivityTypes = [UIActivityType.assignToContact,
                                                        UIActivityType.postToFlickr,
                                                        UIActivityType.copyToPasteboard,
                                                        UIActivityType.postToTencentWeibo,
                                                        UIActivityType.postToTwitter,
                                                        UIActivityType.postToFacebook,
                                                        UIActivityType.addToReadingList,
                                                        UIActivityType.saveToCameraRoll]
                    
                    
                    self.present(activityVC, animated: true, completion: nil)
                    
                }
                
            }
        }
    }
}
