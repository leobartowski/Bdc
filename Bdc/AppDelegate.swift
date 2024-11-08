//
//  AppDelegate.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 21/10/21.
//

import CoreData
import UIKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // self.loadFileFromBackUpIfNeeded()
        self.fixTableViewBugGloabally()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: My Methods
    func fixTableViewBugGloabally() {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = CGFloat(0)
        }
    }
    
// MARK: Way to upload data the first installation
//    https://gist.github.com/xavierchia/ef43abb270003ae63e5bbb7eb5404645
    func loadFileFromBackUpIfNeeded() {
        let isPreloaded = UserDefaults.standard.bool(forKey: "isPreloaded")
        if !isPreloaded {
            preloadDataFromSQFiles()
            UserDefaults.standard.set(true, forKey: "isPreloaded")
        }
    }
    
    func preloadDataFromSQFiles() {
        let sourceSqliteURLs = [
            Bundle.main.url(forResource: "Bdc", withExtension: "sqlite"),
            Bundle.main.url(forResource: "Bdc", withExtension: "sqlite-wal"),
            Bundle.main.url(forResource: "Bdc", withExtension: "sqlite-shm")
        ]
        let destSqliteURLs = [
            URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Bdc.sqlite"),
            URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Bdc.sqlite-wal"),
            URL(fileURLWithPath: NSPersistentContainer.defaultDirectoryURL().relativePath + "/Bdc.sqlite-shm")]
        
        for index in 0...sourceSqliteURLs.count - 1 {
            do {
                try FileManager.default.copyItem(at: sourceSqliteURLs[index]!, to: destSqliteURLs[index])
            } catch {
                print("Could not preload data")
            }
        }
    }
}
