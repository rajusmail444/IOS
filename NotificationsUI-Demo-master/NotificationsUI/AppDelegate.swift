//
//  AppDelegate.swift
//  NotificationsUI
//
//  Created by Pranjal Satija on 9/12/16.
//  Copyright © 2016 Pranjal Satija. All rights reserved.
//

import UIKit
//import the UserNotification framework. All the notification-related APIs are organized in this framework
import UserNotifications

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        //call the requestAuthorization method of the notification center to ask the user’s permission for using notification. We also request the ability to display alerts and play sounds.
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
            if !accepted {
                print("Notification access denied.")
            }
        }
        
        //Define categories for actions.keep it simple and define just a single category and one action.
        let action = UNNotificationAction(identifier: "remindLater", title: "Remind me later", options: [])
        let category = UNNotificationCategory(identifier: "myCategory", actions: [action], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
    }
    
    func scheduleNotification(at date: Date) {
        //Date consists of components. An individual component represents a piece of a date, such as the hour, minute, second, etc.
        //The code we have written so far separates the date parameter into components and it saves these components in the components constant. The reason we do this is that UNCalendarNotificationTrigger requires date components, not dates, to function.
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        //However, one other oddity of UNCalendarNotificationTrigger is that the complete set of components taken directly from a date do not seem to work. Instead, we need to construct our own instance of DateComponents using some information from the existing instance we have. 
        //Below line creates a new instance of DateComponents using only the relevant information from date.
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, month: components.month, day: components.day, hour: components.hour, minute: components.minute)
        
        //make a calendar notification trigger. We have set repeats to false because we only want the notification to be appeared once.
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        //create some content to display in our notification.
        let content = UNMutableNotificationContent()
        content.title = "Tutorial Reminder"
        content.body = "Just a reminder to read your tutorial over at appcoda.com!"
        content.sound = UNNotificationSound.default()
        
        //This tells the system to use “myCategory” with new notification
        content.categoryIdentifier = "myCategory"
        
        if let path = Bundle.main.path(forResource: "logo", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                //The UserNotification framework provides the UNNotificationAttachment class for developers to add attachments to the notification. The attachment can be audio, images, and videos.
                let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("The attachment was not loaded.")
            }
        }
        
        //Create a notification request, you instantiate a UNNotificationRequest object with the corresponding content and trigger. You also need to give it a unique identifier for identifying this notification request.
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        //the last thing we have to do is add the request to the notification center that manages all notifications for your app. The notification center will listen to the appropriate event and trigger the notification accordingly.
        UNUserNotificationCenter.current().delegate = self
        
        //Before we add the notification request to the notification center, it is good to remove any existing notification requests. This step helps prevent unnecessary duplicate notifications. 
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
}

//The UNUserNotificationCenterDelegate protocol defines methods for responding to actionable notifications. So, to respond to the action, we have to extend AppDelegate to implement the UNUserNotificationCenterDelegate protocol
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
     
        if response.actionIdentifier == "remindLater" {
            let newDate = Date(timeInterval: 900, since: Date())
            
            scheduleNotification(at: newDate)
        }
    }
}
