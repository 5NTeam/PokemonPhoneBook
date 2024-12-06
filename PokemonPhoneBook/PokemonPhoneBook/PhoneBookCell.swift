//
//  PhoneBookCell.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/6/24.
//

import UIKit
import SnapKit

final class PhoneBookCell: UITableViewCell {
    
    static let id = "PhoneBookCell"
    
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let numberLabel = UILabel()
    private let profileImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configUI()
    }
}

private extension PhoneBookCell {
    func configUI() {
        self.addSubview(self.stackView)
        
        setupStackView()
        setupImageView()
        setupLabelView()
        setupUILayout()
    }
    
    func setupImageView() {
        self.imageView?.contentMode = .scaleAspectFit
        self.imageView?.backgroundColor = UIColor.lightGray
        self.imageView?.layer.cornerRadius = 25
        self.imageView?.layer.borderColor = UIColor.gray.cgColor
        self.imageView?.layer.borderWidth = 2
        self.imageView?.clipsToBounds = true
    }
    
    func setupLabelView() {
        [self.nameLabel, self.numberLabel].forEach {
            $0.textColor = UIColor.black
            $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            $0.backgroundColor = UIColor.clear
            $0.textAlignment = .center
            $0.numberOfLines = 1
        }
    }
    
    func setupStackView() {
        self.stackView.axis = .horizontal
        self.stackView.spacing = 0
        self.stackView.alignment = .leading
        self.stackView.distribution = .fill
        
        [self.nameLabel, self.numberLabel, self.profileImage].forEach {
            self.stackView.addArrangedSubview($0)
        }
    }
    
    func setupUILayout() {
        self.stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.profileImage.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.profileImage.snp.trailing)
        }
        
        self.numberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(self.nameLabel.snp.trailing)
        }
    }
}
