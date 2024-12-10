//
//  ViewController.swift
//  PokemonPhoneBook
//
//  Created by 내일배움캠프 on 12/6/24.
//

import UIKit
import SnapKit

class PhoneBookViewController: UIViewController {
    
    private let tableView = UITableView()
    private var contacts: [Contact] = []
    private let contactManager = ContactManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupLayout()
        loadContacts()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PhoneBookTableViewCell.self, forCellReuseIdentifier: PhoneBookTableViewCell.identifier)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadContacts() {
        contacts = contactManager.fetchContacts()
        tableView.reloadData()
    }
}

extension PhoneBookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhoneBookTableViewCell.identifier, for: indexPath) as? PhoneBookTableViewCell else {
            return UITableViewCell()
        }
        let contact = contacts[indexPath.row]
        cell.configure(with: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contact = contacts[indexPath.row]
        print("Selected contact: \(contact.name), Phone: \(contact.phoneNumber)")
    }
}



