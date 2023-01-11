//
//  AccountBookListViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/22.
//

import Foundation
import FirebaseFirestore
import Combine

final class AccountBookListViewModel {
    
    @Published var list: [AccountBook] = []
    @Published var summary: Summary = Summary.default
    @Published var dateFilter: String = ""
    @Published var uid: String = ""
    
    let db = Firestore.firestore()

    let selectedItem: CurrentValueSubject<AccountBook?, Never>
    let didSelect = PassthroughSubject<AccountBook, Never>()
    
    init(selectedItem: AccountBook? = nil) {
        self.selectedItem = CurrentValueSubject(selectedItem)
    }
    
    func didSelect(at indexPath: IndexPath) {
        let item = list[indexPath.item]
        selectedItem.send(item)
    }
    
    func fetchAccountBooks() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        self.dateFilter = formatter.string(from: Date())
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.list = AccountBook.tempList.filter {
//                $0.monthlyIdentifier == self.dateFilter
//            }.sorted(by: { $0.hourIdentifier > $1.hourIdentifier })
//        }
//
    }
    
    func getUid() {
        if let uid = UserDefaults.standard.string(forKey: "Uid") {
            self.uid = uid
        } else {
            print("uid 없음!")
        }
    }
    
    func fetchDateFilter() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        self.dateFilter = formatter.string(from: Date())
    }
    
    func loadFirebaseData(dateFilter: String){
        var list: [AccountBook] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        
        let ref = db
            .collection("User").document(self.uid)
            .collection("AccountBook")
        
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if self.formatDate(data["date"] as! String) == dateFilter {
//                        print("\(document.documentID) => \(data)")
                        list.append(AccountBook(category: data["category"] as! String, subcategory: data["subcategory"] as! String, contents: data["contents"] as! String, price: data["price"] as! Int, date: data["date"] as! String))
                    }
                }
                self.list = list.sorted(by: { $0.hourIdentifier > $1.hourIdentifier })
            }
        }
    }
    
    private func formatDate(_ origin: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        if let date = formatter.date(from: origin) {
            formatter.dateFormat = "yyyy년 MM월"
//            print("---> formatDate: \(formatter.string(from: date))")
            return formatter.string(from: date)
        } else {
            print("formatDate error!")
            return ""
        }
    }
    
    

}

