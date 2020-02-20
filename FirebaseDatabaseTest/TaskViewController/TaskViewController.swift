//
//  TableViewController.swift
//  FirebaseDatabaseTest
//
//  Created by Valeriy Kovalevskiy on 2/20/20.
//  Copyright © 2020 v.kovalevskiy. All rights reserved.
//

import UIKit
import Firebase

class TaskViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var user: CurrentUser!
    var ref: DatabaseReference!
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentUser = Auth.auth().currentUser else { return }
        
        user = CurrentUser(user: currentUser) // c помощью инициализатора получаем в структуру currentuser uid залогиненого юзера
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        ref.observe(.value, with: { [weak self] (snapshot) in // получаемая информация
          
            var _tasks = [Task]()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            self?.tasks = _tasks
            self?.tableView.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        ref.removeAllObservers()
    }
    
    @IBAction func didTappedAddBarButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "new task", message: "add new task", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "save", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            
            let task = Task(title: textField.text!, userId: (self?.user.uid)!)
            let taskRef = self?.ref.child(task.title.lowercased()) // cоздаем конкретную задачу
//            taskRef?.setValue(["title": task.title, "userId": task.userId, "completed": task.completed]) //помещаем словарь по ссылке , так же его можно переместить в структуру task
            
            taskRef?.setValue(task.convertToDictionary())
            //let task
            //task reference
            //
        }
        let cancel = UIAlertAction(title: "cancel", style: .default, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTappedSignOutBarButton(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        self.navigationController?.popViewController(animated: true)
    }
   
    
}

//MARK: - Extensions

extension TaskViewController: UITableViewDelegate {}

extension TaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let taskTitle = tasks[indexPath.row].title
        cell.textLabel?.text = taskTitle
        cell.textLabel?.textColor = .white

        return cell
    }
    
    
}

