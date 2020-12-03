//
//  AppDelegate.swift
//  SocialLogin
//
//  Created by DD Dev on 2020/12/01.
//  Copyright © 2020 zenoTeam. All rights reserved.
//

import UIKit
import KakaoSDKCommon           //kakao
import AuthenticationServices   //apple
import GoogleSignIn             //google
import FBSDKCoreKit             //facebook
import NaverThirdPartyLogin     //naver

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    // Swift // // AppDelegate.swift import UIKit import FBSDKCoreKit @UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate { func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool { ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions ) return true } func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool { ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] ) } }
    
  



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //kakao
        KakaoSDKCommon.initSDK(appKey: "a46b38da53956c7ac2d975e17d74d893")
        
        //apple
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
        
        //google
        GIDSignIn.sharedInstance().clientID = "957665535722-0ta1pnmfavte7smojhjmjkt6afoitusb.apps.googleusercontent.com"

        //facebook
        ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
        
        //naver
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
               
               // 네이버 앱으로 인증하는 방식 활성화
               instance?.isNaverAppOauthEnable = true
               
               // SafariViewController에서 인증하는 방식 활성화
               instance?.isInAppOauthEnable = true
               
               // 인증 화면을 아이폰의 세로모드에서만 적용
               instance?.isOnlyPortraitSupportedInIphone()
               
               instance?.serviceUrlScheme = kServiceAppUrlScheme // 앱을 등록할 때 입력한 URL Scheme
               instance?.consumerKey = kConsumerKey // 상수 - client id
               instance?.consumerSecret = kConsumerSecret // pw
               instance?.appName = kServiceAppName // app name
        
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

