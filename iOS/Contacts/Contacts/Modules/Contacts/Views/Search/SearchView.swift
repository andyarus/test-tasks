//
//  SearchView.swift
//  Contacts
//
//  Created by Andrei Coder on 26.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import UIKit

class SearchView: UIView {

  // MARK: - Private View Properties
  
  private let contactsLabel: UILabel = {
    let label = UILabel()
    label.text = "Contacts"
    label.textAlignment = .left
    label.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
//  private let bottomBorderView: UIView = {
//    let view = UIView()
//    view.backgroundColor = .lightGray
//    view.translatesAutoresizingMaskIntoConstraints = false
//    return view
//  }()
  
  // MARK: - Public View Properties
  
//  public let searchBar: UISearchBar = {
//    let searchBar = UISearchBar()
//    searchBar.placeholder = "Search"
//    searchBar.backgroundImage = UIImage() /// Hide borders
//    searchBar.translatesAutoresizingMaskIntoConstraints = false
//    return searchBar
//  }()
  
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  init(parent: UIView) {
    super.init(frame: .zero)
    
    setup(with: parent)
  }
  
  // MARK: - Setup Methods

  private func setup(with parent: UIView) {
    setupUI()
    addSubviews(with: parent)
    setupConstraints(with: parent)
  }
  
  private func setupUI() {
  }
  
  private func addSubviews(with parent: UIView) {
    addSubview(contactsLabel)
    //addSubview(searchBar)
    //addSubview(bottomBorderView)
    parent.addSubview(self)
  }
  
  private func setupConstraints(with parent: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      contactsLabel.heightAnchor.constraint(equalToConstant: 40),
      topAnchor.constraint(equalTo: contactsLabel.topAnchor, constant: 0.0),
      leadingAnchor.constraint(equalTo: contactsLabel.leadingAnchor, constant: -10.0),
      trailingAnchor.constraint(equalTo: contactsLabel.trailingAnchor, constant: 10.0),
      
//      contactsLabel.bottomAnchor.constraint(equalTo: searchBar.topAnchor, constant: 0.0),
//      leadingAnchor.constraint(equalTo: searchBar.leadingAnchor, constant: 0.0),
//      trailingAnchor.constraint(equalTo: searchBar.trailingAnchor, constant: 0.0),
//      bottomAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0.0),
      
//      bottomBorderView.heightAnchor.constraint(equalToConstant: 1),
//      searchBar.bottomAnchor.constraint(equalTo: bottomBorderView.bottomAnchor, constant: 0.0),
//      leadingAnchor.constraint(equalTo: bottomBorderView.leadingAnchor, constant: 0.0),
//      trailingAnchor.constraint(equalTo: bottomBorderView.trailingAnchor, constant: 0.0),
      
      heightAnchor.constraint(equalToConstant: 105.0),
      parent.safeAreaLayoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: 0),
      parent.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
      parent.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
      //parent.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20.0)
    ])
  }

}
