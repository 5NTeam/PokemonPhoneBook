//
//  ViewController.swift
//  PokemonPhoneBook
//
//  Created by YangJeongMu on 12/9/24.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    // MARK: - UI Components
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
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = 80 // 셀 높이 설정
        return tableView
    }()
    
    
    
    
    
 
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 데이터 소스 연결
        tableView.register(PhoneTableViewCell.self, forCellReuseIdentifier: "PhoneTableViewCell")
        tableView.dataSource = self
        
        addButton.addTarget(self, action: #selector(buttonClicked), for: .touchDown)
        
    }
    
    @objc
    private func buttonClicked() {
        print("버튼 클릭")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white

        // Add Components
        view.addSubview(titleLabel)
        view.addSubview(addButton)
        view.addSubview(tableView) // 테이블 뷰 추가
        
        // Layout Using SnapKit
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.centerX.equalToSuperview()
        }
        
        addButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview() // 하단 제약 조건 추가
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneTableViewCell") as!
        PhoneTableViewCell
        
        return cell
    }
}
