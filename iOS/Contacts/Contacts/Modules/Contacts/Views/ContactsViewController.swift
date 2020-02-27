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
  private let indicatorView = UIActivityIndicatorView()
  private lazy var errorView = ErrorView(parent: view)
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setupNavigationTitle()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    //searchController.dismiss(animated: false)
  }
  
  // MARK: - Setup Methods
  
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
    //viewModel.loadData()
  }
  
  private let provider = MoyaProvider<Contacts>()
  //private let provider = MoyaProvider<Contacts>(plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))])
  //private let provider = MoyaProvider<Contacts>(plugins: [NetworkLoggerPlugin()])
  
  private func bindViewModel() {
    
    
    
    tableView.refreshControl?.rx.controlEvent(.valueChanged)
      .map { self.tableView.refreshControl?.isRefreshing }
      .filter { $0 == true }
      
//      .flatMap { _ -> Observable<[Contact]> in
//        return self.provider.rx.request(.contacts(page: 1))
//          .filterSuccessfulStatusCodes()
//          .map([Contact].self)
//          .asObservable()
//          //.retry(3)
//      }
      
      //.observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
      .flatMap { _ -> Observable<[Contact]> in
        let page1 = self.provider.rx.request(.contacts(page: 1))
          .filterSuccessfulStatusCodes()
          .map([Contact].self)
          .asObservable()
        let page2 = self.provider.rx.request(.contacts(page: 2))
          .filterSuccessfulStatusCodes()
          .map([Contact].self)
          .asObservable()
        let page3 = self.provider.rx.request(.contacts(page: 4))
          .filterSuccessfulStatusCodes()
          .map([Contact].self)
          .asObservable()
          .retry(3)
          .catchErrorJustReturn([])
        
        //return Observable.from([page1, page2, page3]).merge()
        
        //return Observable.combineLatest(page1, page2, page3) { return $0 + $1 + $2 }
          //.observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
 
        //return Observable.zip(page1, page2, page3, resultSelector: { $0 + $1 + $2 })
        //return Observable.zip(page1, page2, page3) { $0 + $1 + $2 }
        
        //return Observable.merge([page1, page2, page3])
        //return Observable.concat([page1, page2, page3])
        
        //return page1.amb(page2).amb(page3)
        
        return Observable.combineLatest(page1, page2, page3) {
          print("$0.count", $0.count)
          print("$1.count", $1.count)
          print("$2.count", $2.count)
          
          return $0 + $1 + $2
        }
        
      }
      
//    .flatMap { test -> Observable<[Contact]> in
//      print("test.count", test.count)
//      return Observable.just(test)
//    }
      
//      .flatMap { [unowned self] _ in
//        return self.provider.rx.request(.contacts(page: 6))
//          .filterSuccessfulStatusCodes()
//          .map([Contact].self)
//          .asObservable()
//          .materialize()
//
////        return self.provider.rx.request(.contacts(page: 1))
////          .filterSuccessfulStatusCodes()
////          .map([Contact].self)
////          .asObservable()
//
//        }
      
        //.observeOn(MainScheduler.instance)
        //.subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { event in
          print("event event.count:", event.count)
          self.endRefreshing()
        }, onError: { error in
          print("error:", error)
        }, onCompleted: {
          print("completed")
        })
      
      
//      .catchError { error in
//        print("error wtf:\(error)")
//        return Observable<[Contact]>.empty()
//      }
      //.catchErrorJustReturn([])
//      .bind(to: tableView.rx.items(cellIdentifier: ContactTableViewCell.reuseIdentifier,
//                                   cellType: ContactTableViewCell.self)) { (row, element, cell) in
//        cell.configure(for: element)
//      }
      
      .disposed(by: disposeBag)
    
    
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
    
    
    
    
    
    
    
    searchController.searchBar.rx.text.orEmpty
      .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .subscribe(onNext: { [unowned self] filter in
        self.viewModel.loadData(with: filter)
      })
      .disposed(by: disposeBag)
    
//    tableView.refreshControl?.rx.controlEvent(.valueChanged)
//      .map { self.tableView.refreshControl?.isRefreshing }
//      .filter { $0 == true }
//      .subscribe(onNext: { _ in
//        self.errorView.hide()
//        self.viewModel.loadData()
//      }).disposed(by: disposeBag)
    
    
    
    
    
    
    
//    viewModel.contacts
//      .observeOn(MainScheduler.instance)
//      .do(onNext: { [unowned self] _ in
//        self.endRefreshing()
//      })
//      .bind(to: tableView.rx.items(cellIdentifier: ContactTableViewCell.reuseIdentifier,
//                                   cellType: ContactTableViewCell.self)) { (row, element, cell) in
//        cell.configure(for: element)
//      }.disposed(by: disposeBag)
//
//    viewModel.error
//      .observeOn(MainScheduler.instance)
//      .subscribe(onNext: { [unowned self] error in
//        self.errorView.show()
//        self.endRefreshing()
//      }).disposed(by: disposeBag)
    
    tableView.rx.itemSelected
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { [unowned self] indexPath in
        
        DispatchQueue.main.async {

          guard let contact = self.viewModel.contact(at: indexPath.row) else { return }
        //let vc = ProfileViewController(contact: contact)
        //self.navigationController?.pushViewController(vc, animated: true)
          self.coordinator?.openProfile(for: contact)
          
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
    view.addSubview(tableView)
    view.addSubview(indicatorView)
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    
    setupNavigationBar()
    
    setupSearchController()
    setupTableView()
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
    
    tableView.refreshControl = UIRefreshControl()
    tableView.refreshControl?.tintColor = .orange
    tableView.refreshControl?.backgroundColor = view.backgroundColor
    
    //tableView.tableHeaderView = searchController.searchBar
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
