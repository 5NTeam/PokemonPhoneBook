//
//  ViewController.swift
//  PokemonPhoneBook
//
//  Created by YangJeongMu on 12/9/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    
    // MARK: - UI Componetns
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        
    }
    // MARK: -Setup UI
    private func setupUI() {
        view.backgroundColor = .white

        // Add Components
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        
        // Layout Using SnapKit
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
            
        }
        
        addButton.snp.makeConstraints{ make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
    }
}

