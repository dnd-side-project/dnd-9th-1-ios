//
//  LoginViewController.swift
//  Milestone
//
//  Created by Jun on 2023/08/10.
//

import UIKit

import KakaoSDKUser
import RxKakaoSDKUser
import SnapKit
import RxSwift

protocol LoginFlow {
    func coordinateToOnboarding()
}

class LoginCoordinator: Coordinator, LoginFlow {
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    func coordinateToOnboarding() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        coordinate(to: onboardingCoordinator)
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
        btn.setTitle("Continue with Apple", for: .normal)
        btn.backgroundColor = UIColor(hex: "#050708")
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: "SFProDisplay-Medium", size: 19)
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
        btn.setTitle("Login With Kakao", for: .normal)
        btn.backgroundColor = UIColor(hex: "#FEE500")
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 19)
        btn.layer.cornerRadius = 8
//        btn.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    let kakaoLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = ImageLiteral.imgKakaoLogo
        return iv
    }()
    
    // MARK: - Properties
    var coordinator: LoginFlow?
    var viewModel: OnboardingViewModel!
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OnboardingViewModel()
        viewModel.loginCoordinator = self.coordinator
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([label, logoImageView, labelWithLogo, backgroundImageView, appleLoginButton, appleLogo, kakaoLoginButton, kakaoLogo])
        
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
                            self?.viewModel.login()
                        }, onError: {error in
                            print(error)
                        })
                        .disposed(by: self.disposeBag)
                }
            })
            .disposed(by: disposeBag)
    }
}
