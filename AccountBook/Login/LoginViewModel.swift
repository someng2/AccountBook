//
//  LoginViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2023/01/05.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import RxSwift

final class LoginViewModel {
    
    var user: User
    var uid = PublishSubject<String>()
    var email = PublishSubject<String>()
    var nickname = PublishSubject<String>()
    
    let db = Firestore.firestore()
    let bag = DisposeBag()
    
    init() {
        self.user = User(uid: "", email: "", nickname: "")
        
        uid.subscribe { uid in
            print("---> uid = \(uid)")
            self.user.uid = uid
        }.disposed(by: bag)
        
        email.subscribe { email in
//            print("---> email = \(email)")
            self.user.email = email
        }.disposed(by: bag)
        
        nickname.subscribe { nickname in
//            print("---> nickname = \(nickname)")
            self.user.nickname = nickname
        }.disposed(by: bag)
    }
    
    func saveNewUser(email: String, pw: String) {
        Auth.auth().createUser(withEmail: email, password: pw) {(result, error) in
            if let error = error {
                print("createUser error \"\(error.localizedDescription)\"")
                return
            }
            print("result: \(String(describing: result))")
            
            guard let user = result?.user else {
                return
            }
            print("---> New user's uid = \(user.uid)")
            
            self.db.collection("User").document(user.uid)
                .setData([
                    "uid" : user.uid,
                    "email" : self.user.email,
                    "nickname" : self.user.nickname
                ]) { err in
                    if let err = err {
                        print("---> Error saving user: \(err)")
                    } else {
                        print("Firebase 저장 성공!")
                    }
                }
        }
    }
    

    
}
