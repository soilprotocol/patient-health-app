//
//  ViewController.swift
//  patient-app
//
//  Created by Elliott Brunet on 05.06.19.
//  Copyright © 2019 Elliott Brunet. All rights reserved.
//

import UIKit

class DataOverviewViewController: UITableViewController {
    
    var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.black
        nav?.tintColor = UIColor.yellow
        nav?.topItem?.title = "Gesundsheitsdaten"
        
        setupAddButton()
    }
    
    fileprivate func setupAddButton() {
        addButton = UIButton(type: .system)
        addButton.titleLabel?.font =  UIFont(name: "Kailasa-Bold", size: 23)
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = UIColor.red
        addButton.setTitleColor(UIColor.white, for: .normal)
        addButton?.setTitle("+", for: .normal)
//        addButton.addTarget(self, action: #selector(denyRequest), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(addButton, at: 3)
        setupAddButtonConstraints()
    }
    
    func setupAddButtonConstraints(){
        let margins = view.layoutMarginsGuide
        addButton.rightAnchor.constraint(equalTo: margins.rightAnchor, constant: 25).isActive = true
        addButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -30).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }


}

