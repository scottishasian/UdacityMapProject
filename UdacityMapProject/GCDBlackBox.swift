//
//  GCDBlackBox.swift
//  UdacityMapProject
//
//  Created by Kynan Song on 03/12/2018.
//  Copyright © 2018 Kynan Song. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
