//
//  HistoryAttribute.swift
//  MyFitnessMate
//
//  Created by BLICHARZ, PATRYK on 12/03/2020.
//  Copyright © 2020 BLICHARZ, PATRYK. All rights reserved.
//

import Foundation

class HistoryAttribute {
    var type: HistoryAttributeType
    var value: Int = 0 {
        
        didSet {
            if value != oldValue {
                FullDay.shared.setUpdateNotifications()
            }
        }
    }
    
    init(type: HistoryAttributeType, value: Int) {
        self.type = type
        self.value = value
    }
    
    func getScore(withHistoryDay day: HistoryDay) -> Int {
        return type.calculateScore(withHistoryDay: day, forValue: Double(value))
    }
}
