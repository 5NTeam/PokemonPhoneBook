//
//  Untitled.swift
//  PokemonPhoneBook
//
//  Created by 내일배움캠프 on 12/6/24.
//
import UIKit
import SnapKit


class PhoneBookTableViewCell: UITableViewCell {
    static let identifier = "PhoneBookTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneNumberLabel)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with contact: Contact) {
        nameLabel.text = contact.name
        phoneNumberLabel.text = contact.phoneNumber
    }
}
