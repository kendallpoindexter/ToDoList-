//
//  UserDefaultsPersistanceManager.swift
//  ToDoList
//
//  Created by Kendall Poindexter on 3/18/21.
//

import Foundation

protocol ToDoItemService {
    func save(toDoItem: String, completion: (Result<[String], Error>) -> ())
    func delete(toDoItem: String, completion: (Result<[String], Error>) -> ())
    func fetchAll(completion: (Result<[String], Error>) -> ())
}



struct UserDefaultsPersistanceManager: ToDoItemService {
    let defaults = UserDefaults.standard
    private let key = "savedToDoItems"
    
    func fetchAll(completion: (Result<[String], Error>) -> ()) {
        guard let savedItems = defaults.array(forKey: key) as? [String] else {
            completion(.success([]))
            return
        }
        completion(.success(savedItems))
    }
    
    func save(toDoItem: String, completion: (Result<[String], Error>) -> ()) {
        fetchAll { result in
            switch result {
            case var .success(toDoItems):
                toDoItems.append(toDoItem)
                defaults.setValue(toDoItems, forKey: key)
                completion(.success(toDoItems))

            case .failure(_):
                break
                
            }
        }
    }
    
    func delete(toDoItem: String, completion: (Result<[String], Error>) -> ()) {
        fetchAll { result in
            switch result {
            
            case var .success(toDoItems):
                toDoItems.removeAll { $0 == toDoItem }
                defaults.setValue(toDoItems, forKey: key)
                completion(.success(toDoItems))

            case .failure(_):
                break
            }
        }
    }
}

