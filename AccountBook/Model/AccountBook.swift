//
//  AccountBook.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/22.
//

import Foundation

struct AccountBook: Hashable {
    var id = UUID()
    let category: String
    let subcategory: String
    let contents: String
    let price: Int
    let date: String
}

extension AccountBook {
    private var dateComponent: DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let date = formatter.date(from: self.date)
        let dc = calendar.dateComponents([.year, .month, .day, .hour], from: date!)
        return dc
    }
    
    var monthlyIdentifier: String {
        return "\(dateComponent.year!)-\(dateComponent.month!)-\(dateComponent.day!)-\(dateComponent.hour!)"
    }
}


// temp data

extension AccountBook {
    static let tempList = [
        AccountBook(
            category: "수입",
            subcategory: "11월 월급",
            contents: "월급",
            price: 1000000,
            date: "2022-11-10 13:00"
        ),
        AccountBook(
            category: "지출",
            subcategory: "문화생활",
            contents: "<와칸다 포에버> 영화",
            price: 14000,
            date: "2022-11-22 20:30"
        ),
        
        AccountBook(
            category: "지출",
            subcategory: "11월 통신비",
            contents: "통신",
            price: 50000,
            date: "2022-11-10 17:00"
        )
    ]
}
