//
//  ViewController.swift
//  Learning Realm
//
//  Created by Francisco De Freitas on 31/12/20.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var realm: Realm?
    var items: Results<Person>?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        tableView.delegate = self
        tableView.dataSource = self
        
        do {
            realm = try Realm()
            print(Realm.Configuration.defaultConfiguration.fileURL!)
        } catch {
            print("Error al conectar")
        }
        
        fetchData()
        
    }
    
    private func fetchData() {
        
        items = realm!.objects(Person.self)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    @IBAction func buttonAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Agregar", message: "Escribe algo", preferredStyle: .alert)
        
        alert.addTextField()
        
        let submit = UIAlertAction(title: "Grabar", style: .default) { (action) in
            
            let textField = alert.textFields![0]
            
            let newPerson = Person()
            newPerson.name = textField.text!
            newPerson.age = 20
            
            do {
                try self.realm!.write {
                    self.realm!.add(newPerson)
                }
            } catch {
                print("Error al ingresar usuario")
            }
            
            self.fetchData()
            
        }
        
        alert.addAction(submit)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

// MARK:- UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Agregar", message: "Escribe algo", preferredStyle: .alert)
        
        alert.addTextField()
        
        let person = items?[indexPath.row]
        let textField = alert.textFields![0]
        textField.text = person?.name
        
        let submit = UIAlertAction(title: "Grabar", style: .default) { (action) in
            
            do {
                try self.realm!.write {
                    person?.name = textField.text!
                }
            } catch {
                print("Error al ingresar usuario")
            }
            
            self.fetchData()
            
        }
        
        alert.addAction(submit)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Borrar") { (action, view, completion) in
            
            let person = self.items?[indexPath.row]
            
            do {
                try self.realm!.write {
                    self.realm!.delete(person!)
                }
            } catch {
                print("Error al ingresar usuario")
            }
            
            self.fetchData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

// MARK:- UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let person = items?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "viewCell", for: indexPath)
        cell.textLabel?.text = person?.name
        
        return cell
    }
    
    
}

