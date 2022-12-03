//
//  AccountBookListViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/22.
//

import Foundation

final class AccountBookListViewModel {
    
    @Published var list: [AccountBook] = []
    //    @Published var dic: [String: [AccountBook]] = [:]
    @Published var summary: Summary = Summary.default
    @Published var dateFilter: String = ""
    
    // 날짜 정렬
    //    var keys: [String] {
    //        return dic.keys.sorted { $0 > $1 }
    //    }
    
    func fetchAccountBooks() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        self.dateFilter = formatter.string(from: Date())
//        print("dateFilter = ", dateFilter)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.list = AccountBook.tempList.filter {
                $0.monthlyIdentifier == self.dateFilter
            }
        }
        
        self.summary = Summary.default
    }
}

