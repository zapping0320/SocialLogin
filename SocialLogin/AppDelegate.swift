//
//  AppDelegate.swift
//  SocialLogin
//
//  Created by DD Dev on 2020/12/01.
//  Copyright © 2020 zenoTeam. All rights reserved.
//

import UIKit
import KakaoSDKCommon
import AuthenticationServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        KakaoSDKCommon.initSDK(appKey: "a46b38da53956c7ac2d975e17d74d893")
        
        
        let appleID = UserInfoHelper.getAppleLoginID()
        
        if appleID != "" {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: appleID /* 로그인에 사용한 User Identifier */) { (credentialState, error) in
                switch credentialState {
                case .authorized:
                    // The Apple ID credential is valid.
                    print("해당 ID는 연동되어있습니다.")
                case .revoked:
                    // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                    print("해당 ID는 연동되어있지않습니다.")
                    UserInfoHelper.resetLogin()
                case .notFound:
                    // The Apple ID credential is either was not found, so show the sign-in UI.
                    print("해당 ID를 찾을 수 없습니다.")
                    UserInfoHelper.resetLogin()
                default:
                    break
                }
            }
        }
        
        
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (Notification) in
            print("Revoked Notification")
            // 로그인 페이지로 이동
            UserInfoHelper.resetLogin()
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


}

