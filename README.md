# SocialLogin


#social login에 대한 정리

- 개발환경 : Xcode 12.2
- 사용언어 : swift

- 용어 정리 - login /logout으로 통일함 
           > api 회사마다 sign / login 다르게 쓴다.

#1 kakao
- 개발 문서 페이지 : https://developers.kakao.com/docs/latest/ko/kakaologin/ios
- application 등록 페이지 :https://developers.kakao.com/docs/latest/ko/getting-started/app

#2 apple
- 개발 문서 페이지 :https://developer.apple.com/documentation/authenticationservices/implementing_user_authentication_with_sign_in_with_apple
- 애플 로그인 경우 프로젝트 설정에서 "Signing & Capabilities 에서 Sign in with Apple" 을 추가합니다.

#3 google
- 개발 문서 페이지 :https://developers.google.com/identity/sign-in/ios/
- application 등록 페이지 :https://developers.google.com/identity/sign-in/ios/start#get-an-oauth-client-id

#4 facebook
- 개발 문서 페이지 :https://developers.facebook.com/docs/facebook-login/ios/?locale=ko_KR
- 제공해주는 버튼을 이용해서 로그인할 경우 버튼을 storyboard에 붙여서 실행하는 것도 안 되고 login / logout 처리가 잘 안 되서 custom으로 처리함
- sdk git : https://github.com/facebook/facebook-ios-sdk?fbclid=IwAR0YowDHfaCnCrSINf3O--puxlrV0bXF-fwAFRKDHc8jf4CGiw8dhtzNheo

#5 naver
- 개발 문서 페이지 : https://developers.naver.com/docs/login/ios/
- application 등록 페이지 : https://developers.naver.com/apps/#/wizard/register

*해당 소스에는 applicatoin id 관련 정보는 제외 되어 있으니 사용할 경우 info.list을 추가해서 사용해야 함
