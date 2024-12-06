//
//  ViewController.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/6/24.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let navigationTitle = UILabel()
    
    private let pushButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
}

private extension ViewController {
    func configUI() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        [self.tableView,
         self.navigationTitle,
         self.pushButton].forEach { view.addSubview($0) }
        
        setupTableView()
        setupNavigationTitle()
        setupPushButtonView()
        setupUILayout()
    }
    
    func setupNavigationTitle() {
        navigationTitle.text = "친구 목록"
        navigationTitle.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        navigationTitle.textAlignment = .center
        navigationTitle.textColor = .black
        navigationTitle.backgroundColor = .clear
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(PhoneBookCell.self, forCellReuseIdentifier: PhoneBookCell.id)
        self.tableView.backgroundColor = .clear
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.separatorInset.right = 20
    }
    
    func setupUILayout() {
        self.navigationTitle.snp.makeConstraints {
            $0.top.trailing.leading.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
        
        self.tableView.snp.makeConstraints {
            $0.trailing.leading.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(self.navigationTitle.snp.bottom).inset(10)
        }
        
        self.pushButton.snp.makeConstraints {
            $0.top.bottom.equalTo(self.navigationTitle)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func setupPushButtonView() {
        var config = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString.init("추가")
        titleAttr.font = .systemFont(ofSize: 20, weight: .medium)
        
        config.attributedTitle = titleAttr
        config.baseForegroundColor = .systemBlue
        
        self.pushButton.configuration = config
        self.pushButton.backgroundColor = .clear
    }
    
    @objc func pushDestinationView() {
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: PhoneBookCell.id) as? PhoneBookCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

extension ViewController: UITableViewDelegate {
    
}
