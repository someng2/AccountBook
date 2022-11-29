//
//  Summary.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/29.
//

import Foundation

struct Summary: Hashable {
    var revenue: Int
    var expense: Int
    var sum: Int
}

extension Summary {
    static let `default` = Summary(revenue: 0, expense: 0, sum: 0)
}
