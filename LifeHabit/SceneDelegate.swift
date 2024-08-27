//
//  SceneDelegate.swift
//  LifeHabit
//
//  Created by usia on 8/14/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Main.storyboard 이름에 맞게 수정
        let mainHomeVC = storyboard.instantiateViewController(withIdentifier: "MainHomeVC") as! MainHomeViewController
        let settingVC = storyboard.instantiateViewController(withIdentifier: "SettingVC") as! SettingViewController
        
        // 탭바컨트롤러의 생성
        let tabBarVC = UITabBarController()
        
        // 첫번째 화면은 네비게이션컨트롤러로 만들기 (기본루트뷰 설정)
        let vc1 = UINavigationController(rootViewController: mainHomeVC)
        let vc2 = UINavigationController(rootViewController: settingVC)
        
        // 탭바 이름들 설정
        vc1.title = "Main"
        vc2.title = "User"
        
        // 탭바로 사용하기 위한 뷰 컨트롤러들 설정
        tabBarVC.setViewControllers([vc1, vc2], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = #colorLiteral(red: 0.07035686821, green: 0.07035686821, blue: 0.07035686821, alpha: 1)
        tabBarVC.tabBar.tintColor = #colorLiteral(red: 1, green: 0.4549019608, blue: 0.03921568627, alpha: 1)
        
        // 탭바 이미지 설정 (이미지는 애플이 제공하는 것으로 사용)
        guard let items = tabBarVC.tabBar.items else { return }
        items[0].image = UIImage(systemName: "house.fill")
        items[1].image = UIImage(systemName: "person.fill")
        
        // 기본루트뷰를 탭바컨트롤러로 설정
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        
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
//        (window?.rootViewController as? MainHomeViewController)?.scheduleAllHabitNotifications()
        //  앱이 포그라운드로 돌아올 때 데이터 불러오기 및 테이블뷰 갱신
        if let mainHomeVC = window?.rootViewController as? UITabBarController,
           let mainVC = mainHomeVC.viewControllers?.first as? UINavigationController,
           let homeVC = mainVC.topViewController as? MainHomeViewController {
            homeVC.habitDataManager.loadHabitData() // 데이터 다시 로드
            homeVC.mainTableView?.reloadData()       // 테이블뷰 갱신
        }
        
        (window?.rootViewController as? MainHomeViewController)?.checkIfNewDay()
        
    }

    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state
    }
    
    
}

