//
//  SubCategory.swift
//  AccountBook
//
//  Created by 백소망 on 2022/12/27.
//

import Foundation
import UIKit

struct SubCategory: Hashable{
    var name: String
    var icon: UIImage
}

extension SubCategory {
    static let list = [
        SubCategory(name: "쇼핑", icon: UIImage(named: "shopping")!),
        SubCategory(name: "문화생활", icon: UIImage(named: "movie")!),
        SubCategory(name: "운동", icon: UIImage(named: "sports")!),
        SubCategory(name: "미용", icon: UIImage(named: "beauty")!),
        SubCategory(name: "밥", icon: UIImage(named: "rice")!),
        SubCategory(name: "카페", icon: UIImage(named: "coffee")!),
        SubCategory(name: "교육", icon: UIImage(named: "education")!),
        SubCategory(name: "공과금", icon: UIImage(named: "utility_bill")!),
        SubCategory(name: "통신비", icon: UIImage(named: "communication")!),
        SubCategory(name: "교통", icon: UIImage(named: "transport")!),
        SubCategory(name: "관광", icon: UIImage(named: "travel")!),
        SubCategory(name: "선물", icon: UIImage(named: "gift")!),
        SubCategory(name: "건강", icon: UIImage(named: "health")!),
        SubCategory(name: "저축", icon: UIImage(named: "saving")!),
    ]
    
    // TODO: 지출 list, 수입 list 따로 저장
}
