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
        
        if logInType == "apple" {
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
        defaults.set("apple", forKey: "logInType")
        defaults.set(appleID, forKey: "appleID")
    }
    
    static func setKakaoLogin() {
        let defaults = UserDefaults.standard
        defaults.set("kakao", forKey: "logInType")
    }
    
    static func resetLogin() {
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "logInType")
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
        var loginString = ""
        if loginType == .KaKao {
            loginString = "kakao"
        }
        else if loginType == .Apple {
            loginString = "apple"
        }
        
        let defaults = UserDefaults.standard
        defaults.set(loginString, forKey: "logInType")
        
    }
    
    static func getLogInType() -> LogInType {
        let defaults = UserDefaults.standard
        guard let logInType = defaults.string(forKey: "logInType") else {
            return .None
        }
        
        if logInType == "kakao" {
            return .KaKao
        }
        else if logInType == "apple" {
            return .Apple
        }
        else {
            return .None
        }
    }
}
