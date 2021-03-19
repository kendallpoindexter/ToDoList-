//
//  ViewController.swift
//  ToDoList
//
//  Created by Kendall Poindexter on 3/17/21.
//

import UIKit

class HomeTableViewController: UIViewController {
    @IBOutlet weak var homeTableView: UITableView!
    
    private var toDoItemService: ToDoItemService!
    private var toDoItems: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.dataSource = self
        toDoItemService = UserDefaultsPersistanceManager()
        toDoItemService.fetchAll { result in
            switch result {
            
            case let .success(savedData):
                self.toDoItems = savedData
                DispatchQueue.main.async {
                    self.homeTableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }

    @IBAction func didTapAddButton(_ sender: UIBarButtonItem) {
        presentAddToDoItem()
    }
    
    private func presentAddToDoItem() {
        let ac = UIAlertController(title: "Enter ToDo", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) {[weak self] action in
            
            if let text = ac.textFields?[0].text, !text.isEmpty {
                self?.addToDoItem(with: text)
            }
        }
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }
    
    private func addToDoItem(with toDoString: String) {
        toDoItemService.save(toDoItem: toDoString) { result in
            switch result {
            case let .success(savedItems):
                toDoItems = savedItems
                DispatchQueue.main.async {
                    self.homeTableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
    
    private func removeToDoItem(at indexPath: IndexPath) {
        toDoItemService.delete(toDoItem: toDoItems[indexPath.row]) { result in
            switch result {
            
            case let .success(savedItems):
                toDoItems = savedItems
                DispatchQueue.main.async {
                    self.homeTableView.reloadData()
                }
            case .failure(_):
                break
            }
        }
    }
}

extension HomeTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDoCell", for: indexPath)
        cell.textLabel?.text = toDoItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            removeToDoItem(at: indexPath)
        }
    }
}





