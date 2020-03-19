//
//  HistoryDay.swift
//  MyFitnessMate
//
//  Created by BLICHARZ, PATRYK on 19/03/2020.
//  Copyright © 2020 BLICHARZ, PATRYK. All rights reserved.
//

import Foundation

class HistoryDay: NSObject, NSCoding {

    var date: Date = Date()
    var score: Int = 0
    var attributes: [HistoryAttribute] = []
    var moveGoal: Double = 0.0
    var bodyMass: Double = 0.0
    
    override init() {
        attributes.append(HistoryAttribute(type: .steps, value: 0))
        attributes.append(HistoryAttribute(type: .sleep, value: 0))
        attributes.append(HistoryAttribute(type: .move, value: 0))
        attributes.append(HistoryAttribute(type: .rings, value: 0))
        attributes.append(HistoryAttribute(type: .calories, value: 0))
        attributes.append(HistoryAttribute(type: .workouts, value: 0))
        attributes.append(HistoryAttribute(type: .water, value: 0))
        attributes.append(HistoryAttribute(type: .exercise, value: 0))
        attributes.append(HistoryAttribute(type: .stand, value: 0))
        attributes.append(HistoryAttribute(type: .mind, value: 0))
    }
    
    convenience init(date: Date, score: Int)
    {
        self.init()
        self.date = date
        self.score = score
    }
    func getScore() -> Int {
        var score = 0
        let cal = Calendar.current
        let dateComponents = cal.dateComponents(
            [ .year, .month, .day ],
            from: date)
        
        for a in attributes {
            score += a.getScore(withHistoryDay: self)
        }
        if let index = FullDay.shared.history.firstIndex(where: {cal.dateComponents([ .year, .month, .day], from: $0.date) == dateComponents}) {
            FullDay.shared.history[index].score = score
        } else {
            FullDay.shared.history.append(HistoryDay(date: cal.date(from: dateComponents)!, score: score))
        }
        saveHistory()
        FullDay.shared.updateWidgetValues()
        print("Get score - \(score)")
        return score
    }
    
    func saveHistory() {
        let history = FullDay.shared.history.sorted(by: {$0.date > $1.date} )
        let h = NSKeyedArchiver.archivedData(withRootObject: history)
        UserDefaults.standard.set(h, forKey: "score")
    }
    required init(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObject(forKey: "date") as! Date
        score = Int(aDecoder.decodeCInt(forKey: "score"))
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: "date")
        aCoder.encode(score, forKey: "score")
    }
    
}
