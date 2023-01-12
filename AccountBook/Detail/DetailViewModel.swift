//
//  DetailViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2023/01/10.
//

import Foundation
import Combine
import RxSwift

final class DetailViewModel {
    
    // Data -> Output
//    let accountBook: CurrentValueSubject<AccountBook, Never>
    let accountBook: BehaviorSubject<AccountBook>
    
    init(accountBook: AccountBook) {
//        self.accountBook = CurrentValueSubject(accountBook)
        self.accountBook = BehaviorSubject(value: accountBook)
    }
    
}
