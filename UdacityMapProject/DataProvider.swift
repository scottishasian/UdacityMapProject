//
//  DataProvider.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 29/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit

protocol SelectStudentLocationDelegate: class {
    func didSelectStudentLocation(information: StudentDetails)
}

class DataProvider: NSObject, UITableViewDataSource, UITableViewDelegate{
    
    weak var delegate: SelectStudentLocationDelegate?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentsLocations.sharedData.studentsInformation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentCell = tableView.dequeueReusableCell(withIdentifier: CellView.cellIdentifier, for: indexPath) as! CellView
        studentCell.configureCell(StudentsLocations.sharedData.studentsInformation[indexPath.row])
        return studentCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectStudentLocation(information: StudentsLocations.sharedData.studentsInformation[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    
    
}
