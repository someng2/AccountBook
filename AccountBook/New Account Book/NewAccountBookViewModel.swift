//
//  NewAccountBookViewModel.swift
//  AccountBook
//
//  Created by 백소망 on 2022/12/06.
//

import Foundation
import Combine

final class NewAccountBookViewModel {
    @Published var accountBook: AccountBook
    
    @Published var subcategory: String = ""
    @Published var contents: String = ""
    
    var subscriptions = Set<AnyCancellable>()
    
    init() {
        accountBook = AccountBook(category: "", subcategory: "", contents: "", price: 0, date: "")
        
        $subcategory.sink { subcategory in
            self.accountBook.subcategory = subcategory
        }.store(in: &subscriptions)
        
        $contents.sink { contents in
            self.accountBook.contents = contents
        }.store(in: &subscriptions)
    }
    
    
}
