//
//  DetailParentViewController.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/11.
//

import UIKit

import SnapKit
import Then
import RxSwift
import RxCocoa

// MARK: - 상위 목표 상세 보기 화면

class DetailParentViewController: BaseViewController {
    
    // MARK: - Subviews
    
    lazy var leftBarButton = UIBarButtonItem()
        .then {
            $0.image = UIImage(systemName: "chevron.left")
            $0.style = .plain
            $0.tintColor = .gray05
            $0.target = self
            $0.action = #selector(pop)
        }
    lazy var rightBarButton = UIBarButtonItem()
        .then {
            $0.image = UIImage(systemName: "ellipsis")
            $0.style = .plain
            $0.tintColor = .gray05
            $0.target = self
            $0.action = #selector(pop) // TODO: - 나중에 바꿔야 함
        }
    let goalTitleLabel = UILabel()
        .then {
            $0.text = "토익 900점 넘기기"
            $0.textColor = .black
            $0.font = .pretendard(.semibold, ofSize: 24)
        }
    
    let dDayLabel = UILabel()
        .then {
            $0.text = "D - 183"
            $0.textColor = .gray01
            $0.font = .pretendard(.semibold, ofSize: 12)
            $0.backgroundColor = .pointPurple
            $0.textAlignment = .center
            $0.layer.cornerRadius = 24 / 2
            $0.clipsToBounds = true
        }
    
    let termLabel = UILabel()
        .then {
            $0.text = "2023.09.08 - 2023.12.02"
            $0.font = .pretendard(.regular, ofSize: 12)
            $0.textColor = .gray03
        }
    
    let flowLayout = UICollectionViewFlowLayout()
        .then {
            $0.itemSize = CGSize(
                width: (UIScreen.main.bounds.width - 48 - 16) / 3,
                height: 148)
            $0.scrollDirection = .vertical
            $0.minimumLineSpacing = 8
            $0.minimumInteritemSpacing = 0
        }
    lazy var detailGoalCollectionView = UICollectionView(frame: CGRect(), collectionViewLayout: flowLayout)
        .then {
            $0.backgroundColor = .gray01
            $0.showsVerticalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.register(cell: DetailGoalCollectionViewCell.self, forCellWithReuseIdentifier: DetailGoalCollectionViewCell.identifier)
            $0.dataSource = self
            $0.delegate = self
        }
    
    // MARK: - Properties
    
    let goalData = [
        DetailGoal(isGoalSet: true, goalTitle: "해커스 1000 LC 2 풀기"), DetailGoal(isGoalSet: true, goalTitle: "영단기 1000 RC 풀기"), DetailGoal(isGoalSet: true, goalTitle: "동사,전치사 어휘 외우기"),
        DetailGoal(isGoalSet: true, goalTitle: "오답 지문 해석하기"), DetailGoal(isGoalSet: true, goalTitle: "기출 문제 3회독 하기"), DetailGoal(isGoalSet: true, goalTitle: "단어 500개 외우기"),
        DetailGoal(isGoalSet: true, goalTitle: "문법 문장 20개 외우기"), DetailGoal(isGoalSet: true, goalTitle: "모르는 단어 정리해두기"), DetailGoal(isGoalSet: false, goalTitle: "다른 교재 새로 사기")
    ]
    var tab = 0
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([goalTitleLabel, dDayLabel, termLabel, detailGoalCollectionView])
        
        goalTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(15)
        }
        dDayLabel.snp.makeConstraints { make in
            make.top.equalTo(goalTitleLabel.snp.bottom).offset(12)
            make.left.equalTo(goalTitleLabel)
            make.width.equalTo(58)
            make.height.equalTo(24)
        }
        termLabel.snp.makeConstraints { make in
            make.centerY.equalTo(dDayLabel)
            make.left.equalTo(dDayLabel.snp.right).offset(8)
        }
        detailGoalCollectionView.snp.makeConstraints { make in
            make.top.equalTo(dDayLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(444 + 16 + 16 + 8)
        }
    }
    
    override func configUI() {
        view.backgroundColor = .gray01
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}

extension DetailParentViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        goalData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailGoalCollectionViewCell.identifier, for: indexPath) as? DetailGoalCollectionViewCell else { return UICollectionViewCell() }
        Logger.debugDescription(cell)
        cell.update(content: goalData[indexPath.row], index: indexPath.row)
        return cell
    }
}

#if canImport(SwiftUI) && (DEBUG)
import SwiftUI

struct DetailParentViewControllerRepresentable: UIViewControllerRepresentable {
    
    let viewController: UIViewController
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

struct DetailParentViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        DetailParentViewControllerRepresentable(viewController: UINavigationController(rootViewController: DetailParentViewController()))
    }
}
#endif
