//
//  User.swift
//  FirebaseDatabaseTest
//
//  Created by Valeriy Kovalevskiy on 2/21/20.
//  Copyright © 2020 v.kovalevskiy. All rights reserved.
//

import Foundation
import Firebase

struct CurrentUser {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
