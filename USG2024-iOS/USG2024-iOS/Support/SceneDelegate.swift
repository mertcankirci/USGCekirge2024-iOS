//
//  SceneDelegate.swift
//  USG2024-iOS
//
//  Created by Mertcan Kırcı on 8.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let splashVC = SplashVC()
    let homeVC = HomeVC()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = splashVC
        window?.makeKeyAndVisible()
        
        fetchData()
    }
    
    func fetchData() {
        NetworkManager.shared.getCities { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.handleDataFetchSuccess(data: success.data)
                    self.homeVC.cityListVC.cities = success.data
                    self.homeVC.cityListVC.updateData(on: success.data)
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self.handleDataFetchFailure(error: failure)
                }
            }
        }
    }

    func handleDataFetchSuccess(data: [City]) {
        let navigationController = UINavigationController(rootViewController: homeVC)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func handleDataFetchFailure(error: USGError) {
        print("Data fetch error: \(error)")
        splashVC.presentUSGAlertOnMainThread(title: "Error", message: "Unable to fetch data. Please try again later.", buttonTitle: "OK")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

/*
 func fetchData() {
     NetworkManager.shared.getCities { [weak self] result in
         guard let self = self else { return }
         switch result {
         case .success(let success):
             self.homeVC.cityListVC.cities = success.data
             let navigationController = UINavigationController(rootViewController: self.homeVC)
             self.window?.rootViewController = navigationController
             window?.makeKeyAndVisible()
         case .failure(let failure):
             self.splashScreen.presentUSGAlertOnMainThread(title: "Error", message: "Unable to fetch please try again later", buttonTitle: "OK")
             
         }
     }
 }
 */
