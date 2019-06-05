//
//  HistoryViewController.swift
//  patient-app
//
//  Created by Elliott Brunet on 05.06.19.
//  Copyright © 2019 Elliott Brunet. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.yellow
        nav?.topItem?.title = "Sharing History"
        
    }

}
