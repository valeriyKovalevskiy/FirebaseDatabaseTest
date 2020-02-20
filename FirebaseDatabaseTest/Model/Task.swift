//
//  Task.swift
//  FirebaseDatabaseTest
//
//  Created by Valeriy Kovalevskiy on 2/21/20.
//  Copyright © 2020 v.kovalevskiy. All rights reserved.
//

import Foundation
import Firebase

struct Task {
    let title: String
    let userId: String
    let ref: DatabaseReference?
    var completed: Bool = false //по умолчанию задача не выполнена
    
    init(title: String, userId: String) { //создаем объект локально
        self.title = title
        self.userId = userId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userId = snapshotValue["userId"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["title": title, "userId": userId, "completed": completed] //помещаем словарь по ссылке , так же его можно переместить в структуру task

    }
}
