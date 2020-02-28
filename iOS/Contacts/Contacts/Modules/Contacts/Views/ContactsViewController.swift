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
  
  
  private let errorSubject = PublishSubject<Error>()
  
  
  var startTime: CFAbsoluteTime = 0.0
  
  private func bindViewModel() {
    
    
    
    
    let page1 = self.provider.rx.request(.contacts(page: 1))
      .filterSuccessfulStatusCodes()
      .map([Contact].self)
      .asObservable()
      //.materialize()
    
    let page2 = self.provider.rx.request(.contacts(page: 2))
      .filterSuccessfulStatusCodes()
      .map([Contact].self)
      .asObservable()
      //.materialize()
    
    let page3 = self.provider.rx.request(.contacts(page: 3))
      .filterSuccessfulStatusCodes()
      .map([Contact].self)
      .asObservable()
//      .subscribe(onSuccess: { contacts in
//        print("type(of: contacts:\(type(of: contacts))")
//        print("page3 contacts.count", contacts.count)
//      }, onError: { error in
//        print("page3 error", error)
//      })
    
    //let zipped =  Observable.zip(page1, page2) { $0 + $1 }
    //let zip = Observable.zip(page1, page2, page3)
    
    //let merge = Observable.merge(page1, page2, page3).compactMap { $0 }
    
    
    
    
    //let concat = Observable.zip(page1, page2, page3).reduce([], accumulator: +)
    //let concat = Observable.zip(page1, page2, page3){ $0 + $1 + $2 }
    
    
    //let concat = Observable.combineLatest(page1, page2, page3).reduce([], accumulator: +)
    
    let concat = Observable.merge([page1, page2, page3]).reduce([], accumulator: +)
    //let concat = Observable.merge(page1, page2, page3).reduce([], accumulator: +)
    
    
    //let concat = Observable.concat([page1, page2, page3]).reduce([], accumulator: +)
    //let concat = Observable.concat(page1, page2, page3).reduce([], accumulator: +)
    
//    let concat = Observable.concat([page1, page2, page3]).reduce([], accumulator: { (a, b) -> [Contact] in
//
//      print("type(of: a:\(type(of: a)) a.count:\(a.count)")
//      print("type(of: b:\(type(of: b)) b.count:\(b.count)")
//
//      return a + b
//    })
      //    let numberSum = numbers.reduce(0, { x, y in
      //        x + y
      //    })
      
      
      //let from = Observable.concat(page1, page2, page3).reduce([], accumulator: +)
      //let from = Observable.concat(page1, page2, page3).scan([], accumulator: +)
      //let from = Observable.concat(page1, page2, page3)//.flatMap { $0 }
      //let from = Observable.from(page1, page2, page3).flatMap { $0 }
      //let from = Observable.from([page1, page2, page3]).flatMap { $0 }
      
      //    let zip5 = Observable.zip(page1, page2, page3).map { c -> Contact in
      //      return c
      //    }
      //    let zip1 = Observable.zip([page1, page2, page3]).flatMap { c -> [Contact] in
      //
      //       }
      //let amb = Observable.amb([page1, page2, page3])
      
      //zip.enumerated()
      //    let res = [Contact]()
      //    for (i, element) in zip.enumerated() {
      //      //print("element \(element.count) at position \(i)")
      //      //res.append(element)
      //    }
      
      
      //let zipped1 = zip.scan([], accumulator: +)
      
      //    let zipped1 = Observable.combineLatest(page1, page2, page3).scan(0, accumulator:  { result, element in
      //      return result + [element]
      //    })
      
      //    let zip3 = Observable.zip(page1, page2, page3)
      //      .scan([], accumulator: +)
      
      
      
      //    let zipped = zip.map { (c1, c2, c3) -> [Contact] in
      //    //let zipped =  Observable.zip(page1, page2, page3, resultSelector: { (c1, c2, c3) -> [Contact] in
      //      //print(type(of: $0)
      //
      //
      //      //print("type(of: zip3:\(type(of: zip3))")
      //      //print("type(of: zip1:\(type(of: zip1))")
      //      //print("type(of: amb:\(type(of: amb))")
      //      //print("type(of: merge:\(type(of: merge))")
      //      print("type(of: zip:\(type(of: zip))")
      //      print("type(of: page1:\(type(of: page1))")
      //      print("type(of: c1:\(type(of: c1))")
      //
      //      let result = c1 + c2 + c3
      //
      //      print("type(of: result:\(type(of: result))")
      //
      //      return result
      //
      //      //return $0 + $1 + $2
      //    }
      //    //)
      
      
      //let zipped =  Observable.zip(page1, page2, page3).reduce(0, accumulator: +)
      //let zipped =  Observable.zip(page1, page2, page3) { $0 + $1 + $2 }
      
      tableView.refreshControl?.rx.controlEvent(.valueChanged)
      //.map { self.tableView.refreshControl?.isRefreshing }
      //.filter { $0 == true }
      
//      .flatMap { _ -> Observable<[Contact]> in
//        return self.provider.rx.request(.contacts(page: 1))
//          .filterSuccessfulStatusCodes()
//          .map([Contact].self)
//          .asObservable()
//          //.retry(3)
//      }
      
      //.observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
      .do(onNext: {
        
        self.startTime = CFAbsoluteTimeGetCurrent()
        
        
      })
      //.flatMap{ _ -> Observable<Event<[[Contact]]>> in
      .flatMap{ _ -> Observable<Event<[Contact]>> in
        //print("zipped:\(type(of: zipped))")
        
        print("type(of: concat:\(type(of: concat))")
        
        //return zip1.materialize()
        //return amb.materialize()
        //return merge.materialize()
        //return zipped.materialize()
        return concat.materialize()
        
        
    }
      //.flatMap { _ in
      //.flatMap { _ -> Observable<Event<[Contact]>> in
      //.flatMap { _ -> Observable<[Contact]> in
        
        //return zipped.materialize()
        
        
        
        
//        let page1 = self.provider.rx.request(.contacts(page: 1))
//          .filterSuccessfulStatusCodes()
//          .map([Contact].self)
//          .asObservable()
//          //.materialize()
//
//        let page2 = self.provider.rx.request(.contacts(page: 2))
//          .filterSuccessfulStatusCodes()
//          .map([Contact].self)
//          .asObservable()
//          //.materialize()
//
//        let page3 = self.provider.rx.request(.contacts(page: 4))
//          .filterSuccessfulStatusCodes()
//          .map([Contact].self)
//          .asObservable()
//          //.retry(3)
//          //.catchErrorJustReturn([])
//          //.materialize()
        
        
        
        
        
        //return Observable.from([page1, page2, page3]).merge()
        
        //return Observable.combineLatest(page1, page2, page3) { return $0 + $1 + $2 }
          //.observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
 
        //return Observable.zip(page1, page2, page3, resultSelector: { $0 + $1 + $2 })
        //return Observable.zip(page1, page2, page3) { $0 + $1 + $2 }
        
        //return Observable.merge([page1, page2, page3])
        //return Observable.concat([page1, page2, page3])
        
        //return page1.amb(page2).amb(page3)

        

        //return page3
        
        //return Observable.zip(page1, page2, page3).materialize()
        
        
        
//        return Observable.combineLatest(page1, page2, page3) {
////          print("$0.count", $0.count)
////          print("$1.count", $1.count)
////          print("$2.count", $2.count)
//
//          return $0 + $1 + $2
//        }
        
        
        

        
        
        
        
        
        
        
        
//        https://medium.com/swift-india/rxswift-combining-operators-combinelatest-zip-and-withlatestfrom-521d2eca5460
//        let sourceObservableA = Observable
//            .zip(Observable.of("🔴", "🔵", "🔺"), intervalObservable,
//                 resultSelector: { value1, _ in
//            return value1
//        })

        
//        return provider
//        .rx
//        .request(MultiTarget.target(target))
//        .flatMap { response -> Single<User> in
//            if let responseType = try? response.map(User.self) {
//                return Single.just(responseType)
//            } else if let errorType = try? response.map(UserError.self) {
//                return Single.error(errorType.error)
//            } else {
//                fatalError("⛔️ We don't know how to parse that!")
//            }
//         }
        
        
        
//        return Single.create { [unowned self] single in
//          self.provider.rx.request(ApiCameraProvider.cameras(activeUser: activeUser, ids: ids))
//            .filterSuccessfulStatusCodes()
//            .map(CameraJson.self)
//            .catchError { error in
//              single(.error(error))
//              throw error
//            }.subscribe(onSuccess: { cameras in
//              single(.success(cameras))
//            }).disposed(by: self.disposeBag)
//          return Disposables.create()
//        }
        
        
        
      //}
      
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
        
        //.materialize()
        
        .subscribe(onNext: { event in
          //print("event", event)
          //print("event event.count:", event.count)
          
          
          
          switch event {
          case let .next(contacts):
            let contactsUnique = Set(contacts)
            print("next contacts.count:", contacts.count, "contactsUnique:", contactsUnique.count)
            
            
//            print("next contacts1.count:", contacts.0.count)
//            print("next contacts2.count:", contacts.1.count)
//            print("next contacts3.count:", contacts.2.count)
          case let .error(error):
            print("error", error)
            self.errorSubject.onNext(error)
          case .completed:
            print("completed")
          }
          
          
          
          

          let diff = CFAbsoluteTimeGetCurrent() - self.startTime
          print("Took \(diff) seconds")
          
          
          
          self.endRefreshing()
        }, onError: { error in
          print("error:", error)
          self.endRefreshing()
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
