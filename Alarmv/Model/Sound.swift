//
//  Sound.swift
//  Alarmv
//
//  Created by vlsuv on 14.12.2020.
//  Copyright © 2020 vlsuv. All rights reserved.
//

import Foundation

public class Sound: NSObject, NSCoding {
    
    let name: String
    let fileName: String
    
    enum PropertyKeys {
        static let name = "name"
        static let fileName = "fileName"
    }
    
    init(name: String, fileName: String) {
        self.name = name
        self.fileName = fileName
    }
    
    public required init?(coder: NSCoder) {
        self.name = coder.decodeObject(forKey: PropertyKeys.name) as? String ?? ""
        self.fileName = coder.decodeObject(forKey: PropertyKeys.fileName) as? String ?? ""
        super.init()
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: PropertyKeys.name)
        coder.encode(self.fileName, forKey: PropertyKeys.fileName)
    }
}
