//
//  ChartViewModel.swift
//  MPFManager
//
//  Created by Cyrena Fong on 13/11/2019.
//  Copyright © 2019 EE4304. All rights reserved.
//

import RealmSwift
import UIKit


class ChartViewModel: BaseViewModel {
    private var accounts: Results<MPFAccount>? =  nil
    var name: [String] = []
    var value: [Double] = []
    
    func initial() {
        accounts = database.realm.objects(MPFAccount.self)
        
        for item in accounts! {
            name.append(item.employer)
            value.append(item.totalValue)
        }
    }
}
