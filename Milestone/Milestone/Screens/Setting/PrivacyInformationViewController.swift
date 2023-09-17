//
//  PrivacyInformationViewController.swift
//  Milestone
//
//  Created by 박경준 on 2023/08/25.
//

import UIKit

class PrivacyInformationViewController: BaseViewController {

    // MARK: - Subviews
    
    lazy var leftBarButton = UIBarButtonItem()
        .then {
            $0.image = UIImage(systemName: "chevron.left")
            $0.imageInsets = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 0)
            $0.style = .plain
            $0.tintColor = .gray05
            $0.target = self
            $0.action = #selector(pop)
        }
    
    let scrollView = UIScrollView()
        .then { sv in
            let view = UIView()
            sv.addSubview(view)
            view.snp.makeConstraints {
                $0.top.equalTo(sv.contentLayoutGuide.snp.top)
                $0.leading.equalTo(sv.contentLayoutGuide.snp.leading)
                $0.trailing.equalTo(sv.contentLayoutGuide.snp.trailing)
                $0.bottom.equalTo(sv.contentLayoutGuide.snp.bottom)

                $0.leading.equalTo(sv.frameLayoutGuide.snp.leading)
                $0.trailing.equalTo(sv.frameLayoutGuide.snp.trailing)
                $0.height.equalTo(sv.frameLayoutGuide.snp.height).priority(.low)
            }
        }
    
    lazy var titleLabel = UILabel()
        .then {
            $0.text = "개인정보 처리 방침"
            $0.font = .pretendard(.semibold, ofSize: 24)
            $0.textColor = .black
        }
    
    let firstContent = InformationBox()
        .then {
            $0.text = "개인정보 처리방침은 MileStone(이하 \"회사\"라 합니다)이 특정한 가입절차를 거친 이용자들만 이용 가능한 폐쇄형 서비스를 제공함에 있어, 개인정보를 어떻게 수집·이용·보관·파기하는지에 대한 정보를 담은 방침을 의미합니다. 개인정보 처리방침은 개인정보보호법 등 국내 개인정보 보호 법령을 모두 준수하고 있습니다. 본 개인정보 처리방침에서 정하지 않은 용어의 정의는 서비스 이용약관을 따릅니다."
            $0.titleLabel.text = "1. 개인정보 처리방침"
        }
    
    let secondContent = InformationBox()
        .then {
            $0.text = "회사는 서비스 제공을 위해 다음 항목 중 최소한의 개인정보를 수집합니다."
            $0.titleLabel.text = "2. 수집하는 개인정보의 항목"
        }
    
    let secondOneContent = InformationLabel()
        .then {
            $0.numberOfLines = 0
            $0.isPrimary = false
            $0.text = "1) 회원가입 시 수집되는 개인정보\n닉네임"
        }
    
    let secondTwoContent = InformationBox()
        .then {
            $0.titleLabel.text = "2) 수집한 개인정보의 처리 목적\n수집된 개인정보는 다음의 목적에 한해 이용됩니다."
            $0.titleLabel.isPrimary = false
            $0.text = "1. 가입 및 탈퇴 의사 확인, 회원 식별 등 회원 관리\n2. 서비스 제공 및 기존·신규 시스템 개발·유지·개선\n3. 문의·제휴·광고·이벤트·게시 관련 요청 응대 및 처리"
        }
    
    let thirdContent = InformationBox()
        .then {
            $0.text = "회사는 회원의 개인정보를 제3자에게 제공하지 않습니다. 단, 다음의 사유가 있을 경우 제공할 수 있습니다. \n1. 회원이 제휴사의 서비스를 이용하기 위해 개인정보 제공을 회사에 요청할 경우 \n2. 관련법에 따른 규정에 의한 경우 \n3. 이용자의 생명이나 안전에 급박한 위험이 확인되어 이를 해소하기 위한 경우\n4. 영업의 양수 등"
            $0.titleLabel.text = "3. 개인정보의 제3자 제공"
        }
    
    let fourthContent = InformationBox()
        .then {
            $0.text = "회사는 원활한 개인정보 업무처리와 보안성 높은 서비스 제공을 위하여, 신뢰도가 검증된 다음 회사 및 서비스에 개인정보 관련 업무 처리를 위탁하고 있습니다. 위탁계약 체결 시 회사는 기술적·관리적 보호조치 등 수탁자에 대한 관리·감독을 하고 있습니다.\n1. Amazon Web Services, Inc. : 서비스 시스템 제공, 데이터 관리 및 보관\n2. Apple : 회원 관리, 운영 시스템 지원\n3. Kakao : 회원 관리, 운영 시스템 지원"
            $0.titleLabel.text = "4. 개인정보 처리의 위탁"
        }
    
    let fifthContent = InformationBox()
        .then {
            $0.text = "회사는 서비스를 제공하는 동안 개인정보 처리방침 및 관련법에 의거하여 회원의 개인정보를 지속적으로 관리 및 보관합니다. 탈퇴 등 개인정보 수집 및 이용목적이 달성될 경우, 수집된 개인정보는 즉시 또는 다음과 같이 일정 기간 이후 파기됩니다.\n1. 가입 시 수집된 개인정보 : 탈퇴 후 14일\n2. 제휴·광고·이벤트 관련 요청 응대 및 처리 자료 : 3개월\n3. 기기 정보 및 로그 기록 : 최대 1년\n4. 문의 및 응대 기록 : 3년\n ※ 위 항에도 불구하고 법령에 의해 개인정보를 보존해야 하는 경우, 해당 개인정보는 물리적·논리적으로 분리하여 해당 법령에서 정한 기간에 따라 저장합니다.※ 회원 탈퇴, 보관 기한 만료 등 파기 사유가 발생한 개인정보는 재생이 불가능한 방법으로 파기됩니다. 전자적 파일 형태로 기록·저장된 개인정보는 기록을 재생할 수 없도록 파기하며, 종이 문서에 기록·저장된 개인정보는 분쇄기로 분쇄하거나 소각하여 파기합니다.※ 회원이 1년 이상 로그인 및 접속을 하지 않을 경우, 해당 계정은 휴면 계정으로 전환됩니다. 개인정보의 안전한 처리를 위해 닉네임 정보는 분리 보관되며, 이외의 개인정보 및 이용기록은 모두 파기될 수 있습니다. 휴면 계정이 로그인에 성공할 경우, 휴면 상태가 즉시 해제되어 모든 서비스를 이용할 수 있습니다. 휴면 계정 전환 이후에도 3년 동안 로그인을 하지 않을 경우, 해당 계정은 영구 삭제됩니다."
            $0.titleLabel.text = "5. 수집한 개인정보의 보관 및 파기"
        }
    
    let sixthContent = InformationBox()
        .then {
            $0.contentsLabel.text = "회원은 언제든지 MileStone팀 이메일 (rudwns3927@gmail.com)을 통해 자신의 개인정보를 조회하거나 수정, 삭제, 탈퇴를 할 수 있습니다."
            $0.titleLabel.text = "6. 정보주체의 권리, 의무 및 행사"
        }
    
    let seventhContent = InformationBox()
        .then {
            $0.text = "회사는 회원의 개인정보를 최선으로 보호하고 관련된 불만을 처리하기 위해 최선의 노력을 다하고 있습니다.\n1. 개인정보보호 담당 부서 : MileStone 서버 팀\n2. MileStone 팀 이메일 : rudwns3927@gmail.com\n※ 서비스 이용, 접근 제한 등의 문의는 위 창구를 통해 처리되지 않습니다. 해당 문의는 MileStone 이메일 (rudwns3927@gmail.com)을 통해 전달해주시기 바랍니다. 기타 개인정보 침해에 대한 신고나 상담이 필요하신 경우에는 다음 기관에 문의하시기 바랍니다. \n1. 개인정보 분쟁조정위원회 : https://www.kopico.go.kr\n2. 사이버범죄 신고시스템 : https://ecrm.police.go.kr"
            $0.titleLabel.text = "7. 개인정보에 관한 책임자 및 서비스"
        }
    
    let eighthContent = InformationBox()
        .then {
            $0.text = "이 개인정보 처리방침은 2023년 8월 25일에 개정되었습니다."
            $0.titleLabel.text = "8. 기타"
        }
    
    let navAppearance = UINavigationBarAppearance()
        .then {
            $0.configureWithOpaqueBackground()
            $0.shadowColor = .clear
            $0.shadowImage = UIImage()
        }
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navAppearance.backgroundColor = .gray01
        self.navigationController?.navigationBar.standardAppearance = navAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navAppearance.backgroundColor = nil
        self.navigationController?.navigationBar.standardAppearance = navAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
    }
    
    // MARK: - Functions
    
    override func render() {
        view.addSubview(scrollView)
        scrollView.subviews.first!.addSubViews([titleLabel, firstContent, secondContent, secondOneContent, secondTwoContent, thirdContent, fourthContent, fifthContent, sixthContent, seventhContent, eighthContent])
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(30)
            make.left.equalToSuperview().inset(24)
        }
        
        firstContent.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        secondContent.snp.makeConstraints { make in
            make.top.equalTo(firstContent.contentsLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        secondOneContent.snp.makeConstraints { make in
            make.top.equalTo(secondContent.contentsLabel.snp.bottom).offset(24)
            make.leading.equalTo(secondContent)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        secondTwoContent.snp.makeConstraints { make in
            make.top.equalTo(secondOneContent.snp.bottom).offset(24)
            make.leading.equalTo(secondContent)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        thirdContent.snp.makeConstraints { make in
            make.top.equalTo(secondTwoContent.contentsLabel.snp.bottom).offset(24)
            make.leading.equalTo(secondTwoContent)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        fourthContent.snp.makeConstraints { make in
            make.top.equalTo(thirdContent.contentsLabel.snp.bottom).offset(24)
            make.leading.equalTo(thirdContent)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        fifthContent.snp.makeConstraints { make in
            make.top.equalTo(fourthContent.contentsLabel.snp.bottom).offset(24)
            make.leading.equalTo(fourthContent)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        sixthContent.snp.makeConstraints { make in
            make.top.equalTo(fifthContent.contentsLabel.snp.bottom).offset(24)
            make.leading.equalTo(fifthContent)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        seventhContent.snp.makeConstraints { make in
            make.top.equalTo(sixthContent.contentsLabel.snp.bottom).offset(24)
            make.leading.equalTo(sixthContent)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        eighthContent.snp.makeConstraints { make in
            make.top.equalTo(seventhContent.contentsLabel.snp.bottom).offset(24)
            make.leading.equalTo(seventhContent)
            make.trailing.equalToSuperview().offset(-48)
            make.height.equalTo(42)
            make.bottom.equalTo(scrollView.snp.bottom).offset(-16)
        }
    }
    
    override func configUI() {
        self.navigationItem.leftBarButtonItem = leftBarButton
        view.backgroundColor = .gray01
    }
}
