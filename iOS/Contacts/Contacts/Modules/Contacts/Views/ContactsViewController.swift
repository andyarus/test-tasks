//
//  ContactsViewController.swift
//  Contacts
//
//  Created by Andrei Coder on 18.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContactsViewController: UIViewController {
  
  // MARK: - Public Properties
  
  public var viewModel: ContactsViewModel!
  
  // MARK: - Private Properties
  
  private var disposeBag = DisposeBag()
  
  // MARK: - Private View Properties
  
  private let tableView = UITableView()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  private func setup() {
    //bindViewModel()
    addSubviews()
    setupUI()
    
    bindViewModel()
    loadData()
  }
  
  private func loadData() {
    viewModel.loadData()
  }
  
  private func bindViewModel() {
//    viewModel.getContacts()
//      .subscribe(onSuccess: { [unowned self] contacts in
//        //self.tableView.reloadData()
//      }, onError: { error in
//        print("Error getting contacts", error)
//      }).disposed(by: disposeBag)
    
    /// Temporarily
//    tableView.delegate = nil
//    tableView.dataSource = nil
    
    viewModel.contactsSubject
      .bind(to: tableView.rx.items(cellIdentifier: ContactTableViewCell.reuseIdentifier,
                                   cellType: ContactTableViewCell.self)) { (row, element, cell) in
        cell.configure(for: element)
      }.disposed(by: disposeBag)
  }
  
  private func addSubviews() {
    view.addSubview(tableView)
  }
  
  private func setupUI() {
    setupSearchController()
    setupTableView()
    setupConstraints()
  }
  
  private func setupSearchController() {
    let searchController = UISearchController(searchResultsController: nil)
    //searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search"
    navigationItem.searchController = searchController
    
    searchController.searchBar.rx.text.orEmpty
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(onNext: { [unowned self] filter in
        self.viewModel.loadData(with: filter)
      })
      .disposed(by: disposeBag)
    
//    let searchResults = searchController.searchBar.rx.text.orEmpty
//      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
//      .distinctUntilChanged()
//      .flatMapLatest { query -> Observable<[Contact]> in
//        print(query)
//        if query.isEmpty {
//          return .just([])
//        }
//        return self.viewModel.getContacts(with: query)
//          .catchErrorJustReturn([])
//      }
//      .observeOn(MainScheduler.instance)
//
//    print("searchResults:\(searchResults)")
    
//    tableView.delegate = nil
//    tableView.dataSource = nil

//    searchResults
//      .bind(to: tableView.rx.items(cellIdentifier: ContactTableViewCell.reuseIdentifier,
//                                   cellType: ContactTableViewCell.self)) { (row, element, cell) in
//        cell.configure(for: element)
//      }
//      .disposed(by: disposeBag)
  }
  
  private func setupTableView() {
    //tableView.delegate = self
    //tableView.dataSource = self
    let nibName = String(describing: ContactTableViewCell.self)
    tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupConstraints() {
    let tableViewConstraints: [NSLayoutConstraint] = [
      view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 0.0)
    ]
    
    NSLayoutConstraint.activate(
      tableViewConstraints
    )
  }
  
}

// MARK: - UITableViewDataSource

//extension ContactsViewController: UITableViewDataSource {
//  
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    if !viewModel.matchingСontacts.isEmpty {
//      return viewModel.matchingСontacts.count
//    } else {
//      return viewModel.contacts.count
//    }
//  }
//  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.reuseIdentifier) as! ContactTableViewCell
//    
//    let contact = viewModel.matchingСontacts.isEmpty ? viewModel.contacts[indexPath.row] : viewModel.matchingСontacts[indexPath.row]
//    //let contact = viewModel.contacts[indexPath.row]
//    cell.configure(for: contact)
//    
//    return cell
//  }
//  
//}
//
//// MARK: - UITableViewDelegate
//
//extension ContactsViewController: UITableViewDelegate {
//  
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    let contact = viewModel.contacts[indexPath.row]
//    let vc = ProfileViewController(contact: contact)
//    navigationController?.pushViewController(vc, animated: true)
//  }
//  
//}
