//
//  ViewController.swift
//  PokemonPhoneBook
//
//  Created by 손겸 on 12/6/24.
//

import UIKit

class ContactListViewController: UIViewController {
    
    // 더미 데이터
    let contacts = [
        ("sonny", "010-5555-6666"),
        ("changSu", "010-1111-2222"),
        ("siHyeon", "010-4444-5555"),
        ("gangMin", "010-8888-9999"),
        ("teaMin", "010-7777-9999"),
        ("jiHyo", "010-6666-0000"),
        ("Mini", "010-3333-4444")
    ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: ContactTableViewCell.id)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        title = "친구 목록"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "추가",
            style: .plain,
            target: self,
            action: #selector(didTapAddButton)
        )
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func didTapAddButton() {
        print("추가 버튼 눌림")
    }
}

// 셀 높이
extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension ContactListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.id, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        let contact = contacts[indexPath.row]
        cell.nameLabel.text = contact.0
        cell.phoneNumberLable.text = contact.1
        cell.profileImageView.backgroundColor = .white
        return cell
    }
    
    
}
