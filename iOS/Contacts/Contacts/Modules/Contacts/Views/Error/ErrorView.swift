//
//  ErrorView.swift
//  Contacts
//
//  Created by Andrei Coder on 24.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import UIKit

class ErrorView: UIView {
  
  // MARK: - Private View Properties
  
  private let errorLabel: UILabel = {
    let label = UILabel()
    label.text = "Нет подключения к сети"
    label.textAlignment = .center
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
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
    alpha = 0
    backgroundColor = UIColor.black.withAlphaComponent(0.6)
    layer.cornerRadius = 8.0
  }
  
  private func addSubviews(with parent: UIView) {
    addSubview(errorLabel)
    parent.addSubview(self)
  }
  
  private func setupConstraints(with parent: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: errorLabel.topAnchor, constant: 0.0),
      leadingAnchor.constraint(equalTo: errorLabel.leadingAnchor, constant: 0.0),
      trailingAnchor.constraint(equalTo: errorLabel.trailingAnchor, constant: 0.0),
      bottomAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 0.0),
      
      heightAnchor.constraint(equalToConstant: 50.0),
      parent.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -35.0),
      parent.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 35.0),
      parent.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 20.0)
    ])
  }
  
  // MARK: - Public Methods
  
  public func show() {
    UIView.animate(withDuration: 0.5) { [unowned self] in
      self.alpha = 1
    }
  }
  
  public func hide() {
    UIView.animate(withDuration: 0.5) { [unowned self] in
      self.alpha = 0
    }
  }
  
}
