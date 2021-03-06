//
//  UserInfoHelper.swift
//  SocialLogin
//
//  Created by DD Dev on 2020/12/02.
//  Copyright © 2020 zenoTeam. All rights reserved.
//

import Foundation

class UserInfoHelper {
    static func getAppleLoginID() -> String {
        
        let defaults = UserDefaults.standard
        guard let logInType = defaults.string(forKey: "logInType") else {
            return ""
        }
        
        if logInType == LogInType.Apple.rawValue {
            guard let appleID = defaults.string(forKey: "appleID") else {
                return ""
            }
            
            return appleID
        }
        else
        {
            return ""
        }
    }
    
    static func setAppleLoginID(_ appleID:String) {
        let defaults = UserDefaults.standard
        defaults.set(LogInType.Apple.rawValue, forKey: "logInType")
        defaults.set(appleID, forKey: "appleID")
    }
    
    static func resetLogin() {
        let defaults = UserDefaults.standard
        defaults.set(LogInType.None.rawValue, forKey: "logInType")
        defaults.set("", forKey: "appleID")
    }
    
    static func isLogIn() -> Bool {
        let defaults = UserDefaults.standard
        guard let loginType = defaults.string(forKey: "logInType") else {
            return false
        }
        
        return loginType.isEmpty == false
    }
    
    static func setLogInType(_ loginType: LogInType) {
        let defaults = UserDefaults.standard
        defaults.set(loginType.rawValue, forKey: "logInType")
        
    }
    
    static func getLogInType() -> LogInType {
        let defaults = UserDefaults.standard
        guard let logInType = defaults.string(forKey: "logInType") else {
            return .None
        }
        
        if logInType == LogInType.KaKao.rawValue {
            return .KaKao
        }
        else if logInType == LogInType.Apple.rawValue {
            return .Apple
        }
        else if logInType == LogInType.Google.rawValue {
            return .Google
        }
        else if logInType == LogInType.Facebook.rawValue {
            return .Facebook
        }
        else if logInType == LogInType.Naver.rawValue {
            return .Naver
        }
        else {
            return .None
        }
    }
}
