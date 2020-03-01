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
  
  override func viewWillDisappear(_ animated: Bool) {
    //searchController.dismiss(animated: false)
  }
  
  // MARK: - Setup Methods
  
  private func setup() {
    addSubviews()
    setupUI()
    setupConstraints()
    //setupRx()
    loadData()
  }
  
  private func loadData() {
    indicatorView.startAnimating()
    viewModel.getContacts.onNext(true)
  }
  
  private func setupRx() -> Bool {
    /// Get contacts
    refreshControl.rx.controlEvent(.valueChanged)
      .map { [unowned self] in
        self.refreshControl.isRefreshing
      }
      .bind(to: viewModel.getContacts)
      .disposed(by: disposeBag)
    
    /// Get contacts
//    refreshControl.rx.controlEvent(.valueChanged)
//      .subscribe(onNext: { [unowned self] in
//        guard self.refreshControl.isRefreshing else { return }
//        self.viewModel.getContacts()
//      }).disposed(by: disposeBag)

    /// Search contact
    searchController.searchBar.rx.text.orEmpty
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(onNext: { [unowned self] filter in
        self.viewModel.loadData(with: filter)
      })
      .disposed(by: disposeBag)

    viewWillAppear(true)
    
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
    
    return true
  }
  
  private func endRefreshing() {
    indicatorView.stopAnimating()
    refreshControl.endRefreshing()
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
    //navigationController?.navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.prefersLargeTitles = true
    
    /// Hide navigation bar bottom border
//    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//    navigationController?.navigationBar.shadowImage = UIImage()
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
    
//    definesPresentationContext = true
//    searchController.obscuresBackgroundDuringPresentation = false
//    searchController.dimsBackgroundDuringPresentation = true
    
    
    //navigationController?.navigationBar.isTranslucent = false
    //navigationController?.navigationBar.backgroundColor = .white
    
    //navigationController?.view.backgroundColor = .red
    
    //navigationController?.extendedLayoutIncludesOpaqueBars = true
    
    //navigationController?.navigationBar.isTranslucent = false
    
    
    
    
//    print("navigationController?.navigationBar.tintColor:\(navigationController?.navigationBar.barTintColor)")
//    print("navigationController?.navigationBar.barTintColor:\(navigationController?.navigationBar.barTintColor)")
//    print("navigationController?.navigationBar.backgroundColor:\(navigationController?.navigationBar.backgroundColor)")


    //navigationController?.navigationBar.backgroundColor = .blue
    
    
//    let tintColor = navigationController?.navigationBar.barTintColor
//    navigationController?.navigationBar.barTintColor = tintColor
//    navigationController?.navigationBar.backgroundColor = tintColor
    
    
    
    
    
//    let bottomBorder = UIView(frame: CGRect(x: 0,
//                                      y: navigationController!.navigationBar.frame.size.height - 1,
//                                      width: navigationController!.navigationBar.frame.size.width,
//                                      height: 1.0))
//    bottomBorder.backgroundColor = .lightGray
//    navigationController?.navigationBar.addSubview(bottomBorder)
    
    
    
    
    
//    /// Hack for hiding standard borders
//    searchController.searchBar.backgroundImage = UIImage()
//    /// Hack for adding bottom border
//    let bottomBorder = UIView(frame: CGRect(x: 0,
//                                      y: searchController.searchBar.frame.size.height - 1,
//                                      width: searchController.searchBar.frame.size.width,
//                                      height: 1.0))
//    bottomBorder.backgroundColor = .lightGray
//    searchController.searchBar.addSubview(bottomBorder)
    
    
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
  
}
