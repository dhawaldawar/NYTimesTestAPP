//
//  ReachabilityManager .swift
//  MyTaxiTest
//
//  Created by Dhawal Dawar on 26/09/18.
//  Copyright © 2018 DhawalDawar. All rights reserved.
//

import Foundation

class ReachabilityManager: NSObject {
    @objc static let shared = ReachabilityManager()
    @objc var isInternetAvailable = false
    
    private var internetReachability : Reachability!
    
    override init() {
        super.init()
    }
    
    @objc func setup(){
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)

        internetReachability = Reachability.forInternetConnection()
        internetReachability.startNotifier()
        reachabilityChanged()
    }
    
    @objc private func reachabilityChanged(){
        isInternetAvailable = (internetReachability.currentReachabilityStatus() != NetworkStatus.init(0))
    }
}
