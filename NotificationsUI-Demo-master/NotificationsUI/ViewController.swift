//
//  ViewController.swift
//  NotificationsUI
//
//  Created by Pranjal Satija on 9/12/16.
//  Copyright © 2016 Pranjal Satija. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func datePickerDidSelectNewDate(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        print("Selected date: \(selectedDate)")
        //Fetch the current instance of AppDelegate that our application is using and schedule a notification using the function scheduleNotification
        let delegate = UIApplication.shared.delegate as? AppDelegate
        delegate?.scheduleNotification(at: selectedDate)
    }
}
