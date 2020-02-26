//
//  ProfileViewController.swift
//  Contacts
//
//  Created by Andrei Coder on 18.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  // MARK: - Coordinator
  
  weak var coordinator: MainCoordinator?
  
  // MARK: Public Properties
  
  public var contact: Contact!
  
  // MARK: Private View Properties
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 26.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let educationPeriodLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .lightGray
    label.font = UIFont.systemFont(ofSize: 17.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let temperamentLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.textColor = .lightGray
    label.font = UIFont.systemFont(ofSize: 15.0)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private let phoneButtonTopView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let phoneButton: UIButton = {
    let button = UIButton(type: .system)
    let image = UIImage(named: "phone")?.withRenderingMode(.alwaysTemplate)
    button.setImage(image, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let phoneButtonBottomView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let biographyTextView: UITextView = {
    let textView = UITextView()
    textView.textColor = .lightGray
    textView.textAlignment = .center
    textView.isEditable = false
    textView.isSelectable = true
    textView.font = UIFont.systemFont(ofSize: 16.0)
    textView.translatesAutoresizingMaskIntoConstraints = false
    return textView
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupNavigationTitle()
  }
  
  // MARK: - Setup Methods
  
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
    view.addSubview(phoneButtonTopView)
    view.addSubview(phoneButton)
    view.addSubview(phoneButtonBottomView)
    view.addSubview(biographyTextView)
  }
  
  private func setupUI() {
    view.backgroundColor = .white
  }
  
  private func setupNavigationTitle() {
    /// Clear back button text
    navigationController?.navigationBar.topItem?.title = ""
  }
  
  private func setupConstraints() {    
    /// Set vertical hugging priority
    nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    educationPeriodLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    temperamentLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    
    let nameLabelConstraints = [
      view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -35.0),
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: -20.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20.0),
      nameLabel.bottomAnchor.constraint(equalTo: educationPeriodLabel.topAnchor, constant: -5.0)
    ]
    
    let educationPeriodLabelConstraints = [
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: educationPeriodLabel.leadingAnchor, constant: -20.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: educationPeriodLabel.trailingAnchor, constant: 20.0),
      educationPeriodLabel.bottomAnchor.constraint(equalTo: temperamentLabel.topAnchor, constant: -5.0)
    ]

    let temperamentLabelConstraints = [
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: temperamentLabel.leadingAnchor, constant: -20.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: temperamentLabel.trailingAnchor, constant: 20.0),
      temperamentLabel.bottomAnchor.constraint(equalTo: phoneButton.topAnchor, constant: -30.0)
    ]
    
    let phoneButtonTopViewConstraints = [
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: phoneButtonTopView.leadingAnchor, constant: -20.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: phoneButtonTopView.trailingAnchor, constant: 20.0),
      phoneButton.topAnchor.constraint(equalTo: phoneButtonTopView.topAnchor, constant: 0.0),
      phoneButtonTopView.heightAnchor.constraint(equalToConstant: 1.0)
    ]
    let phoneButtonConstraints = [
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: phoneButton.leadingAnchor, constant: -20.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: phoneButton.trailingAnchor, constant: 20.0),
      phoneButton.bottomAnchor.constraint(equalTo: biographyTextView.topAnchor, constant: -20.0),
      phoneButton.heightAnchor.constraint(equalToConstant: 50.0)
    ]
    let phoneButtonBottomViewConstraints = [
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: phoneButtonBottomView.leadingAnchor, constant: -20.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: phoneButtonBottomView.trailingAnchor, constant: 20.0),
      phoneButton.bottomAnchor.constraint(equalTo: phoneButtonBottomView.bottomAnchor, constant: 0.0),
      phoneButtonBottomView.heightAnchor.constraint(equalToConstant: 1.0)
    ]

    let biographyTextViewConstraints = [
      view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: biographyTextView.leadingAnchor, constant: -20.0),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: biographyTextView.trailingAnchor, constant: 20.0),
      view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: biographyTextView.bottomAnchor, constant: 20.0),
    ]
    
    NSLayoutConstraint.activate(
      nameLabelConstraints +
      educationPeriodLabelConstraints +
      temperamentLabelConstraints +
      phoneButtonTopViewConstraints +
      phoneButtonConstraints +
      phoneButtonBottomViewConstraints +
      biographyTextViewConstraints
    )
  }
  
  private func setupData() {
    nameLabel.text = contact.name
    educationPeriodLabel.text = contact.educationPeriod?.toString()
    temperamentLabel.text = contact.temperament.value()
    phoneButton.setTitle(contact.phone, for: .normal)
    biographyTextView.text = contact.biography
  }

}
