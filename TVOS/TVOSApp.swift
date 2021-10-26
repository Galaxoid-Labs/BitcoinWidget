//
//  TVOSApp.swift
//  TVOS
//
//  Created by Jacob Davis on 10/26/21.
//

import SwiftUI
#if os(tvOS)
import UIKit
#endif

@main
struct TVOSApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    
    let appState = AppState.shared
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                print("Inactive")
            } else if newPhase == .active {
                appState.loadAll()
                Task {
                    await CKManager.shared.fetchData()
                    appState.saveAll()
                }
                print("Active")
            } else if newPhase == .background {
                appState.saveAll()
                print("Background")
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UIApplication.shared.registerForRemoteNotifications()
        
        Task {
            await CKManager.shared.initBitcoinDataSubs()
        }
        
        print("Application Delegate: didFinishLaunchingWithOptions")
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Application Delegate: didRegisterForRemoteNotificationsWithDeviceToken")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Application Delegate: didFailToRegisterForRemoteNotificationsWithError \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        return await CKManager.shared.application(application, didReceiveRemoteNotification: userInfo)
    }

}
