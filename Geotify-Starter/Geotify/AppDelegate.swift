/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  let locationManager = CLLocationManager()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    //“Why did I designate the AppDelegate to do this instead of the view controller?”
    //If the device triggers a geofence event while the app isn’t running, iOS automatically relaunches the app directly into the background. This makes the AppDelegate an ideal entry point to handle the event, as the view controller may not be loaded or ready.
    
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
    UIApplication.shared.cancelAllLocalNotifications()
    return true
  }
  
  func handleEvent(forRegion region: CLRegion!) {
    //If the app is active, the code below simply shows an alert controller with the note as the message. Otherwise, it presents a location notification with the same message.
    // Show an alert if application is active
    if UIApplication.shared.applicationState == .active {
      guard let message = note(fromRegionIdentifier: region.identifier) else { return }
      window?.rootViewController?.showAlert(withTitle: nil, message: message)
    } else {
      // Otherwise present a local notification
      let notification = UILocalNotification()
      notification.alertBody = note(fromRegionIdentifier: region.identifier)
      notification.soundName = "Default"
      UIApplication.shared.presentLocalNotificationNow(notification)
    }
  }
  //This helper method retrieves the geotification note from the persistent store, based on its identifier, and returns the note for that geotification.
  func note(fromRegionIdentifier identifier: String) -> String? {
    let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) as? [NSData]
    let geotifications = savedItems?.map { NSKeyedUnarchiver.unarchiveObject(with: $0 as Data) as? Geotification }
    let index = geotifications?.index { $0?.identifier == identifier }
    return index != nil ? geotifications?[index!]?.note : nil
  }
}
extension AppDelegate: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    if region is CLCircularRegion {
      handleEvent(forRegion: region)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    if region is CLCircularRegion {
      handleEvent(forRegion: region)
    }
  }
}
