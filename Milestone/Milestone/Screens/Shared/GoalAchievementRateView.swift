//
//  GoalAchievementRateView.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/19.
//

import UIKit

class GoalAchievementRateView: UIView {
    
    // MARK: Subviews
    private let countLabel = UILabel()
        .then {
            $0.textColor = .primary
            $0.font = .pretendard(.semibold, ofSize: 14)
        }
    
    // MARK: Properties
    var completedCount: CGFloat = 0
    var totalCount: CGFloat = 0
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        render()
        configUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    override func draw(_ rect: CGRect) {
        
        let radian = 270 - 360 * (completedCount / totalCount)
        
        self.countLabel.text = "\(Int(completedCount))/\(Int(totalCount))"
        
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: 22, startAngle: (270 * .pi) / 180, endAngle: (radian * .pi) / 180, clockwise: false)

        path.lineWidth = 6
        UIColor.primary.set()
        path.stroke()
    }
    
    func render() {
        self.addSubview(countLabel)
        
        countLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func configUI() {
        self.clipsToBounds = false
        self.backgroundColor = .systemBackground
    }
}
