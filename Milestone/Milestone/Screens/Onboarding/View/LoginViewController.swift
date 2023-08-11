//
//  LoginViewController.swift
//  Milestone
//
//  Created by Jun on 2023/08/10.
//

import UIKit
import SnapKit

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
        iv.image = UIImage(named: "Milestone")
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
        iv.image = UIImage(named: "onboarding_1")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let appleLoginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Continue with Apple", for: .normal)
        btn.backgroundColor = UIColor(hex: "#050708")
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        btn.titleLabel?.textAlignment = .right
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    let appleLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "appleLogo_black")
        return iv
    }()
    
    let kakaoLoginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login With Kakao", for: .normal)
        btn.backgroundColor = UIColor(hex: "#FEE500")
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .medium)
        btn.layer.cornerRadius = 8
        return btn
    }()
    
    let kakaoLogo: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "kakaoLogo")
        return iv
    }()
    
    override func render() {
        label.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.leading.equalTo(view.snp.leading).offset(24)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading).offset(24)
            make.top.equalTo(label.snp.bottom).offset(36)
        }
        
        labelWithLogo.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(10)
            make.firstBaseline.equalTo(logoImageView.snp.bottom)
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
    
    override func configUI() {
        view.addSubViews([label, logoImageView, labelWithLogo, backgroundImageView, appleLoginButton, appleLogo, kakaoLoginButton, kakaoLogo])
    }
}
