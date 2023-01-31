//
//  AccountBook.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/22.
//

import Foundation
import Firebase

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct AccountBook: Hashable{
//    @DocumentID var documentID: String?
    
    var id: String
    var category: String
    var subcategory: String
    var contents: String
    var price: Int
    var date: String
    
    var dictionary: [String: Any] {
        return [
            "id": id,
            "category": category,
            "subcategory": subcategory,
            "contents": contents,
            "price": price,
            "date": date
        ]
    }
    
//    enum CodingKeys: String, CodingKey {
//        case documentID = "document_id"
////        case category
//    }
}

extension AccountBook: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let category = dictionary["category"] as? String,
              let subcategory = dictionary["subcategory"] as? String,
              let contents = dictionary["contents"] as? String,
              let price = dictionary["subcategory"] as? Int,
              let date = dictionary["date"] as? String
        else { return nil }
        
        self.init(id: id, category: category, subcategory: subcategory, contents: contents, price: price, date: date)
    }
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
    
    var hourIdentifier: String {
        return "\(dateComponent.year!)-\(dateComponent.month!)-\(dateComponent.day!)-\(dateComponent.hour!)"
    }
    
    var monthlyIdentifier: String {
        return "\(dateComponent.year!)년 \(dateComponent.month!)월"
    }
}


// temp data
//
//extension AccountBook {
//    static let tempList = [
//        AccountBook(
//            category: "수입",
//            subcategory: "월급",
//            contents: "12월 월급",
//            price: 3000000,
//            date: "2022.12.10 13:00"
//        ),
//        AccountBook(
//            category: "지출",
//            subcategory: "문화생활",
//            contents: "<와칸다 포에버> 영화",
//            price: 14000,
//            date: "2022.10.22 20:30"
//        ),
//        
//        AccountBook(
//            category: "지출",
//            subcategory: "통신",
//            contents: "12월 통신비",
//            price: 50000,
//            date: "2022.12.10 17:00"
//        ),
//        AccountBook(
//            category: "지출",
//            subcategory: "문화샐활",
//            contents: "넷플릭스 자동결제",
//            price: 4000,
//            date: "2022.11.05 17:00"
//        ),
//        AccountBook(
//            category: "수입",
//            subcategory: "용돈",
//            contents: "12월 용돈",
//            price: 1000000,
//            date: "2022.12.01 10:00"
//        )
//    ]
//}
