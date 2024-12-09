//
//  PhoneBookCell.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/6/24.
//

import UIKit
import SnapKit

// Cutom TableView Cell
final class PhoneBookCell: UITableViewCell {
    
    static let id = "PhoneBookCell" // 셀 고유 이름
    
    // MARK: - Cell UI
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let numberLabel = UILabel()
    private let profileImage = UIImageView()
    private let checkBox = UIButton()
    
    // MARK: - Cell Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configUI()
    }
}

// MARK: - Cell UI Setting Method
private extension PhoneBookCell {
    /// 셀의 모든 UI를 세팅하는 메소드
    func configUI() {
        self.backgroundColor = .clear
        self.addSubview(self.stackView)
        
        setupStackView()
        setupCheckBox()
        setupImageView()
        setupLabelView()
        setupUILayout()
    }
    
    func setupCheckBox() {
        self.checkBox.backgroundColor = .clear
        self.checkBox.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        self.checkBox.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        self.checkBox.imageView?.tintColor = .systemBlue
        self.checkBox.addTarget(self, action: #selector(checkBoxToggle), for: .touchDown)
    }
    
    @objc func checkBoxToggle() {
        self.checkBox.isSelected.toggle()
    }
    
    /// 이미지뷰를 세팅하는 메소드
    func setupImageView() {
        self.profileImage.contentMode = .scaleAspectFit
        self.profileImage.backgroundColor = .clear
        self.profileImage.layer.cornerRadius = 30
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderColor = UIColor.gray.cgColor
        self.profileImage.layer.borderWidth = 2
    }
    
    /// 레이블 뷰를 세팅하는 메소드
    func setupLabelView() {
        [self.nameLabel, self.numberLabel].forEach {
            $0.textColor = .label
            $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            $0.backgroundColor = .clear
            $0.numberOfLines = 1
        }
        self.nameLabel.textAlignment = .left
        self.numberLabel.textAlignment = .right
    }
    
    /// 스택뷰를 세팅하는 메소드
    func setupStackView() {
        self.stackView.axis = .horizontal
        self.stackView.spacing = 10
        self.stackView.alignment = .center
        self.stackView.distribution = .fill
        self.stackView.backgroundColor = .clear
        
        [self.checkBox,
         self.profileImage,
         self.nameLabel,
         self.numberLabel].forEach {
            self.stackView.addArrangedSubview($0)
        }
    }
    
    /// 모든 UI의 오토레이아웃을 설정하는 메소드
    func setupUILayout() {
        self.stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalToSuperview().inset(30)
        }
        
        self.checkBox.snp.makeConstraints {
            $0.width.height.equalTo(30)
            $0.centerY.equalToSuperview()
        }
        
        self.profileImage.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.centerY.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.centerY.equalToSuperview()
        }
        
        self.numberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
}

// MARK: - PhoneBookCell Method
extension PhoneBookCell {
    /// 셀의 UI를 업데이트 하는 메소드
    /// - Parameter data: PhoneBookData -> 코어 데이터에서 불러온 정보
    func updataCellUI(_ data: PhoneBookData) {
        if let name = data.name, let number = data.number, let profile = data.profile {
            self.checkBox.isHidden = true
            self.nameLabel.text = name
            self.numberLabel.text = number
            self.profileImage.image = UIImage(data: profile)
        } else {
            print("데이터를 불러올 수 없습니다")
            return
        }
    }
    
    func editingCell(_ data: PhoneBookData) {
        updataCellUI(data)
        UIView.animate(withDuration: 0.2) {
            self.checkBox.isHidden = false
        }
    }
}
