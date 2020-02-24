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
  private let indicatorView = UIActivityIndicatorView()
  private lazy var errorView = ErrorView(parent: view)
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  private func setup() {
    //bindViewModel()
    addSubviews()
    setupUI()
    setupConstraints()
    
    bindViewModel()
    loadData()
  }
  
  private func loadData() {
    indicatorView.startAnimating()
    viewModel.loadData()
  }
  
  private func bindViewModel() {
    tableView.refreshControl?.rx.controlEvent(.valueChanged)
      .map { self.tableView.refreshControl?.isRefreshing }
      .filter { $0 == true }
      .subscribe(onNext: { _ in
        self.errorView.hide()
        self.viewModel.loadData()
      }).disposed(by: disposeBag)
    
    viewModel.contacts
      .observeOn(MainScheduler.instance)
      .do(onNext: { [unowned self] _ in
        self.endRefreshing()
      })
      .bind(to: tableView.rx.items(cellIdentifier: ContactTableViewCell.reuseIdentifier,
                                   cellType: ContactTableViewCell.self)) { (row, element, cell) in
        cell.configure(for: element)
      }.disposed(by: disposeBag)
    
    viewModel.error
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] error in
        self.errorView.show()
        self.endRefreshing()
      }).disposed(by: disposeBag)
  }
  
  private func endRefreshing() {
    indicatorView.stopAnimating()
    tableView.refreshControl?.endRefreshing()
  }
  
  private func addSubviews() {
    view.addSubview(tableView)
    view.addSubview(indicatorView)
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    navigationItem.title = "Contacts"
    
    setupSearchController()
    setupTableView()
    setupIndicatorView()
  }
  
  private func setupSearchController() {
    let searchController = UISearchController(searchResultsController: nil)
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
    let nibName = String(describing: ContactTableViewCell.self)
    tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.tintColor = .orange
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
  }
  
  private func setupIndicatorView() {
    indicatorView.style = .whiteLarge
    indicatorView.color = .orange
    indicatorView.center = view.center
    indicatorView.hidesWhenStopped = true
  }
  
//  @objc
//  func refreshWeatherData(_ sender: Any) {
//    print("refreshWeatherData")
//    //viewModel.loadData()
//  }
  
  private func setupConstraints() {
    let tableViewConstraints: [NSLayoutConstraint] = [
      view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20.0)
    ]
    
    let indicatorViewConstraints: [NSLayoutConstraint] = [
      //indicatorView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor, constant: 0.0),
      //indicatorView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: 0.0)
    ]
    
    NSLayoutConstraint.activate(
      tableViewConstraints +
      indicatorViewConstraints
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
