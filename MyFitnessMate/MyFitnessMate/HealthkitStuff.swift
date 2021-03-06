//
//  HealthkitStuff.swift
//  MyFitnessMate
//
//  Created by BLICHARZ, PATRYK on 04/03/2020.
//  Copyright © 2020 BLICHARZ, PATRYK. All rights reserved.
//

import Foundation
import UIKit
import HealthKit
import UserNotifications

class HealthkitStuff {
    let healthStore: HKHealthStore = HKHealthStore()
    init(){
    
    }

func authorizeHealthKit(completion: ((_ success: Bool, _ error: Error?) -> Void)!) {
    
    let stepCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
    let calories = HKObjectType.quantityType(forIdentifier: .dietaryEnergyConsumed)
    let weight = HKObjectType.quantityType(forIdentifier: .bodyMass)
    let exercise = HKObjectType.quantityType(forIdentifier: .appleExerciseTime)
    let waterCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
    let sleep = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis)
    let stand = HKObjectType.categoryType(forIdentifier: .appleStandHour)
    let mind = HKObjectType.categoryType(forIdentifier: .mindfulSession)!
    let move = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
    //health variables
    
    let dataTypesToRead: Set<HKObjectType> = [stepCount!, waterCount!, HKWorkoutType.workoutType(), stand!, mind, HKActivitySummaryType.activitySummaryType(), move, exercise!, sleep!, calories!, weight!]
    
    let dataTypesToWrite: Set<HKSampleType> = []
    
    if !HKHealthStore.isHealthDataAvailable() {
        let error = NSError(domain: "some.random.domain.idk", code: 7, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available on this device. Consider using a different device."])
        if completion != nil {
            completion(false, error)
        }
        return
    }
    
    healthStore.requestAuthorization(toShare: dataTypesToWrite, read: dataTypesToRead) {(success, error) ->Void in
        if completion != nil {
            self.startObservingQueries()
            completion(success, error)
        }
    }
}

func startObservingQueries() {
    
    DispatchQueue.main.async(execute: self.startObservingStepChanges)
    DispatchQueue.main.async(execute: self.startObservingBodyMass)
    DispatchQueue.main.async(execute: self.startObservingSleep)
    DispatchQueue.main.async(execute: self.startObservingExerciseChanges)
    DispatchQueue.main.async(execute: self.startObservingCalorieChanges)
    DispatchQueue.main.async(execute: self.startObservingActiveCalories)
    DispatchQueue.main.async(execute: self.startObservingMindSessions)
    DispatchQueue.main.async(execute: self.startObservingStandHours)
    DispatchQueue.main.async(execute: self.startObservingWaterChanges)
    DispatchQueue.main.async(execute: self.startObservingWorkoutChanges)
    }
    
    func startObservingStandHours() {
        
        let sampleType = HKObjectType.categoryType(forIdentifier: .appleStandHour)!
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueHandler)
        
