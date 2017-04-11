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
import MapKit
import CoreLocation

struct PreferencesKeys {
  static let savedItems = "savedItems"
}

class GeotificationsViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  var geotifications: [Geotification] = []
  //taking each geotification and registering its associated geofence with Core Location for monitoring.
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //You set the view controller as the delegate of the locationManager instance so that the view controller can receive the relevant delegate method calls.
    locationManager.delegate = self
    //You make a call to requestAlwaysAuthorization(), which invokes a prompt to the user requesting for Always authorization to use location services. Apps with geofencing capabilities need Always authorization, due to the need to monitor geofences even when the app isn’t running. Info.plist has already been setup with a message to show the user when requesting the user’s location under the key NSLocationAlwaysUsageDescription.
    locationManager.requestAlwaysAuthorization()
    //You call loadAllGeotifications(), which deserializes the list of geotifications previously saved to NSUserDefaults and loads them into a local geotifications array. The method also loads the geotifications as annotations on the map view.
    loadAllGeotifications()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "addGeotification" {
      let navigationController = segue.destination as! UINavigationController
      let vc = navigationController.viewControllers.first as! AddGeotificationViewController
      vc.delegate = self
    }
  }
  
  // MARK: Loading and saving functions
  func loadAllGeotifications() {
    geotifications = []
    //UserDefaults as a persistence store, the list of geotifications will persist between relaunches. Retrieving the persisted data
    guard let savedItems = UserDefaults.standard.array(forKey: PreferencesKeys.savedItems) else { return }
    print("loadAllGeotifications:savedItems: \(savedItems)")
    for savedItem in savedItems {
      print("loadAllGeotifications:savedItem: \(savedItem)")
      guard let geotification = NSKeyedUnarchiver.unarchiveObject(with: savedItem as! Data) as? Geotification else { continue }
      add(geotification: geotification)
    }
  }
  
  func saveAllGeotifications() {
    var items: [Data] = []
    for geotification in geotifications {
      let item = NSKeyedArchiver.archivedData(withRootObject: geotification)
      items.append(item)
    }
    //UserDefaults as a persistence store, the list of geotifications will persist between relaunches. Inserting the data
    UserDefaults.standard.set(items, forKey: PreferencesKeys.savedItems)
  }
  
  // MARK: Functions that update the model/associated views with geotification changes
  func add(geotification: Geotification) {
    print("add:geotification: \(geotification)")
    geotifications.append(geotification)
    mapView.addAnnotation(geotification)
    addRadiusOverlay(forGeotification: geotification)
    updateGeotificationsCount()
  }
  
  func remove(geotification: Geotification) {
    print("remove:geotification: \(geotification)")
    if let indexInArray = geotifications.index(of: geotification) {
      geotifications.remove(at: indexInArray)
    }
    mapView.removeAnnotation(geotification)
    removeRadiusOverlay(forGeotification: geotification)
    updateGeotificationsCount()
  }
  
  func updateGeotificationsCount() {
    title = "Geotifications (\(geotifications.count))"
    navigationItem.rightBarButtonItem?.isEnabled = (geotifications.count < 20)
  }
  
  // MARK: Map overlay functions
  func addRadiusOverlay(forGeotification geotification: Geotification) {
    mapView?.add(MKCircle(center: geotification.coordinate, radius: geotification.radius))
  }
  
  func removeRadiusOverlay(forGeotification geotification: Geotification) {
    // Find exactly one overlay which has the same coordinates & radius to remove
    guard let overlays = mapView?.overlays else { return }
    for overlay in overlays {
      guard let circleOverlay = overlay as? MKCircle else { continue }
      let coord = circleOverlay.coordinate
      if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
        mapView?.remove(circleOverlay)
        break
      }
    }
  }
  
  // MARK: Other mapview functions
  @IBAction func zoomToCurrentLocation(sender: AnyObject) {
    mapView.zoomToUserLocation()
  }
  
  //Core Location requires each geofence to be represented as a CLCircularRegion instance before it can be registered for monitoring. To handle this requirement, you’ll create a helper method that returns a CLCircularRegion from a given Geotification object.
  func region(withGeotification geotification: Geotification) -> CLCircularRegion {
    
    // You initialize a CLCircularRegion with the location of the geofence, the radius of the geofence and an identifier that allows iOS to distinguish between the registered geofences of a given app. The initialization is rather straightforward, as the Geotification model already contains the required properties.
    let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
    
    // The CLCircularRegion instance also has two Boolean properties, notifyOnEntry and notifyOnExit. These flags specify whether geofence events will be triggered when the device enters and leaves the defined geofence, respectively. Since you’re designing your app to allow only one notification type per geofence, you set one of the flags to true while you set the other to false, based on the enum value stored in the Geotification object.
    region.notifyOnEntry = (geotification.eventType == .onEntry)
    region.notifyOnExit = !region.notifyOnEntry
    return region
  }
  
  func startMonitoring(geotification: Geotification) {
    // isMonitoringAvailableForClass(_:) determines if the device has the required hardware to support the monitoring of geofences. If monitoring is unavailable, you bail out entirely and alert the user accordingly. showSimpleAlertWithTitle(_:message:viewController) is a helper function in Utilities.swift that takes in a title and message and displays an alert view.
    if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
      showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
      return
    }
    
    // Next, you check the authorization status to ensure that the app has also been granted the required permission to use Location Services. If the app isn’t authorized, it won’t receive any geofence-related notifications.
    //However, in this case, you’ll still allow the user to save the geotification, since Core Location lets you register geofences even when the app isn’t authorized. When the user subsequently grants authorization to the app, monitoring for those geofences will begin automatically.
    if CLLocationManager.authorizationStatus() != .authorizedAlways {
      showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
    }
    
    // You create a CLCircularRegion instance from the given geotification using the helper method you defined earlier.
    let region = self.region(withGeotification: geotification)
    
    // Finally, you register the CLCircularRegion instance with Core Location for monitoring.
    locationManager.startMonitoring(for: region)
  }
  
  //The method simply instructs the locationManager to stop monitoring the CLCircularRegion associated with the given geotification.
  func stopMonitoring(geotification: Geotification) {
    for region in locationManager.monitoredRegions {
      guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
      locationManager.stopMonitoring(for: circularRegion)
    }
  }
  
}

