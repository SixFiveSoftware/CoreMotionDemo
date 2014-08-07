First, import CoreMotion framework.  

    import CoreMotion

Next, create an instance of CMPedometer.

    let pedometer = CMPedometer()

Create a function to set up the pedometer.

    func setupPedometer() {

    }

Check if step counting is available., and if so, start pedometer updates.

    if CMPedometer.isStepCountingAvailable() {
        self.pedometer.startPedometerUpdatesFromDate(midnight) {

        }
    }
Calculated property to generate midnight value.

    var midnight: NSDate {
        let cal = NSCalendar.autoupdatingCurrentCalendar()
        return cal.startOfDayForDate(NSDate())
    }

Fill in handler closure for startPedometerUpdatesFromDate.

    pedometerData, pedError in
    if pedError != nil {
        // failed
    } else {
        // succeeded
    }

Update UI with number of steps.

    dispatch_async(dispatch_get_main_queue()) {
        self.stepCountLabel.text = "\(pedometerData.numberOfSteps.integerValue) steps"
    }

Call setupPedometer() in viewWillAppear.

    override func viewWillAppear(animated: Bool) {
        setupPedometer()
        super.viewWillAppear(animated)
    }

Be a good citizen and stop pedometer updates in viewWillDisappear.

    override func viewWillDisappear(animated: Bool) {
        pedometer.stopPedometerUpdates()
        super.viewWillDisappear(animated)
    }

Run.

Let's calculate distance. In success block, get distance in meters.

    let meters = pedometerData.distance.doubleValue
    let distanceFormatter = NSLengthFormatter()

Update UI for distance.

    self.distanceLabel.text = "\(distanceFormatter.stringFromMeters(meters))"

Run.

Let's calculate our rate. Because the Pedometer returns cumulative data from our start date, we need to calculate the time and distance diffs manually.  

Create lastDistance and lastUpdatedDate property.

    var lastDistance = 0.0
    var lastUpdatedDate: NSDate?

Calculate time and distance deltas. This goes between distanceFormatter and lastDistance.

    let timeDelta = pedometerData.endDate.timeIntervalSinceDate(self.lastUpdatedDate)
    let distanceDelta = meters - self.lastDistance
    let rate = distanceDelta / timeDelta

    self.lastUpdatedDate = NSDate()
    self.lastDistance = meters

Update UI in dispatch_async closure.

    self.rateLabel.text = "\(distanceFormatter.stringFromMeters(rate)) / s"

Run.

Add last updated date. First, a date formatter property.

    let dateFormatter: NSDateFormatter()

Initialize the dateFormatter in viewDidLoad.

    dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
    dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle

Update UI in dispatch_async closure.

    self.lastUpdatedLabel.text = "Last updated: \(self.dateFormatter.stringFromDate(pedometerData.endDate))"

Run.
