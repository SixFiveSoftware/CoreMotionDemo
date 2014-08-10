//
//  ViewController.swift
//  CoreMotionDemo
//
//  Created by BJ Miller on 8/6/14.
//  Copyright (c) 2014 Six Five Software, LLC. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let pedometer = CMPedometer()
    var lastDistance = 0.0
    var lastUpdatedDate = NSDate()
    let dateFormatter = NSDateFormatter()

    @IBOutlet weak var stepCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
    }
    
    override func viewWillAppear(animated: Bool) {
        setupPedometer()
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(animated: Bool) {
        pedometer.stopPedometerUpdates()
        super.viewWillDisappear(animated)
    }

    func setupPedometer() {
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startPedometerUpdatesFromDate(midnight) { pedometerData, pedError in
                if pedError != nil {
                    // failed, handle error
                } else {
                    let meters = pedometerData.distance.doubleValue
                    let distanceFormatter = NSLengthFormatter()

                    let timeDelta = pedometerData.endDate.timeIntervalSinceDate(self.lastUpdatedDate)
                    let distanceDelta = meters - self.lastDistance
                    let rate = distanceDelta / timeDelta
                    
                    self.lastUpdatedDate = NSDate()
                    self.lastDistance = meters

                    dispatch_async(dispatch_get_main_queue()) {
                        self.stepCountLabel.text = "\(pedometerData.numberOfSteps.integerValue) steps"
                        self.distanceLabel.text = "\(distanceFormatter.stringFromMeters(meters))"
                        self.rateLabel.text = "\(distanceFormatter.stringFromMeters(rate)) / s"
                        self.lastUpdatedLabel.text = "Last updated: \(self.dateFormatter.stringFromDate(pedometerData.endDate))"
                    }
                }
            }
        }
    }
    
    var midnight: NSDate {
        let cal = NSCalendar.autoupdatingCurrentCalendar()
        return cal.startOfDayForDate(NSDate())
    }

}

