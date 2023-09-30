//
//  LoginViewController.swift
//  Milestone
//
//  Created by Jun on 2023/08/10.
//

import UIKit

import AuthenticationServices
import KakaoSDKUser
import Lottie
import RxKakaoSDKUser
import SnapKit
import RxSwift

protocol LoginFlow {
    func coordinateToOnboarding()
    func coordinateToMain()
}

class LoginCoordinator: Coordinator, LoginFlow {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        loginViewController.viewModel = OnboardingViewModel()
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func coordinateToOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        coordinate(to: onboardingCoordinator)
    }
    
    func coordinateToMain() {
        navigationController.pushViewController(MainViewController(), animated: true)
    }
}

class LoginViewController: BaseViewController {
    let label: UILabel = {
        let label = UILabel()
        label.text = "나를 갈고 닦아\n빛나는 보석이 되기 위한 여정,"
        label.font = UIFont.pretendard(.semibold, ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = ImageLiteral.imgMileStone
        return iv
    }()
    
    let labelWithLogo: UILabel = {
        let label = UILabel()
        label.text = "과 함께해요!"
        label.font = UIFont.pretendard(.semibold, ofSize: 24)
        return label
    }()
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = ImageLiteral.imgOnboarding1
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let appleLoginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Apple로 로그인", for: .normal)
        btn.backgroundColor = UIColor(hex: "#050708")
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 19)
        btn.titleLabel?.textAlignment = .right
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    let appleLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = ImageLiteral.imgAppleLogo
        return iv
    }()
    
    let kakaoLoginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("카카오로 로그인", for: .normal)
        btn.backgroundColor = UIColor(hex: "#FEE500")
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 19)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    let kakaoLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = ImageLiteral.imgKakaoLogo
        return iv
    }()
    
    let loadingView: LottieAnimationView = .init(name: "loading")
        .then {
            $0.play()
        }
    lazy var loadingWrapperViewController = UIViewController()
        .then { wrapperVC in
            wrapperVC.modalTransitionStyle = .crossDissolve
            wrapperVC.modalPresentationStyle = .overFullScreen
            wrapperVC.view.addSubview(self.loadingView)
            loadingView.snp.makeConstraints { make in
                make.width.height.equalTo(200)
                make.centerY.equalTo(wrapperVC.view)
                make.centerX.equalTo(wrapperVC.view)
            }
            wrapperVC.view.backgroundColor = .black.withAlphaComponent(0.3)
        }
    
    lazy var loadingErrorToastView = ToastView()
        .then {
            $0.alpha = 0
            $0.text = "로그인에 실패했어요"
        }
    
    // MARK: - Properties
    var coordinator: LoginFlow?
    var viewModel: OnboardingViewModel?
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OnboardingViewModel()
        viewModel?.loginCoordinator = self.coordinator
        
        viewModel?.isLoading.subscribe(onNext: { [unowned self] in
            if $0 {
                self.present(self.loadingWrapperViewController, animated: false)
            } else {
                self.dismiss(animated: false)
            }
        })
        .disposed(by: disposeBag)
        
        viewModel?.isError.subscribe(onNext: { [unowned self] in
            if $0 {
                UIView.animate(withDuration: 0.2, delay: 0.5) {
                    self.loadingErrorToastView.alpha = 1
                    self.loadingErrorToastView.frame = CGRect(origin: CGPoint(x: self.loadingErrorToastView.frame.origin.x, y: self.loadingErrorToastView.frame.origin.y + 50), size: self.loadingErrorToastView.frame.size)
                } completion: { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        UIView.animate(withDuration: 0.2) {
                            self.loadingErrorToastView.alpha = 0
                            self.loadingErrorToastView.frame = CGRect(origin: CGPoint(x: self.loadingErrorToastView.frame.origin.x, y: self.loadingErrorToastView.frame.origin.y - 50), size: self.loadingErrorToastView.frame.size)
                        }
                    }
                }

//                self.loadingErrorToastView.isHidden = false
            } else {
//                self.loadingErrorToastView.isHidden = true
            }
        })
        .disposed(by: disposeBag)
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([label, logoImageView, labelWithLogo, loadingErrorToastView, backgroundImageView, appleLoginButton, appleLogo, kakaoLoginButton, kakaoLogo])
        
        loadingErrorToastView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(-50)
            make.height.equalTo(52)
            make.leading.equalTo(view.snp.leading).offset(24)
            make.trailing.equalTo(view.snp.trailing).offset(-24)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(24)
            make.top.equalTo(label.snp.bottom).offset(24)
        }
        
        labelWithLogo.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(10)
            make.centerY.equalTo(logoImageView.snp.centerY)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.snp.top)
        }
        
        appleLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(kakaoLoginButton.snp.top).offset(-16)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(44)
            make.width.equalTo(280)
        }
        
        appleLogo.snp.makeConstraints { make in
            make.centerY.equalTo(appleLoginButton.snp.centerY)
            make.leading.equalTo(appleLoginButton.snp.leading).offset(10)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(44)
            make.width.equalTo(280)
        }
        
        kakaoLogo.snp.makeConstraints { make in
            make.centerY.equalTo(kakaoLoginButton.snp.centerY)
            make.centerX.equalTo(appleLogo.snp.centerX)
        }
    }
    
    override func bindUI() {
        kakaoLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.rx.loginWithKakaoTalk()
                        .subscribe(onNext: { [weak self] _ in
                            self?.viewModel?.loginWith(provider: .kakao)
                        }, onError: {error in
                            print(error)
                        })
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.performExistingAccountSetupFlows()
            })
            .disposed(by: disposeBag)
    }
    
    func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let request = ASAuthorizationAppleIDProvider().createRequest()
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func handleAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            viewModel?.appleUserId = appleIDCredential.user
            viewModel?.loginWith(provider: .apple)
            
        case let passwordCredential as ASPasswordCredential:
            print(passwordCredential)
            // Sign in using an existing iCloud Keychain credential.
            print("password credential .. ")
        default:
            break
        }
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
