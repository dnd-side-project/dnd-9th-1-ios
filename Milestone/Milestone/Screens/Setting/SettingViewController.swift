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
            $0.delegate = self
            $0.dataSource = self
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellFirstSection.identifier) as? SettingTableViewCellFirstSection else { return UITableViewCell() }
            cell.label.text = cellItems[indexPath.section][indexPath.item]
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellSecondSection.identifier) as? SettingTableViewCellSecondSection else { return UITableViewCell() }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension SettingViewController: UITableViewDelegate {
    
}
