//
//  FeedDataHelper.swift
//  RSS Feeder
//
//  Created by muhammad.alfarisi on 14/05/23.
//

import Foundation
import SQLite

protocol DataHelperProtocol {
    associatedtype T
    static func createTable() throws -> Void
    static func insert(item: T) throws -> Int64
    static func delete(item: T) throws -> Void
    static func findAll() throws -> [T]?
}

class FeedDataHelper: DataHelperProtocol {

    static let TABLE_NAME = "Feeds"
    static let table = Table(TABLE_NAME)
    static let id = Expression<Int64> ("id")
    static let name = Expression<String> ("name")
    static let address = Expression<String> ("address")
    
    typealias T = Feed

    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedIntance.BBDB else {
            throw DataAccessError.DataStore_Connection_error
        }
        do {
            try DB.run(table.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(name)
                t.column(address)
            })
        } catch _ {
            print("error")
        }
    }
    
    static func insert(item: Feed) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedIntance.BBDB else {
            throw DataAccessError.DataStore_Connection_error
        }
        if (item.name != nil && item.address != nil) {
            let insert = table.insert(name <- item.name!, address <- item.address!)
            do {
                let rowId: Int64 = try DB.run(insert)
                guard rowId > 0 else {
                    throw DataAccessError.Insert_Error
                }
                return rowId
            } catch _ {
                throw DataAccessError.Nil_In_Data
            }
        }
        throw DataAccessError.Nil_In_Data
    }
    
    static func delete(item: Feed) throws {
        guard let DB = SQLiteDataStore.sharedIntance.BBDB else {
            throw DataAccessError.DataStore_Connection_error
        }
        let query = table.filter(id == item.id!)
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
    }
    
    static func findAll() throws -> [Feed]? {
        guard let DB = SQLiteDataStore.sharedIntance.BBDB else {
            throw DataAccessError.DataStore_Connection_error
        }
        var retArray = [T]()
        let items = try DB.prepare(table)
        for item in items {
            retArray.append(Feed(id: item[id], name: item[name], address: item[address])!)
        }
        return retArray
    }
    
    static func find(id: Int64) throws -> Feed? {
        guard let DB = SQLiteDataStore.sharedIntance.BBDB else {
            throw DataAccessError.DataStore_Connection_error
        }
        let query = table.filter(id == self.id)
        let items = try DB.prepare(query)
        for item in items {
           return Feed(id: item[self.id], name: item[name], address: item[address])
        }
        return nil
    }

    
}