        healthStore.execute(query)
        healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in
            if succeeded {
                print("Background delivery of stand hour changes - enabled")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of stand hour changes")
                    print("Error = \(theError)")
                }
            }
        })
    }
    
    func startObservingWorkoutChanges() {
        let sampleType = HKObjectType.workoutType()
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueHandler)
        
        healthStore.execute(query)
        healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in
            if succeeded {
                print("Background delivery of workout changes - enabled")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of workout changes")
                    print("Error = \(theError)")
                }
            }
        })
    }
    
    func startObservingWaterChanges() {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryWater)
        let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueHandler)
        healthStore.execute(query)
        healthStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in
            if succeeded {
                print("Background delivery of water changes - enabled")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of water changes")
                    print("Error = \(theError)")
                }
            }
        })
        
    }
    
    func startObservingCalorieChanges() {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)
               let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueHandler)
               healthStore.execute(query)
               healthStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in
                   if succeeded {
                       print("Background delivery of calorie changes - enabled")
                   } else {
                       if let theError = error {
                           print("Failed to enable background delivery of calorie changes")
                           print("Error = \(theError)")
                       }
                   }
               })
    }
    
    func startObservingBodyMass() {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
                     let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueHandler)
                     healthStore.execute(query)
                     healthStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in
                         if succeeded {
                             print("Background delivery of body mass - enabled")
                         } else {
                             if let theError = error {
                                 print("Failed to enable background delivery of body mass")
                                 print("Error = \(theError)")
                             }
                         }
                     })
    }
    
    func startObservingActiveCalories() {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
                     let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueHandler)
                     healthStore.execute(query)
                     healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in
                         if succeeded {
                             print("Background delivery of active energy - enabled")
                         } else {
                             if let theError = error {
                                 print("Failed to enable background delivery of active energy")
                                 print("Error = \(theError)")
                             }
                         }
                     })
    }
    
    func startObservingSleep() {
        let sampleType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
                     let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType, predicate: nil, updateHandler: self.valueHandler)
                     healthStore.execute(query)
                     healthStore.enableBackgroundDelivery(for: sampleType, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in
                         if succeeded {
                             print("Background delivery of sleep readings - enabled")
                         } else {
                             if let theError = error {
                                 print("Failed to enable background delivery of sleep readings")
                                 print("Error = \(theError)")
                             }
                         }
                     })
    }
    
    func startObservingExerciseChanges() {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
                     let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueHandler)
                     healthStore.execute(query)
                     healthStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in
                         if succeeded {
                             print("Background delivery of exercise changes - enabled")
                         } else {
                             if let theError = error {
                                 print("Failed to enable background delivery of exercise changes")
                                 print("Error = \(theError)")
                             }
                         }
                     })
    }
    
    func startObservingStepChanges() {
        let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
                     let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueHandler)
                     healthStore.execute(query)
                     healthStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in
                         if succeeded {
                             print("Background delivery of step changes - enabled")
                         } else {
                             if let theError = error {
                                 print("Failed to enable background delivery of step changes")
                                 print("Error = \(theError)")
                             }
                         }
                     })
    }
    
    func startObservingMindSessions() {
        let sampleType = HKObjectType.categoryType(forIdentifier: .mindfulSession)
                     let query: HKObserverQuery = HKObserverQuery(sampleType: sampleType!, predicate: nil, updateHandler: self.valueHandler)
                     healthStore.execute(query)
                     healthStore.enableBackgroundDelivery(for: sampleType!, frequency: .immediate, withCompletion: {(succeeded: Bool, error: Error!) in
                         if succeeded {
                             print("Background delivery of mind session changes - enabled")
                         } else {
                             if let theError = error {
                                 print("Failed to enable background delivery of mind session changes")
                                 print("Error = \(theError)")
                             }
                         }
                     })
    }
    
    func getStepsData(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        
        let startDate = cal.startOfDay(for: date)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let endDate = cal.date(byAdding: components, to: startDate)
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: HKQueryOptions())
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents: interval as DateComponents)
        query.initialResultsHandler = {query, results, error in
            if error != nil {
                print("something went wrong")
                return
            }
            var steps = 0.0
            if let myResults = results, let endDate = endDate {
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        steps = quantity.doubleValue(for: HKUnit.count())
                    }
                }
            }
            completion(round(steps), error)
        }
        healthStore.execute(query)
    }
    
    func getMindSesions() {
        
    }
    
    func getExercsieData() {
        
    }
    
    func getSleepAnalysisData() {
        
    }
    
    func getActiveEnergyData(forDate date: Date, _ completion: ((Double, Error?) -> Void)!) {
        let cal = Calendar.current
        let startDate = cal.startOfDay(for: date)
        var comps = DateComponents()
        comps.day = 1
        comps.second = -1
        let endDate = cal.date(byAdding: comps, to: startDate)
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: startDate as Date, intervalComponents: interval as DateComponents)
        query.initialResultsHandler = {query, results, error in
            
            if error != nil {
                print("something went wrong")
                return
            }
            var calories = 0.0
            if let myResults = results, let endDate = endDate {
                myResults.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                    if let quantity = statistics.sumQuantity() {
                        calories = quantity.doubleValue(for: HKUnit.kilocalorie())
                    }
                }
            }
            completion(round(calories), error)
        }
        healthStore.execute(query)
    }
    
    func getWorkoutData() {
        
    }
    
    func getCaloriesData() {
        
    }
    
    func getStandHoursData() {
        
    }
    
    func getActivityRingsData() {
        
    }
    
    func getWaterData() {
        
    }
    
    func getBodyMassData() {
        
    }
    
    
    
    func valueHandler(query: HKObserverQuery!, completionHandler: HKObserverQueryCompletionHandler!, error: Error!){
        //load() //some data loading function TBD
        completionHandler()
    }
}
