//
//  ViewController.swift
//  01_SaveToCloud
//
//  Created by Tim Beals on 2018-01-14.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    let database = CKContainer.default().privateCloudDatabase
    
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var datasource: [CKRecord]? = nil {
        didSet {
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Title"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouched(sender:)))
        
        layoutSubviews()
        queryDatabase()
    }
    
    private func layoutSubviews() {
        tableView.removeFromSuperview()
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //MARK: Refresh Control
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshPulled(sender:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
    }
    
    //MARK: Add Button Touched
    @objc
    func addButtonTouched(sender: UIBarButtonItem) {
        print("VC: Add Button Touched")
        let alert = UIAlertController(title: "Create Note", message: "", preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "Enter here"
        }
        let cancel  = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Post", style: .default) { (action) in
            guard let tfText = alert.textFields?.first?.text else { return }
            self.saveToCloud(note: tfText)
        }
        alert.addAction(cancel)
        alert.addAction(post)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    func refreshPulled(sender: UIRefreshControl) {
        
        queryDatabase()
    }
    
    
    func saveToCloud(note: String) {
        
        let newNote = CKRecord(recordType: "Note")
        newNote.setValue(note, forKey: "content")
        
        database.save(newNote) { (record, _) in
            guard record != nil else { return }
            if let content = record!.object(forKey: "content") {
                print("Saved record: \(content)")
            }
        }
    }
    
    func queryDatabase() {
        let query = CKQuery(recordType: "Note", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else { return }
            let sortedRecords = records.sorted() { $0.creationDate! < $1.creationDate! }
            self.datasource = sortedRecords
            
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let record = datasource?[indexPath.row]
        guard let text = record?.value(forKey: "content") as? String else { return cell }
        cell.textLabel?.text = text
        return cell
    }
    
}

