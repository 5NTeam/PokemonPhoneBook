//
//  PhoneBookViewController.swift
//  PokemonPhoneBook
//
//  Created by 손겸 on 12/7/24.
//

import UIKit

class PhoneBookViewController: UIViewController {
    
    // 프로필 이미지
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 랜덤 이미지 버튼
    private let randomButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.addTarget(PhoneBookViewController.self,action: #selector(generateRandomImage),for: .touchUpInside)
        return button
    }()
    // 이름 텍스트 필드
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // 전화번호 텍스트 필드
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "번호를 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        title = "연락처 추가"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "적용",
            style: .plain,
            target: self,
            action: #selector(applyButtonTapped)
        )
        
        // 레이아웃 설정
        [
            profileImageView,
            randomButton,
            nameTextField,
            phoneTextField
        ].forEach { view.addSubview($0) }
        
        
    }
    
    @objc private func generateRandomImage() {
        print("랜덤 이미지 버튼 눌림")
    }
    
    @objc private func applyButtonTapped() {
        print("적용 버튼 눌림")
        navigationController?.popViewController(animated: true)
    }
}


