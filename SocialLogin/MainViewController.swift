//
//  MainViewController.swift
//  SocialLogin
//
//  Created by DD Dev on 2020/12/01.
//  Copyright © 2020 zenoTeam. All rights reserved.
//

import UIKit
import KakaoSDKUser

class MainViewController: UIViewController {
    
    public var loginType:LogInType = .KaKao

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func signOut(_ sender: Any) {
        
        
        if loginType == .KaKao {
        
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                self.dismissVC()
            }
        }
            
        }
        
    }
    
    func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
   

}
