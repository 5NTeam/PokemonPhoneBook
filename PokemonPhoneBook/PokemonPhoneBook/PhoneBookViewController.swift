//
//  PhoneBookViewController.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/6/24.
//

import UIKit
import SnapKit

final class PhoneBookViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
}

private extension PhoneBookViewController {
    func configUI() {
        view.backgroundColor = .white

        setupNavigationTitle()
        setupNavigationRightButton()
    }
    
    func setupNavigationTitle() {
        let title = UILabel()
        title.text = "연락처 추가"
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        title.textAlignment = .center
        title.backgroundColor = .clear
        
        self.navigationItem.titleView = title
    }
    
    func setupNavigationRightButton() {
        let rightButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(savePhoneNumber))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func savePhoneNumber() {
        
    }
}
