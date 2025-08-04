import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Configure Flutter plugins
    GeneratedPluginRegistrant.register(with: self)
    
    // Request notification permissions and set up notification center
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { granted, error in
          if granted {
            DispatchQueue.main.async {
              UIApplication.shared.registerForRemoteNotifications()
            }
          }
        }
      )
    } else {
      // Fallback for iOS versions prior to 10.0
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle notification when app is in foreground
  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // Show notification even when app is in foreground
    completionHandler([.alert, .badge, .sound])
  }
  
  // Handle notification tap
  @available(iOS 10.0, *)
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    // Handle the notification response
    let userInfo = response.notification.request.content.userInfo
    
    // Process the notification payload
    if let payload = userInfo["payload"] as? String {
      // Handle different notification types
      switch payload {
      case "daily_checkin":
        // Navigate to daily check-in screen
        break
      case "milestone":
        // Navigate to progress screen
        break
      case "craving_support":
        // Navigate to support screen
        break
      default:
        break
      }
    }
    
    completionHandler()
  }
  
  // Handle registration for remote notifications
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    // Handle device token registration if needed for push notifications
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
  
  // Handle failure to register for remote notifications
  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("Failed to register for remote notifications: \(error)")
  }
}
