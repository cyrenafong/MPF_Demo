//
//  SettingViewModel.swift
//  MPFManager
//
//  Created by Cyrena Fong on 16/11/2019.
//  Copyright © 2019 EE4304. All rights reserved.
//

import RealmSwift
import UIKit


class SettingViewModel: BaseViewModel {
    private var accounts: Results<MPFAccount>? =  nil
    
    func clear(_ controller: UIViewController) {
        let alert = UIAlertController(title: "Clear Accounts", message: "You are about to clear all accounts. Continue?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.database.write({
                let accounts = self.database.realm.objects(MPFAccount.self)
                self.database.realm.delete(accounts)
                self.passclear()
        
            })
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    func passclear() {
        Passcode.present(with: .deactive)
    }
    
}
