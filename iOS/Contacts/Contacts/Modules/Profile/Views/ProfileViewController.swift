//
//  ProfileViewController.swift
//  Contacts
//
//  Created by Andrei Coder on 18.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

  // MARK: Public Properties
  
  public var contact: Contact!
  
  // MARK: Private View Properties
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .orange
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let educationPeriodLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .green
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let temperamentLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let phoneButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.blue, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let biographyLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.backgroundColor = .red
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  // MARK: - Convenience Init
  
  convenience init(contact: Contact) {
    self.init(nibName: nil, bundle: nil)

    self.contact = contact
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  private func setup() {
    addSubviews()
    setupUI()
    setupConstraints()
    setupData()
  }
  
  private func addSubviews() {
    view.addSubview(nameLabel)
    view.addSubview(educationPeriodLabel)
    view.addSubview(temperamentLabel)
    view.addSubview(phoneButton)
    view.addSubview(biographyLabel)
  }
  
  private func setupUI() {
    view.backgroundColor = .white
  }
  
  private func setupConstraints() {    
    /// Set vertical hugging priority
    nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    educationPeriodLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    temperamentLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    
    let nameLabelConstraints = [
      view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 0.0),
      nameLabel.bottomAnchor.constraint(equalTo: educationPeriodLabel.topAnchor, constant: 0.0)
    ]
    
    let educationPeriodLabelConstraints = [
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: educationPeriodLabel.leadingAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: educationPeriodLabel.trailingAnchor, constant: 0.0),
      educationPeriodLabel.bottomAnchor.constraint(equalTo: temperamentLabel.topAnchor, constant: 0.0)
    ]

    let temperamentLabelConstraints = [
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: temperamentLabel.leadingAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: temperamentLabel.trailingAnchor, constant: 0.0),
      temperamentLabel.bottomAnchor.constraint(equalTo: phoneButton.topAnchor, constant: 0.0)
    ]

    let phoneButtonConstraints = [
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: phoneButton.leadingAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: phoneButton.trailingAnchor, constant: 0.0),
      phoneButton.bottomAnchor.constraint(equalTo: biographyLabel.topAnchor, constant: 0.0),
      phoneButton.heightAnchor.constraint(equalToConstant: 40.0)
    ]

    let biographyLabelConstraints = [
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: biographyLabel.leadingAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: biographyLabel.trailingAnchor, constant: 0.0),
      
      //view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: biographyLabel.bottomAnchor, constant: 0.0),
      view.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: biographyLabel.bottomAnchor, constant: 0.0)
    ]
    
    NSLayoutConstraint.activate(
      nameLabelConstraints +
      educationPeriodLabelConstraints +
      temperamentLabelConstraints +
      phoneButtonConstraints +
      biographyLabelConstraints
    )
  }
  
  private func setupData() {
    nameLabel.text = contact.name
    //educationPeriodLabel.text = DateFormatter.string(from: contact.educationPeriod)
    temperamentLabel.text = contact.temperament.value()
    phoneButton.setTitle(contact.phone, for: .normal)
    biographyLabel.text = contact.biography
  }

}
