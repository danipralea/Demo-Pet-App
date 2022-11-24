//
//  ListTableViewCell.swift
//  Demo Pet App
//
//  Created by Danut Pralea on 21.11.2022.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    func update(with pet: Pet) {
        nameLabel.text = pet.name
    }
}
