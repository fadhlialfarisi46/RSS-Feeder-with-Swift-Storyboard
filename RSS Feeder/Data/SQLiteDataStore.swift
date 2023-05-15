//
//  SQLiteDataStore.swift
//  RSS Feeder
//
//  Created by muhammad.alfarisi on 14/05/23.
//

import Foundation
import SQLite

enum DataAccessError: Error {
case DataStore_Connection_error
case Insert_Error
case Delete_Error
case Search_Error
case Nil_In_Data
}

class SQLiteDataStore {
    static let sharedIntance = SQLiteDataStore()
    let BBDB: Connection?
    
    private init() {
        var path = "db.sqlite"
        
        if let dirs: [NSString] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .allDomainsMask, true) as [NSString]? {
            let dir = dirs[0]
            path = dir.appendingPathComponent("db.sqlite")
            print(path)
        }
        
        do {
            BBDB = try Connection (path)
        } catch _ {
            BBDB = nil
        }
    }
    
    func createTable() throws {
        do {
            try FeedDataHelper.createTable()
        } catch {
            throw DataAccessError.DataStore_Connection_error
        }
    }
}
