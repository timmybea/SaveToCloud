//
//  ViewController.swift
//  01_SaveToCloud
//
//  Created by Tim Beals on 2018-01-14.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var datasource = ["Hello", "world"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "Title"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTouched(sender:)))
        
        layoutSubviews()
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
        
    }

    
    //MARK: Add Button Touched
    @objc
    func addButtonTouched(sender: UIBarButtonItem) {
        print("VC: Add Button Touched")
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = datasource[indexPath.row]
        return cell
    }
    
}

