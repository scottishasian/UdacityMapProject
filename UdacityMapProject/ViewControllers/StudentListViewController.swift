//
//  StudentListViewController.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 29/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit

class StudentListViewController: UIViewController, SelectStudentLocationDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var dataProvider: DataProvider!
    @IBOutlet weak var reloadIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startMapReload), name: .startMapReload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMapCompleted), name: .reloadMapCompleted, object: nil)
        
        dataProvider.delegate = self
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
        
        reloadMapCompleted()
    }
    
    @objc func startMapReload() {
        performUIUpdatesOnMain {
            self.reloadIndicator.startAnimating()
            
        }
    }
    
    @objc func reloadMapCompleted() {
        performUIUpdatesOnMain {
            self.reloadIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    func didSelectStudentLocation(information: StudentDetails) {
        openLink(information.mediaURL)
    }
    
    

}

