//
//  User.swift
//  AccountBook
//
//  Created by 백소망 on 2023/01/05.
//

import Foundation

struct User: Hashable {
    var uid: String
    var email: String
    var nickname: String
    
    var dictionary: [String: Any] {
        return [
            "uid": uid,
            "email": email,
            "nickname": nickname,
        ]
    }
}

extension User: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let uid = dictionary["uid"] as? String,
              let email = dictionary["email"] as? String,
              let nickname = dictionary["nickname"] as? String
        else { return nil }
        
        self.init(uid: uid, email: email, nickname: nickname)
    }
}
