//
//  AppDelegate.swift
//  Life in Seconds
//
//  Created by Riccardo Carlotto on 22/12/21.
//

import UIKit
import Photos
import AdSupport
//import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
//        if #available(iOS 14, *) {
//            ATTrackingManager.requestTrackingAuthorization { status in
//                DispatchQueue.main.async {
//                    switch status {
//                    case .authorized:
//                        // Authorized
//                        let idfa = ASIdentifierManager.shared().advertisingIdentifier
//                        print (idfa.uuidString, "idfa")
//                        print ("tracking: authorized")
//                    case .denied:
//                        print ("tracking: denied")
//                    case  .notDetermined:
//                        print ("tracking: not determined")
//                    case  .restricted:
//                        print ("tracking: restricret")
//
//
//                    @unknown default:
//                        break
//                    }
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        
        
        if #available(iOS 14, *) {
           
            // Request read-write access to the user's photo library.
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .notDetermined:
                   print ("Library permission: notDetermined")
                    
                case .restricted:
                    // The system restricted this app's access.
                    print ("Library permission: restricted")
                case .denied:
                    // The user explicitly denied this app's access.
                    print ("Library permission: denied")
                case .authorized:
                    
                    
                    print ("Library permission: authorized")
                    
                case .limited:
                    // The user authorized this app for limited Photos access.
                    print ("Library permission: Limited")
                @unknown default:
                    fatalError()
                }
            }
            
            
            
            
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
            return self.orientationLock
    }


}

