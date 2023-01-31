//
//  ProfileViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2023/01/31.
//

import Foundation
import FirebaseFirestore
import RxSwift

final class ProfileViewModel {
    var user: User = User(uid: "", email: "", nickname: "")
    var uid = PublishSubject<String>()
    var email = PublishSubject<String>()
    var nickname = PublishSubject<String>()
    
    let db = Firestore.firestore()
    
    func getUserInfo() {
        if let uid = UserDefaults.standard.string(forKey: "Uid") {
            self.uid.onNext(uid)
            db.collection("User").document(uid)
                .getDocument { (document, err) in
                    if let document = document, document.exists {
                        let data = document.data()!
//                            .map(String.init(describing:)) ?? "nil"
                        self.nickname.onNext(data["nickname"] as! String)
                        self.email.onNext(data["email"] as! String)
                    } else {
                        print("User Document does not exist")
                    }
                }
        }
    }
}