// MARK: AddGeotificationViewControllerDelegate
extension GeotificationsViewController: AddGeotificationsViewControllerDelegate {
  
  //The method is the delegate call invoked by the AddGeotificationViewController upon creating a geotification; it’s responsible for creating a new Geotification object using the values passed from AddGeotificationsViewController, and updating both the map view and the geotifications list accordingly. Then you call saveAllGeotifications(), which takes the newly-updated geotifications list and persists it via NSUserDefaults.
  func addGeotificationViewController(controller: AddGeotificationViewController, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: EventType) {
    controller.dismiss(animated: true, completion: nil)
    
    //You ensure that the value of the radius is clamped to the maximumRegionMonitoringDistance property of locationManager, which is defined as the largest radius in meters that can be assigned to a geofence. This is important, as any value that exceeds this maximum will cause monitoring to fail.
    let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
    
    let geotification = Geotification(coordinate: coordinate, radius: clampedRadius, identifier: identifier, note: note, eventType: eventType)
    
    //You add a call to startMonitoringGeotification(_:) to ensure that the geofence associated with the newly-added geotification is registered with Core Location for monitoring.
    startMonitoring(geotification: geotification)
    add(geotification: geotification)
    saveAllGeotifications()
  }
  
}

// MARK: - Location Manager Delegate
extension GeotificationsViewController: CLLocationManagerDelegate {
  //This func will be called whenever the authorization status changes. If the user has already granted the app permission to use Location Services, this method will be called by the location manager after you’ve initialized the location manager and set its delegate.
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    mapView.showsUserLocation = (status == .authorizedAlways)
  }
  
  //delegate methods to facilitate error handling
  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    print("Monitoring failed for region with identifier: \(region!.identifier)")
  }
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Location Manager failed with the following error: \(error)")
  }
}

// MARK: - MapView Delegate
extension GeotificationsViewController: MKMapViewDelegate {
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let identifier = "myGeotification"
    if annotation is Geotification {
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
      if annotationView == nil {
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView?.canShowCallout = true
        let removeButton = UIButton(type: .custom)
        removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
        removeButton.setImage(UIImage(named: "DeleteGeotification")!, for: .normal)
        annotationView?.leftCalloutAccessoryView = removeButton
      } else {
        annotationView?.annotation = annotation
      }
      return annotationView
    }
    return nil
  }
  
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    if overlay is MKCircle {
      let circleRenderer = MKCircleRenderer(overlay: overlay)
      circleRenderer.lineWidth = 1.0
      circleRenderer.strokeColor = .purple
      circleRenderer.fillColor = UIColor.purple.withAlphaComponent(0.4)
      return circleRenderer
    }
    return MKOverlayRenderer(overlay: overlay)
  }
  
  //function is invoked whenever the user taps the “delete” accessory control on each annotation.
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    // Delete geotification
    let geotification = view.annotation as! Geotification
    
    //This statement stops monitoring the geofence associated with the geotification, before removing it and saving the changes to NSUserDefaults.
    stopMonitoring(geotification: geotification)
    remove(geotification: geotification)
    saveAllGeotifications()
  }
  
}
