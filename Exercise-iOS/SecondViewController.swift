//
//  SecondViewController.swift
//  Exercise-iOS
//
//  Created by Viktor Glaes on 9/16/20.
//  Copyright © 2020 Viktor Glaes. All rights reserved.
//
import RealmSwift
import UIKit

class ExerciseItem: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var comment: String = ""
    @objc dynamic var date: Date = Date()
}

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    
    private var data = [ExerciseItem]()
    private let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = realm.objects(ExerciseItem.self).map({ $0 })
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for:indexPath)
        cell.textLabel?.text = data[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = data[indexPath.row]
        
        guard let vc = storyboard?.instantiateViewController(identifier: "edit") as? EditViewController else {
            return
        }
        
        vc.item = item
        vc.deletionHandler = {[weak self] in
            self?.refresh()
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = item.title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapAddButton() {
        guard let vc = storyboard?.instantiateViewController(identifier: "enter") as? EntryViewController else {
            return
        }
        vc.completionHandler = { [weak self] in
            self?.refresh()
        }
        vc.title = "New Exercise"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refresh() {
        data = realm.objects(ExerciseItem.self).map({ $0 })
        table.reloadData()
    }
}

