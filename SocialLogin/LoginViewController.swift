//
//  ViewController.swift
//  SocialLogin
//
//  Created by DD Dev on 2020/12/01.
//  Copyright © 2020 zenoTeam. All rights reserved.
//

import UIKit
import KakaoSDKAuth
import AuthenticationServices
import GoogleSignIn
import FBSDKLoginKit
import NaverThirdPartyLogin
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var appleLoginProviderStackView: UIStackView!
    
    @IBOutlet weak var googleLogInButton: GIDSignInButton!
    
    @IBOutlet weak var naverLoginButton: UIButton!
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        setupAppleProviderLoginView()
        
        setGoogleSignInButton()
        
        naverLoginInstance?.delegate = self
    }
    
    func setupAppleProviderLoginView() {
        let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
        //let authorizationButton = ASAuthorizationAppleIDButton(authorizationButtonType: .continue , authorizationButtonStyle:.whiteOutline)
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.appleLoginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    func setGoogleSignInButton() {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        googleLogInButton.style = .wide // .wide .iconOnly .standard
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserInfoHelper.isLogIn() {
            let loginType = UserInfoHelper.getLogInType()
            if loginType == .Google {
                //GIDSignIn.sharedInstance()?.signIn() - request login
                GIDSignIn.sharedInstance()?.restorePreviousSignIn() //auto login
            }
            else if loginType == .Facebook {
                if let token = AccessToken.current, !token.isExpired {
                    self.goMainVC(loginType)
                }
                else {
                    UserInfoHelper.resetLogin()
                }
            }
            else {
                self.goMainVC(loginType)
            }
        }
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
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
                    print("[kakao] loginWithKakaoTalk() success.")
                    // do something
                    _ = oauthToken
                    // 어세스토큰
                    let _ = oauthToken?.accessToken
                    self.goMainVC(.KaKao)
                }
            }
        }
        
    }
    
    
    @IBAction func loginFacebook(_ sender: Any) {
        LoginManager.init().logIn(permissions: [.publicProfile, .email], viewController: self) { (loginResult) in

            switch loginResult {

            case .failed(let error):

                print(error)

            case .cancelled:

                print("[facebook] 유저 캔슬")

            case .success(let grantedPermissions, let declinedPermissions, let accessToken):

                print("[facebook] 로그인 성공")

                print(grantedPermissions)

                print(declinedPermissions)

                print(accessToken)
                
                print("[facebook] facebook appID = " + accessToken.appID)
                
                self.goMainVC(.Facebook)
            }

        }
    }
    
    @IBAction func signInNaver(_ sender: Any) {
        self.naverLoginInstance?.requestThirdPartyLogin()
    }
    
    func goMainVC(_ loginType:LogInType) {
        let mainVC = self.storyboard?.instantiateViewController(identifier: "mainVC") as! MainViewController
        mainVC.modalPresentationStyle = .fullScreen
        mainVC.setLogInType(loginType)
        
        self.present(mainVC, animated: true, completion: nil)
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    /// - Tag: did_complete_authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // Create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            UserInfoHelper.setAppleLoginID(userIdentifier)
            // For the purpose of this demo app, store the `userIdentifier` in the keychain.
            //self.saveUserInKeychain(userIdentifier)
            
            // For the purpose of this demo app, show the Apple ID credential information in the `ResultViewController`.
            self.goMainVC(.Apple)
        
        case let passwordCredential as ASPasswordCredential:
        
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                self.showPasswordCredentialAlert(username: username, password: password)
            }
            
        default:
            break
        }
    }
    
    private func showPasswordCredentialAlert(username: String, password: String) {
        let message = "[apple] The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
        let alertController = UIAlertController(title: "Keychain Credential Received",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    /// - Tag: did_complete_error
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}


extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    /// - Tag: provide_presentation_anchor
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension LoginViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
                if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                    print("[google] The user has not signed in before or they have since signed out.")
                } else {
                    print("[google] \(error.localizedDescription)")
                }
                return
            }
                
            // 사용자 정보 가져오기
            if let userId = user.userID,                  // For client-side use only!
                let idToken = user.authentication.idToken, // Safe to send to the server
                let fullName = user.profile.name,
                let givenName = user.profile.givenName,
                let familyName = user.profile.familyName,
                let email = user.profile.email {
                    
                print("[google] Token : \(idToken)")
                print("[google] User ID : \(userId)")
                print("[google] User Email : \(email)")
                print("[google] User Name : \((fullName))")
                self.goMainVC(.Google)
         
            } else {
                print("[google] Error : User Data Not Found")
            }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        print("[google] Disconnect")
        UserInfoHelper.resetLogin()
    }
    
}

extension LoginViewController: NaverThirdPartyLoginConnectionDelegate {
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("[naver] Success login")
        self.goMainVC(.Naver)
        getInfo()
    }
    
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
       self.naverLoginInstance?.accessToken
    }
    
    func oauth20ConnectionDidFinishDeleteToken() {
        print("[naver] log out")
        UserInfoHelper.resetLogin()
    }
    
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[naver] error = \(error.localizedDescription)")
    }
    
    // RESTful API, id가져오기
    func getInfo() {
        guard let isValidAccessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            return
        }
        
        guard let tokenType = naverLoginInstance?.tokenType else { return }
        guard let accessToken = naverLoginInstance?.accessToken else { return }
        
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        let req = AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization": authorization])
        
        req.responseJSON { response in
            guard let result = response.value as? [String: Any] else { return }
            guard let object = result["response"] as? [String: Any] else { return }
            if let name = object["name"] as? String {
                print("[naver] = \(name)")
            }
            if let email = object["email"] as? String {
                print("[naver] = \(email)")
            }
//            if let id = object["id"] as? String {
//                print(id)
//            }
            
        }
    }
    
    
}
