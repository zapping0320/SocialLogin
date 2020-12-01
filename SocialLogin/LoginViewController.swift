//
//  ViewController.swift
//  SocialLogin
//
//  Created by DD Dev on 2020/12/01.
//  Copyright © 2020 zenoTeam. All rights reserved.
//

import UIKit
import KakaoSDKAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInKaKao(_ sender: Any) {
        // 카카오톡 설치 여부 확인
        if (AuthApi.isKakaoTalkLoginAvailable()) {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            AuthApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    // 예외 처리 (로그인 취소 등)
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    // do something
                    _ = oauthToken
                    // 어세스토큰
                    let accessToken = oauthToken?.accessToken
                    self.goMainVC("kakao")
                }
            }
        }
        
    }
    
    func goMainVC(_ loginType:String) {
        let mainVC = self.storyboard?.instantiateViewController(identifier: "mainVC") as! MainViewController
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.loginType = loginType
        //self.navigationController?.pushViewController(mainVC, animated: false)
        self.present(mainVC, animated: true, completion: nil)
    }
    
}

