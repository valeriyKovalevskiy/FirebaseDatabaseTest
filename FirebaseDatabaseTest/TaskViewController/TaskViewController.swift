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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func didTappedAddBarButton(_ sender: UIBarButtonItem) {
        
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = "cell # \(indexPath.row)"
        cell.textLabel?.textColor = .white
        return cell
    }
    
    
}

