//
//  TableViewCell.swift
//  PokemonPhoneBook
//
//  Created by 손겸 on 12/6/24.
//

import UIKit
import SnapKit

class ContactTableViewCell: UITableViewCell {
    
    // 프로필 이미지
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    // 이름 레이블
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        return label
        
    }()
    
}


