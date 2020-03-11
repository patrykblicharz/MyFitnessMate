//
//  FullDay.swift
//  MyFitnessMate
//
//  Created by BLICHARZ, PATRYK on 11/03/2020.
//  Copyright © 2020 BLICHARZ, PATRYK. All rights reserved.
//

import UIKit

public class FullDay {
    private init() {
        let defaults = UserDefaults(suiteName: "MyFitnessMate")
        defaultAttributes = defaults?.object(forKey: "attributeOrder") as? [String]
        if defaultAttributes != nil {
            for attribute in defaultAttributes! {
                attributes.append(type: AttributeType.init(rawValue: attribute)!, value:0))
            }
        }
    }
    static let shared = FullDay()
    var date: Date = Date()
    var attributes: [Attribute] = []
    var defaultAttributes: [String]? = []
    var moveGoal: Double = 0.0
    var bodyMass: Double = 0.0
    let defaults = UserDefaults(suiteName: "MyFitnessMate")
}
