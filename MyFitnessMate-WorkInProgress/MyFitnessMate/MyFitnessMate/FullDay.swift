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
                attributes.append(Attribute(type: AttributeType.init(rawValue: attribute)!, value: 0))
            }
        } else {
            attributes.append(Attribute(type: .steps, value: 0))
            attributes.append(Attribute(type: .sleep, value: 0))
            attributes.append(Attribute(type: .move, value: 0))
            attributes.append(Attribute(type: .rings, value: 0))
            attributes.append(Attribute(type: .calories, value: 0))
            attributes.append(Attribute(type: .workouts, value: 0))
            attributes.append(Attribute(type: .water, value: 0))
            attributes.append(Attribute(type: .exercise, value: 0))
            attributes.append(Attribute(type: .stand, value: 0))
            attributes.append(Attribute(type: .mind, value: 0))
            saveAttributeOrder()
        }
    }
    static let shared = FullDay()
    var date: Date = Date()
    var attributes: [Attribute] = []
    var defaultAttributes: [String]? = []
    var moveGoal: Double = 0.0
    var bodyMass: Double = 0.0
    let defaults = UserDefaults(suiteName: "MyFitnessMate")
    
    func setUpdateNotifications() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUIFromFullDay"),object: nil)
        print("Notification sent")
    }
    
    func saveAttributeOrder() {
        defaultAttributes = attributes.map({$0.type.rawValue})
        defaults?.set(defaultAttributes, forKey: "attributeOrder")
    }
    
    func getScore() -> Int {
        var score = 0
        let cal = Calendar.current
        let dateComponents = cal.dateComponents(
            [ .year, .month, .day ],
            from: Date()
        )
        
        for a in attributes {
            score += a.getScore(withWeight: 1, withBodyMass: bodyMass)
        }
        if let index = history.
    }
    
}
