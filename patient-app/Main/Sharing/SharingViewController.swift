//
//  SharingViewController.swift
//  patient-app
//
//  Created by Elliott Brunet on 05.06.19.
//  Copyright © 2019 Elliott Brunet. All rights reserved.
//

import UIKit

class SharingViewController: UITableViewController {
    
    private let dbHandler = DBHandler.sharedInstance
    private let sharingEventCell = "SharingEventCell"
    private var sharingEvents: [SharingEvent] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    func getSharingEvents() {
        sharingEvents = try! dbHandler.getSharingEvents()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.register(SharingEventCell.self, forCellReuseIdentifier: "SharingEventCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.yellow
        nav?.topItem?.title = "Freigegeben"
        getSharingEvents()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sharingEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharingEventCell", for: indexPath) as! SharingEventCell
        cell.configureCellForEvent(event: sharingEvents[indexPath.row])
        cell.delegate = self
        return cell
     }

}

extension SharingViewController: InnerTableCellDelegate {
    func stopSharing(event: SharingEvent) {
        dbHandler.updateToStopSharingState(sharingEvent: event)
        getSharingEvents()
    }
}


