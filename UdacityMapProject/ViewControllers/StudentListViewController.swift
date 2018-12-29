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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataProvider.delegate = self
        tableView.dataSource = dataProvider
        tableView.delegate = dataProvider
    }
    
    func didSelectStudentLocation(information: StudentDetails) {
        openLink(information.mediaURL)
    }

}

