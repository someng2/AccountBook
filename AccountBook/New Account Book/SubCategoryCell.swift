//
//  SubCategoryCell.swift
//  AccountBook
//
//  Created by 백소망 on 2022/12/27.
//

import UIKit

class SubCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var subCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15
    }
    
    func configure(_ subcategory: SubCategory) {
        self.backgroundColor = UIColor(named: "LightOrange")
        iconImageView.image = subcategory.icon
        iconImageView.tintColor = .white
        subCategoryLabel.text = subcategory.name
        subCategoryLabel.textColor = .white
    }
    func setupDefaultBackground() {
        self.backgroundColor = UIColor(named: "SecondaryOrange")
    }
}


