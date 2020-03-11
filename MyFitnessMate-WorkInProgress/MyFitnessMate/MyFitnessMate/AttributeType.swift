//
//  AttributeType.swift
//  MyFitnessMate
//
//  Created by BLICHARZ, PATRYK on 11/03/2020.
//  Copyright © 2020 BLICHARZ, PATRYK. All rights reserved.
//

import Foundation
import UIKit

enum AttributeType: String {
    case steps = "Steps"
    case workouts = "Workouts"
    case move = "Move"
    case mind = "Mind sessions"
    case stand = "Stand hours"
    case calories = "Calories"
    case sleep = "Sleep"
    case water = "Water"
    case exercise = "Exercise"
    case rings = "Rings"
    
    
    func calculateScore(withWeight weight: Double, forValue value: Double, withBodyMass bodyMass: Double) -> Int {
        switch self {
        case .steps:
            return(Int((value/1000)*weight))
        case .stand:
            if value >= 12 {
                return Int(1*weight)
            } else {
                return 0
            }
        case .workouts:
            return Int(value*weight)
        case .water:
            if bodyMass == 0.0 {
                if value >= 64.0 {
                    return Int(1*weight)
                } else {
                    return 0
                }
        } else {
            var base = bodyMass / 2
            
            if let exercise = FullDay.shared.attributes.first(where: {$0.type == .exercise})?.value {
                let additional = Double(exercise) * 0.4
                base += additional
            }
            if value >= base {
                return 1
            }
            return 0
        }
        case .mind:
            return Int(value)
        case .exercise:
            if value >= 30 {
                let base = value/30.0
                return Int(base * weight)
            } else {
                return 0
            }
        case .move:
            let goal = FullDay.shared.moveGoal
            if goal > 0 {
                return Int((value/goal) * weight)
            } else {
                return 0
            }
        case .rings:
            let stand = (FullDay.shared.attributes.first(where: {$0.type == .stand})?.getPoints(withWeight: weight, withBodyMass: bodyMass))!
            let move = (FullDay.shared.attributes.first(where: {$0.type == .move})?.getPoints(withWeight: weight, withBodyMass: bodyMass))!
            let exercise = (FullDay.shared.attributes.first(where: {$0.type == .exercise})?.getPoints(withWeight: weight, withBodyMass: bodyMass))!
            if stand >= 1 && move >= 1 && exercise >= 1 {
                FullDay.shared.attributes.first(where: {$0.type == .rings})?.value = 3
                return Int(1 * weight)
            } else {
                var temp = 0
                if stand > 0 {
                    temp = temp + 1
                }
                if move = 0 {
                    temp = temp + 1
                }
                if exercise > 0 {
                    temp = temp + 1
                }
                FullDay.shared.attributes.first(where: {$0.type == .rings})?.value = temp
                return 0
            }
        case .sleep:
            if value >= 420 && value < 540 {
                return Int(1 * weight)
            } else {
                return 0
            }
        case .calories:
            let goal = UserDefaults.standard.double(forKey: "dailyCalorieGoal")
            
            if value > 0 && goal > 0 && value <= goal {
                return Int(1 * weight)
            } else {
                return 0
            }
        }
    }
    
    func displayText(forValue value: Int) ->String {
        switch self {
        case .steps:
            return "\(value)"
        case .stand:
            return "\(value) hours"
        case .workouts:
            return "\(value) > 10 mins"
        case .water:
            let bodyMass = FullDay.shared.bodyMass
            
            if bodyMass == 0.0 {
                return "\(value) fluid ounce"
            } else {
                var base = bodyMass / 2
                
                if let exercise = FullDay.shared.attributes.first(where: {$0.type == .exercise})?.value {
                    let additional = Double(exercise) * 0.4
                    base += additional
            }
            return "\(value) of \(Int(base)) fluid ounce"
        }
        case .mind:
            return "\(value)"
        case .move:
            return "\(value) Calories"
        case .exercise:
            return "\(value) Minutes"
        case .rings:
            return "\(value) Rings closed"
        case .sleep:
            return "\(value) Hours"
        case .calories:
            return "\(value) Consumed"
    }
}

    func getBackgroundColour() {
        
    }
}
