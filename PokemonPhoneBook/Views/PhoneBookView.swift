//
//  PhoneBookView.swift
//  PokemonPhoneBook
//
//  Created by 내일배움캠프 on 12/11/24.
//

import UIKit
import SnapKit

class PhoneBookView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .clear
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        return stackView
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    @available(*, unavailable, message: "이 뷰는 Storyboard를 지원하지 않습니다.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.backgroundColor = .white
        [
            stackView,
            tableView
        ].forEach { addSubview($0) }
        
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(addButton)
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(5)
            make.trailing.equalTo(-5)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(60)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
