//
//  Alarm.swift
//  Alarm
//
//  Created by Brooke Kumpunen on 3/11/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import Foundation

class Alarm: Codable {
    
    var name: String
    var enabled: Bool
    var fireDate: Date
    let uuid: String = "8888"
    
    
    init(name: String, enabled: Bool = false, fireDate: Date) {
        self.name = name
        self.enabled = enabled
        self.fireDate = fireDate
    }
    
}

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.enabled == rhs.enabled && lhs.fireDate == rhs.fireDate && lhs.name == rhs.name
    }
}
