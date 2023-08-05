//
//  ViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/04.
//

import UIKit

import SnapKit
import Then

class ViewController: UIViewController {
    
    let testLabel = UILabel()
        .then {
            $0.text = "MileStone"
            $0.font = .pretendard(.bold, ofSize: 30)
        }
    let testImage = UIImageView()
        .then {
            $0.image = ImageLiteral.imgStone.resize(to: CGSize(width: 60, height: 60))
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubViews([testLabel, testImage])
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        testImage.snp.makeConstraints { make in
            make.bottom.equalTo(testLabel.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        Logger.debugDescription(testImage)
    }
}
