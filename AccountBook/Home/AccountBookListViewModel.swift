//
//  AccountBookListViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/22.
//

import Foundation

final class AccountBookListViewModel {
    @Published var list: [AccountBook] = []
    @Published var dic: [String: [AccountBook]] = [:]
    
    // 날짜 정렬
//    var keys: [String] {
//        return dic.keys.sorted { $0 > $1 }
//    }
    
    func fetchAccountBooks() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.list = AccountBook.tempList
        }
    }
    
}

