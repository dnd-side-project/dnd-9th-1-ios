//
//  ContentSizedTableView.swift
//  Milestone
//
//  Created by 서은수 on 2023/09/03.
//

import UIKit

// MARK: - content size에 맞게 높이를 자동 조절하는 테이블뷰

final class ContentSizedTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height + adjustedContentInset.top)
    }
}
