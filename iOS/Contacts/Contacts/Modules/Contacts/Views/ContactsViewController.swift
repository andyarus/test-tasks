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

import Moya

class ContactsViewController: UIViewController {
  
  // MARK: - Public Properties
  
  public var viewModel: ContactsViewModel!
  
  // MARK: - Private Properties
  
  private var disposeBag = DisposeBag()
  
  // MARK: - Private View Properties
  
  private let contactsLabel: UILabel = {
    let label = UILabel()
    label.text = "Contacts"
    label.textAlignment = .left
    label.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private var searchController: UISearchController!
  private let tableView = UITableView()
  private let indicatorView = UIActivityIndicatorView()
  private lazy var errorView = ErrorView(parent: view)
  private lazy var searchView = SearchView(parent: view)
  
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
    //loadData()
  }
  
  private func loadData() {
    indicatorView.startAnimating()
    viewModel.loadData()
  }
  
  private let provider = MoyaProvider<Contacts>()
  
  private func bindViewModel() {
    searchController.searchBar.rx.text.orEmpty
    //searchView.searchBar.rx.text.orEmpty
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(onNext: { [unowned self] filter in
        self.viewModel.loadData(with: filter)
      })
      .disposed(by: disposeBag)
    
//    searchController.searchBar.rx.text.orEmpty
//      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
//      .distinctUntilChanged()
//      .subscribe(onNext: { [unowned self] filter in
//        self.viewModel.loadData(with: filter)
//      })
//      .disposed(by: disposeBag)
    
    tableView.refreshControl?.rx.controlEvent(.valueChanged)
      .map { self.tableView.refreshControl?.isRefreshing }
      .filter { $0 == true }
      .subscribe(onNext: { _ in
        self.errorView.hide()
        self.viewModel.loadData()
      }).disposed(by: disposeBag)
    
    
//    tableView.refreshControl?.rx.controlEvent(.valueChanged)
//      .map { self.tableView.refreshControl?.isRefreshing }
//      .filter { $0 == true }
//      .flatMap { _ -> Observable<[Contact]> in
//        return self.provider.rx.request(.contacts(page: 1))
//          .filterSuccessfulStatusCodes()
//          .map([Contact].self)
//          .asObservable()
//      }
//      .bind(to: tableView.rx.items(cellIdentifier: ContactTableViewCell.reuseIdentifier,
//                                   cellType: ContactTableViewCell.self)) { (row, element, cell) in
//        cell.configure(for: element)
//      }.disposed(by: disposeBag)
    
    
//    viewModel.contactsObservable!
//      .observeOn(MainScheduler.instance)
//      .do(onNext: { [unowned self] c in
//        print()
//        print("onNext contactsObservable :\(c.count)")
//        self.endRefreshing()
//      })
//      .bind(to: tableView.rx.items(cellIdentifier: ContactTableViewCell.reuseIdentifier,
//                                   cellType: ContactTableViewCell.self)) { (row, element, cell) in
//        cell.configure(for: element)
//      }.disposed(by: disposeBag)
    
    
    
    
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
    
    tableView.rx.itemSelected
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] indexPath in
        
        DispatchQueue.main.async {

        guard let contact = self.viewModel.contact(at: indexPath.row) else { return }
        let vc = ProfileViewController(contact: contact)
        self.navigationController?.pushViewController(vc, animated: true)
          
        }
        
      }).disposed(by: disposeBag)
    
//    tableView.rx.modelSelected(Contact.self)
//      .observeOn(MainScheduler.instance)
//      .subscribe(onNext: { [unowned self] model in
//        print("model:\(model)")
//      }).disposed(by: disposeBag)
    
  }
  
  private func endRefreshing() {
    indicatorView.stopAnimating()
    tableView.refreshControl?.endRefreshing()
  }
  
  private func addSubviews() {
    view.addSubview(contactsLabel)
    view.addSubview(tableView)
    view.addSubview(indicatorView)
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    
    navigationItem.title = "Contacts"
    navigationController?.navigationBar.prefersLargeTitles = true
    
    /// Hide navigation bar bottom border
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    
    setupSearchController()
    setupTableView()
    setupIndicatorView()
  }
  
  private func setupSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    //searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search"
    
    searchController.dimsBackgroundDuringPresentation = false
    
    /// Hack for hiding standard borders
    searchController.searchBar.backgroundImage = UIImage()
    /// Hack for adding bottom border
    let bottomBorder = UIView(frame: CGRect(x: 0,
                                      y: searchController.searchBar.frame.size.height - 1,
                                      width: searchController.searchBar.frame.size.width,
                                      height: 1.0))
    bottomBorder.backgroundColor = .lightGray
    searchController.searchBar.addSubview(bottomBorder)
    
    
//    searchController.searchBar.rx.text.orEmpty
//      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
//      .distinctUntilChanged()
//      .subscribe(onNext: { [unowned self] filter in
//        self.viewModel.loadData(with: filter)
//      })
//      .disposed(by: disposeBag)
    
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
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.tintColor = .orange
    tableView.refreshControl?.backgroundColor = view.backgroundColor
    
    tableView.tableHeaderView = searchController.searchBar
  }
  
  private func setupIndicatorView() {
    indicatorView.style = .whiteLarge
    indicatorView.color = .orange
    indicatorView.center = view.center
    indicatorView.hidesWhenStopped = true
  }
  
  private func setupConstraints() {
    
    let contactsLabelConstraints: [NSLayoutConstraint] = [
      contactsLabel.heightAnchor.constraint(equalToConstant: 40),
      view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: contactsLabel.topAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: contactsLabel.leadingAnchor, constant: -10.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: contactsLabel.trailingAnchor, constant: 10.0),
    ]
    
    let tableViewConstraints: [NSLayoutConstraint] = [
      contactsLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0.0),
      //view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: tableView.leadingAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20.0)
    ]
    
    NSLayoutConstraint.activate(
      contactsLabelConstraints +
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
