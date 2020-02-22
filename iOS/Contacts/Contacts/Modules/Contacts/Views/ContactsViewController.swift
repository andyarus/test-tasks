//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Andrei Coder on 18.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import UIKit
import RxSwift

class ContactsViewController: UIViewController {
  
  // MARK: - Public Properties
  
  public var viewModel: ContactsViewModel!
  
  // MARK: - Private Properties
  
  private var disposeBag = DisposeBag()
  private var contacts = [Contact]()
  
  // MARK: - Private View Properties
  
  private let tableView = UITableView()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  private func setup() {
    bindViewModel()
    addSubviews()
    setupUI()
  }
  
  private func bindViewModel() {
    viewModel.getContacts()
      .subscribe(onSuccess: { [unowned self] contacts in
        print("contacts:\(contacts.count) \(contacts[0])")
        
        self.contacts = contacts
        self.tableView.reloadData()
      }, onError: { error in
        print("Error getting contacts", error)
      })
      .disposed(by: disposeBag)
  }
  
  private func addSubviews() {
    view.addSubview(tableView)
  }
  
  private func setupUI() {
    setupTableView()
    setupConstraints()
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    let nibName = String(describing: ContactTableViewCell.self)
    tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupConstraints() {
    let tableViewConstraints: [NSLayoutConstraint] = [
      view.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0.0),
      view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0.0),
      view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0.0),
      view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0.0),
    ]
    
    NSLayoutConstraint.activate(
      tableViewConstraints
    )
  }
  
}

// MARK: - UITableViewDataSource

extension ContactsViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseIdentifier) as! ContactTableViewCell
    
    let contact = contacts[indexPath.row]
    cell.configure(for: contact)
    
    return cell
  }

}

// MARK: - UITableViewDelegate

extension ContactsViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }
  
}
