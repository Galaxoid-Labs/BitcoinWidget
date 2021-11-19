//
//  BitcoinWidgetApp.swift
//  Shared
//
//  Created by Jacob Davis on 8/16/21.
//

import SwiftUI
#if os(iOS)
import UIKit
#endif
import WidgetKit

@main
struct BitcoinWidgetApp: App {
    
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
                setupCatalyst()
                appState.loadAll()
                Task {
                    await CKManager.shared.fetchData()
                    appState.saveAll()
                }
                WidgetCenter.shared.reloadAllTimelines()
                print("Active")
            } else if newPhase == .background {
                appState.saveAll()
                print("Background")
            }
        }
    }
    
    func setupCatalyst() {
        #if targetEnvironment(macCatalyst)
        // prevent window in macOS from being resized down
          UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
              windowScene.sizeRestrictions?.minimumSize = CGSize(width: 480, height: 800)
              windowScene.sizeRestrictions?.maximumSize = CGSize(width: 480, height: 800)
              //windowScene.keyWindow?.standardWindowButton(.zoomButton)?.isEnabled = false
              if let titlebar = windowScene.titlebar {
                  titlebar.titleVisibility = .hidden
                  titlebar.toolbar = nil
              }
          }
        #endif
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
