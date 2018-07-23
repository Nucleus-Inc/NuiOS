//
//  AccountRecoverWayTVC.swift
//  Upme-Customer
//
//  Created by Nucleus on 19/01/18.
//  Copyright © 2018 Nucleus. All rights reserved.
//

import UIKit
import NuSignUp

class AccountRecoverWayTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.sectionFooterHeight = 0.01
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navC = self.navigationController as? SignUpNavController{
            navC.updateForStep(step: 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            SignUpStack.config.finishSignUp()
        })
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    // MARK: - Navigation

}
