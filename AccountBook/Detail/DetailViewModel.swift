//
//  DetailViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2023/01/10.
//

import Foundation
import Combine

final class DetailViewModel {
    
    init(accountBook: AccountBook) {
        self.accountBook = CurrentValueSubject(accountBook)
    }
    
    // Data -> Output
    let accountBook : CurrentValueSubject<AccountBook, Never>
}
