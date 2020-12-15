//
//  Weekday.swift
//  Alarmv
//
//  Created by vlsuv on 08.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import Foundation

public class RepeatDay: NSObject, NSCoding {
   
    let name: String
    let id: Int?
    
    enum PropertyKeys {
        static let name = "name"
        static let id = "id"
    }
    
    init(name: String, id: Int) {
        self.name = name
        self.id = id
    }
    
    public required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: PropertyKeys.name) as? String ?? ""
        self.id = coder.decodeObject(forKey: PropertyKeys.id) as? Int ?? 0
        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: PropertyKeys.name)
        coder.encode(self.id, forKey: PropertyKeys.id)
    }
    
    static func ==(lhs: RepeatDay, rhs: RepeatDay) -> Bool {
        return lhs.id == rhs.id
    }
}
