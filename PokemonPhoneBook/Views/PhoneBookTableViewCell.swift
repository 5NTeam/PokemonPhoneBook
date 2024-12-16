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
    
    private let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, phoneNumberLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(pokeImageView)
        contentView.addSubview(labelsStackView)
    }
    
    private func setupLayout() {
        pokeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        labelsStackView.snp.makeConstraints { make in
            make.leading.equalTo(pokeImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with phoneBook: PhoneBook) {
        nameLabel.text = phoneBook.name
        phoneNumberLabel.text = phoneBook.phoneNumber
        if let image = phoneBook.image {
            pokeImageView.image = image
        }
    }
}
