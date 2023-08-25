//
//  JewelPopUpImageStyle.swift
//  Milestone
//
//  Created by 서은수 on 2023/08/26.
//

import UIKit

// MARK: - 보석 이미지와 팝업 이미지 이름을 매칭

enum JewelPopUpImageStyle: String {
    case blueStonePopUpVer1 = "BLUE_JEWEL_1"
    case blueStonePopUpVer2 = "BLUE_JEWEL_2"
    case blueStonePopUpVer3 = "BLUE_JEWEL_3"
    case blueStonePopUpVer4 = "BLUE_JEWEL_4"
    case blueStonePopUpVer5 = "BLUE_JEWEL_5"
    case purpleStonePopUpVer1 = "PURPLE_JEWEL_1"
    case purpleStonePopUpVer2 = "PURPLE_JEWEL_2"
    case purpleStonePopUpVer3 = "PURPLE_JEWEL_3"
    case purpleStonePopUpVer4 = "PURPLE_JEWEL_4"
    case purpleStonePopUpVer5 = "PURPLE_JEWEL_5"
    case pinkStonePopUpVer1 = "PINK_JEWEL_1"
    case pinkStonePopUpVer2 = "PINK_JEWEL_2"
    case pinkStonePopUpVer3 = "PINK_JEWEL_3"
    case pinkStonePopUpVer4 = "PINK_JEWEL_4"
    case pinkStonePopUpVer5 = "PINK_JEWEL_5"
    case greenStonePopUpVer1 = "GREEN_JEWEL_1"
    case greenStonePopUpVer2 = "GREEN_JEWEL_2"
    case greenStonePopUpVer3 = "GREEN_JEWEL_3"
    case greenStonePopUpVer4 = "GREEN_JEWEL_4"
    case greenStonePopUpVer5 = "GREEN_JEWEL_5"
    
    var caseString: String {
        String(describing: self)
    }
}
