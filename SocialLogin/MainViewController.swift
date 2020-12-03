//
//  MainViewController.swift
//  SocialLogin
//
//  Created by DD Dev on 2020/12/01.
//  Copyright © 2020 zenoTeam. All rights reserved.
//

import UIKit
import KakaoSDKUser
import GoogleSignIn
import FBSDKLoginKit
import NaverThirdPartyLogin

class MainViewController: UIViewController {
    
    private var loginType:LogInType = .KaKao

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public func setLogInType(_ loginType:LogInType) {
        self.loginType = loginType
        UserInfoHelper.setLogInType(loginType)
    }
    

    @IBAction func signOut(_ sender: Any) {
        
        
        if loginType == .KaKao {
            UserApi.shared.logout {(error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("logout() success.")
                    UserInfoHelper.resetLogin()
                    self.dismissVC()
                }
            }
        }
        else if loginType == .Google {
            GIDSignIn.sharedInstance()?.signOut()
        }
        else if loginType == .Facebook {
            LoginManager.init().logOut()
        }
        else if loginType == .Naver {
            let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
            loginInstance?.requestDeleteToken()
        }
        
        UserInfoHelper.resetLogin()
        self.dismissVC()
        
        
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
   

}
