import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate


      requestAuthorization { b in
          
      }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
    func requestAuthorization(completion: @escaping  (Bool) -> Void) {
      UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _  in
          // TODO: Fetch notification settings
          completion(granted)
        }
    }
    
}
