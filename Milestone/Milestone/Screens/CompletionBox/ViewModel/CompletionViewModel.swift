//
//  CompletionViewModel.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/14.
//

import UIKit
import RxCocoa
import RxDataSources
import RxSwift

struct Goal: IdentifiableType, Equatable {
    let title: String
    let startDate: Date
    let endDate: Date
    let isCompleted: Bool
    let identity: Int
}

typealias CompletionSectionModel = AnimatableSectionModel<Int, Goal>

class CompletionViewModel {
    
    private var goalList = [Goal(title: "", startDate: Date(), endDate: Date(),isCompleted: true, identity: -1), Goal(title: "포토샵 자격증 따기", startDate: Date(), endDate: Date().addingTimeInterval(100), isCompleted: true, identity: 0), Goal(title: "자격증 포토샵 따기", startDate: Date().addingTimeInterval(100), endDate: Date().addingTimeInterval(200), isCompleted: true, identity: 1), Goal(title: "스위프트 마스터하기", startDate: Date().addingTimeInterval(300), endDate: Date().addingTimeInterval(500), isCompleted: false, identity: 2)]
    
//    private var goalList: [Goal] = []
    
    private lazy var sectionModel = goalList.enumerated().map { index, goal in
        CompletionSectionModel(model: index, items: [goal])
    }
    
    private lazy var store = BehaviorSubject<[CompletionSectionModel]>(value: sectionModel)
    
    var dataSource: RxTableViewSectionedAnimatedDataSource<CompletionSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<CompletionSectionModel> { dataSource, tableView, indexPath, goal in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CompletionTableViewCell.identifier, for: indexPath) as? CompletionTableViewCell else { return UITableViewCell() }
            
            if indexPath.section == 0 {
                let completionView = CompletionAlertView()
                
                cell.contentView.addSubview(completionView)
                completionView.snp.makeConstraints { make in
                    make.margins.equalTo(cell.contentView.snp.margins)
                }
                cell.calendarImageView.isHidden = true
                cell.button.isHidden = true
                cell.completionImageView.isHidden = true
                cell.dateLabel.isHidden = true
                cell.label.isHidden = true
                
                return cell
            }
            
            cell.label.text = goal.title
            
            let dateFormatter = DateFormatter().then { $0.dateFormat = "yyyy.MM.dd" }
            let startDateString = dateFormatter.string(from: goal.startDate)
            let endDateString = dateFormatter.string(from: goal.endDate)
            
            cell.dateLabel.text = startDateString + " - " + endDateString
            
            if goal.isCompleted {
                cell.button.setTitle("회고 보기", for: .normal)
                cell.button.setTitleColor(.primary, for: .normal)
                cell.button.backgroundColor = .white
                cell.button.layer.borderColor = UIColor.secondary01.cgColor
                cell.button.layer.borderWidth = 1
            } else {
                cell.button.setTitle("회고 작성하기", for: .normal)
                cell.button.setTitleColor(.primary, for: .normal)
                cell.backgroundColor = .secondary03
                cell.layer.borderColor = UIColor.clear.cgColor
            }
            
            return cell
        }
        
        return ds
    }()

    var completionList: Observable<[CompletionSectionModel]> {
        return store
    }

}
