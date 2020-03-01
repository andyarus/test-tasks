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
  
  // MARK: - Coordinator
  
  weak var coordinator: MainCoordinator?
  
  // MARK: - Public Properties
  
  public var viewModel: ContactsViewModel!
  
  // MARK: - Private Properties
  
  private var disposeBag = DisposeBag()
  
  // MARK: - Private View Properties
  
  private var searchController: UISearchController!
  private let tableView = UITableView()
  private let refreshControl = UIRefreshControl()
  private let indicatorView = UIActivityIndicatorView()
  private lazy var errorView = ErrorView(parent: view)
  
  private lazy var rxSetupCompleted: Bool = setupRx()
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setupNavigationTitle()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    /// https://github.com/RxSwiftCommunity/RxDataSources/issues/331
    assert(rxSetupCompleted == true, "Rx setup failed")
  }
  
  // MARK: - Setup Methods
  
  private func setup() {
    addSubviews()
    setupUI()
    setupConstraints()
    
    /// Problem if setup on viewDidLoad
    /// https://github.com/RxSwiftCommunity/RxDataSources/issues/331
    //setupRx()
    //loadData()
  }
  
  private func setupRx() -> Bool {
    /// Get contacts
    refreshControl.rx.controlEvent(.valueChanged)
      .map { [unowned self] in
        self.refreshControl.isRefreshing
      }
      .bind(to: viewModel.getContacts)
      .disposed(by: disposeBag)

    /// Search contact
    searchController.searchBar.rx.text
      .orEmpty
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .bind(to: viewModel.getFilteredContacts)
      .disposed(by: disposeBag)
    
    /// Contacts processing
    viewModel.contacts
      .observeOn(MainScheduler.instance)
      .do(onNext: { [unowned self] _ in
        self.endRefreshing()
      })
      .bind(to: tableView.rx.items(cellIdentifier: ContactTableViewCell.reuseIdentifier,
                                   cellType: ContactTableViewCell.self)) { (row, element, cell) in
        cell.configure(for: element)
      }.disposed(by: disposeBag)

    /// Error processing
    viewModel.error
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] error in
        self.errorView.show()
        self.endRefreshing()
      }).disposed(by: disposeBag)
    
    /// Select processing
    tableView.rx.modelSelected(Contact.self)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] contact in
        self.coordinator?.openProfile(for: contact)
      }).disposed(by: disposeBag)
    
    loadData()
    
    return true
  }
  
  private func loadData() {
    indicatorView.startAnimating()
    viewModel.getContacts.onNext(true)
  }
  
  private func addSubviews() {
    view.addSubview(tableView)
    view.addSubview(indicatorView)
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    
    setupNavigationBar()
    
    setupSearchController()
    setupTableView()
    setupRefreshControl()
    setupIndicatorView()
  }
  
  private func setupNavigationBar() {
    /// Large title
    navigationController?.navigationBar.prefersLargeTitles = true
    
    /// TODO in iOS13 default tint bar color definition changed - find out way set like on test task screen
  }
  
  private func setupNavigationTitle() {
    navigationItem.title = "Contacts"
  }
  
  private func setupSearchController() {
    searchController = UISearchController(searchResultsController: nil)
    searchController.searchBar.placeholder = "Search"
    navigationItem.searchController = searchController
    
    definesPresentationContext = true
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
  }
  
  private func setupTableView() {
    let nibName = String(describing: ContactTableViewCell.self)
    tableView.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: ContactTableViewCell.reuseIdentifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
    
    tableView.refreshControl = refreshControl
  }
  
  private func setupRefreshControl() {
    refreshControl.tintColor = .orange
    refreshControl.backgroundColor = view.backgroundColor
  }
  
  private func setupIndicatorView() {
    indicatorView.style = .whiteLarge
    indicatorView.color = .orange
    indicatorView.center = view.center
    indicatorView.hidesWhenStopped = true
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
  
  private func endRefreshing() {
    indicatorView.stopAnimating()
    refreshControl.endRefreshing()
  }
  
}
