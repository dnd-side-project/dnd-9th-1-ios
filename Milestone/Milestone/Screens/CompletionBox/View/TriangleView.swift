//
//  TriangleView.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/15.
//

import UIKit

/// 말풍선 꼬리 뷰
class TriangleView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        UIColor.gray05.set()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        path.lineWidth = 6
        path.miterLimit = .pi
        path.move(to: CGPoint(x: self.frame.width / 2 - 2, y: 0))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: self.frame.width / 2 + 2, y: 0))
        path.close()
        path.fill()
    }

}
