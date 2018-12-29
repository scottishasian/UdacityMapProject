//
//  CellView.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 29/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import UIKit

class CellView: UITableViewCell {

    static let cellIdentifier = "CellView"
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelURL: UILabel!
    
    
    
    func configureCell(_ info: StudentDetails) {
        labelName.text = info.label
        labelURL.text = info.mediaURL
        
    }

}
