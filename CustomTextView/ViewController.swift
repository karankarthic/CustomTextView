//
//  ViewController.swift
//  CustomTextView
//
//  Created by Karan Karthic on 18/08/20.
//  Copyright © 2020 Karan Karthic. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextViewDelegate {
    
    var tableView = UITableView()

    lazy var textView:CustomTextView = {
        var textView = CustomTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        return textView
    }()
    
    var tags = ["karankarthic@gmail.com","abcd@gmail.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.addSubview(textView)
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
//        textView.delegate = self
        
        NSLayoutConstraint.activate([textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                                     textView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 10),
                                     textView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -10),
                                     textView.heightAnchor.constraint(equalToConstant: 50),
        
                                     tableView.topAnchor.constraint(equalTo: textView.bottomAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)])
        
        
    }


}

extension ViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = tags[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let nsRange = textView.selectedRange
        self.textView.addUser(model: tags[indexPath.row], selectedRange: nsRange, themeColor: UIColor.blue)
    }
    
}
