//
//  AccountBookListViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2022/11/22.
//

import Foundation
import FirebaseFirestore
import RxSwift

final class AccountBookListViewModel {
    
    var list = BehaviorSubject<[AccountBook]>.init(value: [])
    var summary = BehaviorSubject<Summary>.init(value: Summary.default)
    var dateFilter = BehaviorSubject<String>.init(value: "")
    var uid = BehaviorSubject<String>.init(value: "")
    
    let db = Firestore.firestore()
    let selectedItem: BehaviorSubject<AccountBook?>
    
    init(selectedItem: AccountBook? = nil) {
        self.selectedItem = BehaviorSubject(value: selectedItem)
    }
    
    func didSelect(at indexPath: IndexPath) {
        do {
            let item = try list.value()[indexPath.item]
            selectedItem.onNext(item)
        } catch {
            print("error!")
        }
    }
    
    func fetchAccountBooks() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        self.dateFilter.onNext(formatter.string(from: Date()))
    }
    
    func getUid() {
        if let uid = UserDefaults.standard.string(forKey: "Uid") {
            self.uid.onNext(uid)
        } else {
            print("uid 없음!")
        }
    }
    
    func fetchDateFilter() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        self.dateFilter.onNext(formatter.string(from: Date()))
    }
    
    func loadFirebaseData(dateFilter: String){
        var list: [AccountBook] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월"
        
        let ref = db
            .collection("User").document(try! self.uid.value())
            .collection("AccountBook")
            .order(by: "date", descending: true)
        
        ref.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    if self.formatDate(data["date"] as! String) == dateFilter {
                        list.append(AccountBook(category: data["category"] as! String, subcategory: data["subcategory"] as! String, contents: data["contents"] as! String, price: data["price"] as! Int, date: data["date"] as! String))
                    }
                }
                self.list.onNext(list)
            }
        }
    }
    
    private func formatDate(_ origin: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        if let date = formatter.date(from: origin) {
            formatter.dateFormat = "yyyy년 MM월"
            return formatter.string(from: date)
        } else {
            print("formatDate error!")
            return ""
        }
    }
    
    

}

