//
//  AppDelegate.swift
//  LingoClash
//
//  Created by Kyle キラ on 6/3/22.
//

import UIKit
import CoreData
import Firebase
import PromiseKit

enum Environment: String {
    case development = "Development"
    case production = "Production"
    case none = "None"
}

var environment: Environment = .none

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            
            FirebaseApp.configure()
            registerUserDefaults()
            setUpEnvironment()
            setUpView()
            setUpTheme()
            MainRewardSystem.setUp()
            
            return true
        }
    
    private func setUpEnvironment() {
#if DEVELOPMENT
        environment = .development
#else
        environment = .production
#endif
        
        switch environment {
        case .development:
            Logger.info("Environment is: development")
            setUpSampleData()
        case .production:
            Logger.info("Environment is: production")
            setUpSampleData()
        case .none:
            Logger.info("Environment is: none")
        }
    }
    
    private func setUpView() {
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = Theme.current.primary
    }
    
    private func setUpTheme() {
        guard UserDefaults.standard.object(forKey: "LightTheme") != nil else {
            return
        }
        
        let isLightSelected = UserDefaults.standard.bool(forKey: "LightTheme")
        UIApplication
            .shared
            .keyWindow?
            .overrideUserInterfaceStyle = isLightSelected
        ? .light : .dark
    }
    
    private func setUpSampleData() {
        guard AppConfigs.Debug.enablePreloadData else {
            return
        }
        
        Logger.warning("enablePreloadData is set to true. Will be preloading db with sample data")
        
        // TODO: convert to synchronous
        firstly {
            SampleDataUtilities.createSampleData()
        }.done {
            Logger.warning("You may turn off enablePreloadData now to avoid exceeding document writes quota")
        }.catch { error in
            Logger.error("Failed to create some sample data: \(error)")
        }
    }
    
    private func registerUserDefaults() {
        UserDefaults.standard.register(defaults: [:])
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions) -> UISceneConfiguration {
            // Called when a new scene session is being created.
            // Use this method to select a configuration to create the new scene with.
            return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "LingoClash")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
