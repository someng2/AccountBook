//
//  ProfileViewController.swift
//  AccountBook
//
//  Created by 백소망 on 2023/01/16.
//

import UIKit
import FirebaseFirestore
import RxSwift

class ProfileViewController: UIViewController {
    
    var user: User = User(uid: "", email: "", nickname: "")
    var uid = PublishSubject<String>()
    var email = PublishSubject<String>()
    var nickname = PublishSubject<String>()
    
    let db = Firestore.firestore()
    let bag = DisposeBag()
    
    var nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    var emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        getUserInfo()
    }
    
    private func bind() {
        uid.subscribe { uid in
//            print("---> uid = \(uid)")
            self.user.uid = uid
        }.disposed(by: bag)
        
        email.subscribe { email in
//            print("---> email = \(email)")
            self.user.email = email
            self.addEmailLabel(email)
        }.disposed(by: bag)
        
        nickname.subscribe { nickname in
//            print("---> nickname = \(nickname)")
            self.user.nickname = nickname
            self.addNicknameLabel(nickname)
        }.disposed(by: bag)
    }
    
    private func getUserInfo() {
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
    
    private func addNicknameLabel(_ nickname: String) {
        nicknameLabel.text = nickname
        view.addSubview(nicknameLabel)
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25)
        ])
    }
    
    private func addEmailLabel(_ email: String) {
        emailLabel.text = email
        view.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 25),
            emailLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor)
        ])
    }

}
