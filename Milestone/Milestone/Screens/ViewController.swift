//
//  ViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/04.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then
import Alamofire
import Moya

class ViewController: UIViewController {
    
    let testLabel = UILabel()
        .then {
            $0.text = "MileStone"
            $0.font = .pretendard(.bold, ofSize: 30)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubView(testLabel)
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
