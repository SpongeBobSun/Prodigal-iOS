//
//  AppDelegate.swift
//  Prodigal
//
//   Copyright 2017 Bob Sun
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.
//
//  Created by bob.sun on 28/03/2017.
//
//          _
//         ( )
//          H
//          H
//         _H_
//      .-'-.-'-.
//     /         \
//    |           |
//    |   .-------'._
//    |  / /  '.' '. \
//    |  \ \ @   @ / /
//    |   '---------'
//    |    _______|
//    |  .'-+-+-+|              I'm going to build my own APP with blackjack and hookers!
//    |  '.-+-+-+|
//    |    """""" |
//    '-.__   __.-'
//         """
//


import UIKit
import Firebase
import MediaPlayer

import Haneke
import Holophonor

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var main: ViewController!
    var taskId: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        ThemeManager().copyToDocuments()
        initCacheForList()
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: Bundle.init(for: AppDelegate.self))
        self.main = mainStoryBoard.instantiateInitialViewController() as? ViewController
        if self.window == nil {
            self.window = UIWindow(frame: UIScreen.main.bounds)
        }
        self.window?.rootViewController = self.main
        self.window?.makeKeyAndVisible()
        if MediaLibrary.sharedInstance.authorized {
            self.restoreLastState()
        }
        if AppSettings.sharedInstance.newInstall() {
            let introVC = UIStoryboard(name: "Intro", bundle: Bundle(for: AppDelegate.self)).instantiateInitialViewController()
            self.main.present(introVC!, animated: true, completion: nil)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        taskId = UIApplication.shared.beginBackgroundTask {
            return
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        UIApplication.shared.endBackgroundTask(convertToUIBackgroundTaskIdentifier(taskId.rawValue))
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveState()
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        saveState()
    }
    
    func saveState() {
        let ud = UserDefaults.standard
        ud.set(main.player?.currentTime, forKey: "last_current_time")
        ud.set(main.playingIndex, forKey: "last_playing_index")
        
        var list: Array<String> = []
        for each in main.playlist {
            list.append(each.persistentID ?? "")
        }
        
        ud.set(list, forKey: "last_playing_list")
        ud.synchronize()
    }
    
    private func restoreLastState() {
        let ud = UserDefaults.standard
        let lastCurrent = ud.double(forKey: "last_current_time")
        let lastIndex = ud.integer(forKey: "last_playing_index")
        guard let lastList = ud.array(forKey: "last_playing_list") else {
            return
        }
        let validateList = MediaLibrary.sharedInstance.validateList(list: lastList as! Array<String>)
        main.playlist = validateList
        main.playingIndex = lastIndex >= validateList.count ? 0 : lastIndex
        main.resumeTime = lastCurrent
    }

    private func initCacheForList() {
        var format: HNKCacheFormat? = HNKCache.shared().formats["list_cover"] as! HNKCacheFormat?
        if format == nil {
            format = HNKCacheFormat.init(name: "list_cover")
            format?.size = CGSize(width: 40, height: 40)
            format?.scaleMode = .aspectFill
            format?.compressionQuality = 0.75
            format?.diskCapacity = UInt64(5 * 1024 * 1024)
            format?.preloadPolicy = .lastSession
        }
        HNKCache.shared().registerFormat(format)
        
        format = HNKCache.shared().formats["stack"] as! HNKCacheFormat?
        if format == nil {
            format = HNKCacheFormat.init(name: "stack")
            format?.size = CGSize(width: 200, height: 200)
            format?.scaleMode = .aspectFill
            format?.compressionQuality = 0.75
            format?.diskCapacity = UInt64(5 * 1024 * 1024)
            format?.preloadPolicy = .lastSession
        }
        HNKCache.shared().registerFormat(format)
        
    }

}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIBackgroundTaskIdentifier(_ input: Int) -> UIBackgroundTaskIdentifier {
	return UIBackgroundTaskIdentifier(rawValue: input)
}
