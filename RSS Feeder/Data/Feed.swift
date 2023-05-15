//
//  DataModel.swift
//  RSS Feeder
//
//  Created by muhammad.alfarisi on 14/05/23.
//

import Foundation

class Feed {
    var id: Int64?
    var name: String?
    var address: String?
    
    init?(id: Int64? = nil, name: String? = "", address: String? = "") {
        self.id = id
        self.name = name
        self.address = address
        
        if name == nil || address == nil {
            return nil
        }
    }
//    
//    func getName() -> String {
//        return name!
//    }
//    func getAddress() -> String {
//        return address!
//    }
//    func getId() -> Int64 {
//        return id!
//    }
}
