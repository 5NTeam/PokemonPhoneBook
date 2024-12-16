//
//  AddPhoneBookView.swift
//  PokemonPhoneBook
//
//  Created by 내일배움캠프 on 12/11/24.
//

import UIKit
import SnapKit

class AddPhoneBookView: UIView {
    
    let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 100
        return imageView
    }()
    
    let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .light)
        button.backgroundColor = .clear
        return button
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "전화번호를 입력하세요"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        backgroundColor = .white
        
        [pokeImageView, createButton, nameTextField, phoneTextField].forEach { addSubview($0) }
        
        pokeImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(pokeImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(createButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(nameTextField)
        }
    }
    
    func updateView(with phoneBook: PhoneBook) {
            nameTextField.text = phoneBook.name
            phoneTextField.text = phoneBook.phoneNumber
            pokeImageView.image = phoneBook.image
    }
    
    func getFormData() -> (name: String, phoneNumber: String, image: UIImage?)? {
           guard let name = nameTextField.text, !name.isEmpty,
                 let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty,
                 let image = pokeImageView.image else { return nil }
           return (name, phoneNumber, image)
    }
    
    func updateImage(_ image: UIImage?) {
            pokeImageView.image = image
    }
    
}
