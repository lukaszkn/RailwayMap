//
//  MainContentViewModel.swift
//  RailwayMap
//
//  Created by Lukasz on 29/05/2024.
//

import Foundation

@Observable
class MainContentViewModel {
    var tabSelection = 0
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(mainTabIndexChangeRequest(notification:)), name: .mainTabIndexChangeRequest, object: nil)
    }
    
    @objc func mainTabIndexChangeRequest(notification: NSNotification) {
        let tabIndex = notification.object as! Int
        
        self.tabSelection = tabIndex
    }
}
