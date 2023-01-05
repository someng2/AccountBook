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
    static let expenseList = [
        SubCategory(name: "쇼핑", icon: UIImage(named: "shopping")!),
        SubCategory(name: "문화생활", icon: UIImage(named: "movie")!),
        SubCategory(name: "선물", icon: UIImage(named: "gift")!),
        SubCategory(name: "운동", icon: UIImage(named: "sports")!),
        SubCategory(name: "건강", icon: UIImage(named: "health")!),
        SubCategory(name: "미용", icon: UIImage(named: "beauty")!),
        SubCategory(name: "밥", icon: UIImage(named: "rice")!),
        SubCategory(name: "카페", icon: UIImage(named: "coffee")!),
        SubCategory(name: "저축", icon: UIImage(named: "saving")!),
        SubCategory(name: "교육", icon: UIImage(named: "education")!),
        SubCategory(name: "반려동물", icon: UIImage(named: "pet")!),
        SubCategory(name: "교통", icon: UIImage(named: "transport")!),
        SubCategory(name: "여행", icon: UIImage(named: "travel")!),
        SubCategory(name: "주거비", icon: UIImage(named: "housing")!),
        SubCategory(name: "공과금", icon: UIImage(named: "utility_bill")!),
        SubCategory(name: "보험", icon: UIImage(named: "insurance")!),
        SubCategory(name: "경조사", icon: UIImage(named: "wedding")!),
        SubCategory(name: "통신비", icon: UIImage(named: "communication")!),
        SubCategory(name: "기타", icon: UIImage(named: "etc")!)
    ]
    static let revenueList = [
        SubCategory(name: "용돈", icon: UIImage(named: "allowance")!),
        SubCategory(name: "월급", icon: UIImage(named: "pay")!),
        SubCategory(name: "임대료", icon: UIImage(named: "rent")!),
        SubCategory(name: "주식", icon: UIImage(named: "stock")!),
        SubCategory(name: "복권", icon: UIImage(named: "lottery")!),
        SubCategory(name: "장학금", icon: UIImage(named: "scholarship")!),
        SubCategory(name: "적금", icon: UIImage(named: "installment saving")!),
        SubCategory(name: "기타", icon: UIImage(named: "etc")!)
    ]
}
