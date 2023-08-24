//
//  SettingViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/24.
//

import UIKit

class SettingViewController: BaseViewController {
    
    // MARK: - Subviews
    
    lazy var settingTableView = UITableView()
        .then {
            $0.separatorStyle = .none
            $0.register(cell: SettingTableViewCellFirstSection.self, forCellReuseIdentifier: SettingTableViewCellFirstSection.identifier)
            $0.register(cell: SettingTableViewCellSecondSection.self, forCellReuseIdentifier: SettingTableViewCellSecondSection.identifier)
            $0.dataSource = self
            $0.delegate = self
        }
    
    lazy var leftBarButton = UIBarButtonItem()
        .then {
            $0.image = UIImage(systemName: "chevron.left")
            $0.style = .plain
            $0.tintColor = .gray05
            $0.target = self
            $0.action = #selector(pop)
        }
    
    // MARK: - Properties
    
    let cellItems = [["푸시 알림", "리마인드 알림"], ["개인정보 처리 방침", "로그아웃", "회원 탈퇴"]]
    let sectionItems = ["알림", "계정 관리"]
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([settingTableView])
        
        settingTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configUI() {
        self.view.backgroundColor = .white
        self.title = "설정"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            print("case: \(indexPath.section)")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellFirstSection.identifier) as? SettingTableViewCellFirstSection else { return UITableViewCell() }
            print( cellItems[indexPath.section][indexPath.row])
            cell.label.text = cellItems[indexPath.section][indexPath.row]
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellSecondSection.identifier) as? SettingTableViewCellSecondSection else { return UITableViewCell() }
            cell.label.text = cellItems[indexPath.section][indexPath.row]
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56 + 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerContainerView = UIView()
        
        let sectionLabel = UILabel()
            .then {
                $0.textColor = .gray03
                $0.font = .pretendard(.semibold, ofSize: 12)
                $0.text = sectionItems[section]
            }
        
        headerContainerView.addSubview(sectionLabel)
        
        sectionLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerContainerView.snp.leading).offset(24)
            make.centerY.equalTo(headerContainerView.snp.centerY)
        }
        
        return headerContainerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
}
