//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Andrei Coder on 22.02.2020.
//  Copyright © 2020 yaav. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

  // MARK: - Reuse Identifier
  
  static let reuseIdentifier = "ContactTableViewCell"
  
  // MARK: - Outlets
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var phoneLabel: UILabel!
  @IBOutlet weak var temperamentLabel: UILabel!
  
  // MARK: - Overridden Methods
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  // MARK: - Configure Method
  
  public func configure(for contact: Contact) {
    nameLabel.text = contact.name
    phoneLabel.text = contact.phone
    temperamentLabel.text = contact.temperament.rawValue
  }
  
//    override func awakeFromNib() {
//      super.awakeFromNib()
//      // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//      super.setSelected(selected, animated: animated)
//    }
    
}
