//
//  DetailViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2023/01/10.
//

import Foundation
import RxSwift

final class DetailViewModel {
    
    // Data -> Output
    let accountBook: BehaviorSubject<AccountBook>
    
    init(accountBook: AccountBook) {
        self.accountBook = BehaviorSubject(value: accountBook)
    }
    
}
