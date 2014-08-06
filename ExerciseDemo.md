First, import CoreMotion framework.  

    import CoreMotion

Next, create an instance of CMPedometer.

    let pedometer = CMPedometer()

Create a function to set up the pedometer.

    func setupPedometer() {

    }

Check if step counting is available., and if so, start pedometer updates.

    if CMPedometer.isStepCountingAvailable() {
        self.pedometer.startPedometerUpdatesFromDate(self.midnight()) {

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

Be a good citizen and stop pedometer updates in viewWillDisappear.

    override func viewWillDisappear(animated: Bool) {
        pedometer.stopPedometerUpdates()
        super.viewWillDisappear(animated)
    }

Call setupPedometer() in viewWillAppear.

    override func viewWillAppear(animated: Bool) {
        setupPedometer()
        super.viewWillAppear(animated)
    }

Run.


