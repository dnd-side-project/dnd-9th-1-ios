//
//  SettingViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/24.
//

import UIKit

import RxSwift

class SettingViewController: BaseViewController, ViewModelBindableType {
    
    // MARK: - Subviews
    
    lazy var settingTableView = UITableView()
        .then {
            $0.separatorColor = .gray01
            $0.separatorStyle = .singleLine
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
    
    lazy var modalViewController = ModalViewController()
        .then {
            $0.viewModel = self.viewModel
            $0.askPopUpView.noButton.backgroundColor = .clear
            $0.askPopUpView.yesButton.buttonComponentStyle = .secondary_m_gray
            $0.askPopUpView.noButton.setTitle("지금 안할래요", for: .normal)
            $0.askPopUpView.yesButton.setTitle("지금 할래요", for: .normal)
            $0.modalTransitionStyle = .crossDissolve
            $0.modalPresentationStyle = .overFullScreen
        }
    
    // MARK: - Properties
    
    let cellItems = [["푸시 알림"], ["개인정보 처리 방침", "로그아웃", "회원 탈퇴"]]
    let sectionItems = ["알림", "계정 관리"]
    var buttonDisposeBag = DisposeBag()
    var viewModel: SettingViewModel!
    
    // MARK: - Life Cycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubViews([settingTableView])
        
        settingTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: 네비게이션 컨트롤러가 nil
    override func configUI() {
        self.view.backgroundColor = .white
        self.title = "설정"
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        settingTableView.backgroundColor = .gray01
        settingTableView.sectionHeaderTopPadding = 4
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellFirstSection.identifier) as? SettingTableViewCellFirstSection else { return UITableViewCell() }

            cell.label.text = cellItems[indexPath.section][indexPath.row]
            
            if indexPath.row == 0 {
                UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        cell.toggleButton.isOn = settings.authorizationStatus == .authorized
                    }
                    
                    if settings.authorizationStatus == .authorized {
                        DispatchQueue.main.async {
                            cell.toggleButton.isOn = UserDefaults.standard.bool(forKey: UserDefaultsKeyStyle.registerNotification.rawValue)
                        }
                        
                        cell.toggleButton.rx.isOn
                            .subscribe(onNext: {
                                if $0 {
                                    UserDefaults.standard.set(true, forKey: UserDefaultsKeyStyle.registerNotification.rawValue)
                                    UIApplication.shared.registerForRemoteNotifications()
                                } else {
                                    UserDefaults.standard.set(false, forKey: UserDefaultsKeyStyle.registerNotification.rawValue)
                                    UIApplication.shared.unregisterForRemoteNotifications()
                                }
                            })
                            .disposed(by: self.disposeBag)
                    } else {
                        cell.toggleButton.rx.isOn
                            .subscribe(onNext: {
                                if $0 {
                                    self.modalViewController.askPopUpView.askLabel.text = "푸시알림을 켜시겠어요?"
                                    self.modalViewController.askPopUpView.guideLabel.text = "앱 설정에서 알림 권한을 허용해주세요."
                                    self.present(self.modalViewController, animated: true)
                                    self.modalViewController.askPopUpView.yesButton.rx.tap
                                        .asDriver()
                                        .drive(onNext: {
                                            if let bundle = Bundle.main.bundleIdentifier,
                                                let settings = URL(string: UIApplication.openSettingsURLString + bundle) {
                                                if UIApplication.shared.canOpenURL(settings) {
                                                    UIApplication.shared.open(settings)
                                                }
                                            }
                                        })
                                        .disposed(by: self.buttonDisposeBag)
                                }
                                
                                cell.toggleButton.isOn = false
                            })
                            .disposed(by: self.disposeBag)
                    }
                }
            }
            cell.containerView.makeShadow(color: .init(hex: "#DCDCDC"), alpha: 1.0, x: 0, y: 0, blur: 7, spread: 0)
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCellSecondSection.identifier) as? SettingTableViewCellSecondSection else { return UITableViewCell() }
            cell.label.text = cellItems[indexPath.section][indexPath.row]
            
            if indexPath.row == 2 {
                cell.layer.zPosition = -1
                cell.makeShadow(color: .init(hex: "#DCDCDC"), alpha: 1.0, x: 0, y: 0, blur: 7, spread: 0)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(PrivacyInformationViewController(), animated: true)
            } else if indexPath.row == 1 {
                modalViewController.askPopUpView.askLabel.text = "로그아웃 하시겠어요?"
                modalViewController.askPopUpView.guideLabel.text = "다시 오시길 기다릴게요 🥺"
                modalViewController.selectedRow = indexPath.row
                buttonDisposeBag = DisposeBag()
                
                self.present(modalViewController, animated: true)
            } else if indexPath.row == 2 {
                modalViewController.askPopUpView.askLabel.text = "정말 탈퇴 하시겠어요?"
                modalViewController.askPopUpView.guideLabel.text = "저장된 정보는 복구가 불가능해요 🥺"
                modalViewController.selectedRow = indexPath.row
                
                buttonDisposeBag = DisposeBag()
                self.present(modalViewController, animated: true)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56 + 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerContainerView = UIView()
        let wrapperView = UIView()
        
        let sectionLabel = UILabel()
            .then {
                $0.textColor = .gray03
                $0.font = .pretendard(.semibold, ofSize: 12)
                $0.text = sectionItems[section]
            }
        
        headerContainerView.addSubViews([wrapperView, sectionLabel])
        wrapperView.backgroundColor = .white
        headerContainerView.backgroundColor = .gray01
        sectionLabel.backgroundColor = .white
        
        wrapperView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(headerContainerView)
            make.top.equalTo(headerContainerView).offset(8)
        }
        sectionLabel.snp.makeConstraints { make in
            make.leading.equalTo(wrapperView.snp.leading).offset(24)
            make.centerY.equalTo(wrapperView.snp.centerY)
        }
        
        return headerContainerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
}
