import UIKit
import flutter_local_notifications
import Flutter
import GoogleMaps
import apple_maps_flutter


import MotionTagSDK
import motiontag_sdk

@main
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
//        let controller = window?.rootViewController as! FlutterViewController
//                let batteryChannel = FlutterMethodChannel(name: "com.app.bdmobility", binaryMessenger: controller.binaryMessenger)
//
//                batteryChannel.setMethodCallHandler { (call, result) in
//                    if call.method == "isPowerSaveModeEnabled" {
//                        if #available(iOS 9.0, *) {
//                            result(ProcessInfo.processInfo.isLowPowerModeEnabled)
//                        } else {
//                            result(false) // iOS versions below 9.0 do not support Low Power Mode
//                        }
//                    } else {
//                        result(FlutterMethodNotImplemented)
//                    }
//                }

        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
                GeneratedPluginRegistrant.register(with: registry)
            }

            if #available(iOS 10.0, *) {
              UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
            }

        GMSServices.provideAPIKey("AIzaSyBGIT7tPftOEf4knWZ_1HskdC3GABNec-U")
        MotionTagCore.sharedInstance.initialize(using: MotionTagDelegateWrapper.sharedInstance, launchOption: launchOptions)


        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // Override the handleEventsForBackgroundURLSession delegate
    override func application(
            _ application: UIApplication,
            handleEventsForBackgroundURLSession identifier: String,
            completionHandler: @escaping () -> Void) {

         // Add this line here to forward the events to the SDK
         MotionTagCore.sharedInstance.handleEvents(forBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
}
