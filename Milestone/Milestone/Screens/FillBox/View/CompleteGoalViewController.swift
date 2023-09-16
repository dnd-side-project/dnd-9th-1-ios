//
//  CompleteGoalViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/19.
//

import UIKit

import SnapKit
import Then

// MARK: - 목표 완료 시 팝업 뷰

class CompleteGoalViewController: BaseViewController {
    
    // MARK: - Subviews
    
    private lazy var completePopUpView = CompleteView()
        .then {
            $0.alertImageView.image = ImageLiteral.imgCompleteGoal
            let stringValue = "목표 달성을 축하드려요!"
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
            attributedString.setColorForText(textForAttribute: "목표 달성", withColor: .pointPurple)
            attributedString.setColorForText(textForAttribute: "을 축하드려요!", withColor: .black)
            $0.completeLabel.attributedText = attributedString
            $0.completeInformationLabel.text = "3번째 보석을 찾으셨네요!"
            $0.completeInformationLabel.textColor = .black
            $0.closeButton.addTarget(self, action: #selector(dismissCompleteGoal), for: .touchUpInside)
            $0.goToButton.addTarget(self, action: #selector(goToCompletionBox), for: .touchUpInside)
        }
    
    // MARK: - Properties
    
    var viewModel: DetailParentViewModel!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeUserDefaultsForRecommend()
    }
    
    // MARK: - Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first, touch.view == view {
            dismiss(animated: true) // 배경 클릭 시 dismiss
        }
    }
    
    override func render() {
        view.addSubView(completePopUpView)
        
        completePopUpView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configUI() {
        view.backgroundColor = UIColor.init(hex: "#000000").withAlphaComponent(0.3)
        
        let value = viewModel.completedGoalResult.value
        completePopUpView.alertImageView.image = UIImage(named: JewelPopUpImageStyle(rawValue: value.rewardType ?? "BLUE_JEWEL_1")?.caseString ?? "blueStonePopUpVer1")
        completePopUpView.completeInformationLabel.text = "\(value.completedGoalCount)번째 보석을 찾으셨네요!"
    }
    
    /// 목표 완료 팝업 뷰가 띄워졌으니 UserDefaults 값을 바꾼다
    /// - 여기서 true 값으로 바뀜으로써 채움함 화면으로 나가졌을 때 목표 권유 팝업 뷰가 띄워진다
    private func changeUserDefaultsForRecommend() {
        UserDefaults.standard.set(true, forKey: UserDefaultsKeyStyle.recommendGoalView.rawValue)
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func dismissCompleteGoal() {
        dismiss(animated: true)
    }
    
    /// 팝업 dismiss 하고 detailParentVC도 pop 시켜서 메인으로 이동하고
    /// Notification 발송해서 완료함 화면을 보여준다
    @objc
    private func goToCompletionBox() {
        self.dismiss(animated: true)
        self.viewModel?.popDetailParentVC.accept(true)
        NotificationCenter.default.post(name: .changeSegmentControl, object: 2) // 완료함 인덱스 전송
    }
}
