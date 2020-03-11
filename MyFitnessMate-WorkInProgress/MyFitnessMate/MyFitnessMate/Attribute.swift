//
//  Attribute.swift
//  MyFitnessMate
//
//  Created by BLICHARZ, PATRYK on 11/03/2020.
//  Copyright © 2020 BLICHARZ, PATRYK. All rights reserved.
//

import Foundation



class Attribute {
      //  var type: AttributeType attribute type class TBD
    var value: Int = 0 {

    
    didSet {
        if value != oldValue {
            FullDay.shared.setUpdateNotifications()
            }
        }
    }
    
    init(type: AttributeType, value: Int) {
        self.type = type
        self.value = value
    }
    
    
}
