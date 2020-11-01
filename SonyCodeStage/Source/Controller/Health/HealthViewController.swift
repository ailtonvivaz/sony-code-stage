//
//  HealthViewController.swift
//  SonyCodeStage
//
//  Created by Ailton Vieira Pinto Filho on 31/10/20.
//

import HealthKit
import MediaPlayer
import StoreKit
import UIKit

class HealthViewController: UIViewController {
    let healthStore = HKHealthStore()
    let storeIds: [String] = [ "ID from earlier"]

    let player = MPMusicPlayerController.applicationMusicPlayer
    lazy var queue  = MPMusicPlayerStoreQueueDescriptor(storeIDs: storeIds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player.prepareToPlay()
        
        SKCloudServiceController.requestAuthorization { status in
            if status == .authorized {
                MusicService.shared.searchAppleMusic("thunder") { songs in
                    
                    self.queue.storeIDs = songs.map(\.id)
                    
                    

                    self.player.setQueue(with: self.queue)
                    self.player.play()
//                    print(songs)
                }
            }
        }

        // Do any additional setup after loading the view.
        fetchHealthData()
    }

    func fetchHealthData() {
        if HKHealthStore.isHealthDataAvailable() {
            let readData = Set([
                HKObjectType.quantityType(forIdentifier: .heartRate)!
            ])
        
            healthStore.requestAuthorization(toShare: [], read: readData) { success, error in
                if success {
                    let calendar = NSCalendar.current
                
                    var anchorComponents = calendar.dateComponents([.day, .month, .year, .weekday, .hour, .minute], from: NSDate() as Date)
                    anchorComponents.minute! -= 1

                    guard let anchorDate = Calendar.current.date(from: anchorComponents) else {
                        fatalError("*** unable to create a valid date from the given components ***")
                    }
//
                    let interval = NSDateComponents()
                    interval.second = 10
                                    
                    guard let quantityType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
                        fatalError("*** Unable to create a step count type ***")
                    }

                    let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                                            quantitySamplePredicate: nil,
                                                            options: .discreteAverage,
                                                            anchorDate: anchorDate,
                                                            intervalComponents: interval as DateComponents)
                
                    query.initialResultsHandler = {
                        _, results, error in
                    
                        guard let statsCollection = results else {
                            fatalError("*** An error occurred while calculating the statistics: \(String(describing: error?.localizedDescription)) ***")
                        }
                        
                        //
                        let endDate = Date()
                                                
                        guard let startDate = calendar.date(byAdding: .minute, value: -5, to: endDate) else {
                            fatalError("*** Unable to calculate the start date ***")
                        }
                        statsCollection.enumerateStatistics(from: startDate, to: endDate) { statistics, _ in
                            if let quantity = statistics.averageQuantity() {
                                let date = statistics.startDate
                                // for: E.g. for steps it's HKUnit.count()
                                let value = quantity.doubleValue(for: HKUnit(from: "count/min"))
                                print("done", date, value)
                            }
                        }
                    }
                    
                    query.statisticsUpdateHandler = { _, statistics, _, _ in
                        if let statistics = statistics, let quantity = statistics.averageQuantity() {
                            let date = statistics.startDate
                            // for: E.g. for steps it's HKUnit.count()
                            let value = quantity.doubleValue(for: HKUnit(from: "count/min"))
                            print("done", date, value)
                        }
                    }
                
                    self.healthStore.execute(query)
                
                } else {
                    print("Authorization failed")
                }
            }
        }
    }
}
