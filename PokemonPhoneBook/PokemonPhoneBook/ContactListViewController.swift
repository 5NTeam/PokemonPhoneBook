//
//  ViewController.swift
//  PokemonPhoneBook
//
//  Created by 손겸 on 12/6/24.
//

import UIKit
import CoreData

class ContactListViewController: UIViewController {
    
    // 코어데이터 컨텍스트 추가
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var contacts: [Contact] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchContacts()
        tableView.reloadData()
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
        let phoneBookVC = PhoneBookViewController()
        navigationController?.pushViewController(phoneBookVC, animated: true)
    }
    
    private func fetchContacts() {
        let repuest: NSFetchRequest<Contact> = Contact.fetchRequest()
        do {
            contacts = try context.fetch(repuest)
        } catch {
            print("\(error) 연락처 불러오기 실패")
        }
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
            cell.nameLabel.text = contact.name
            cell.phoneNumberLable.text = contact.phoneNumber
            
            // profileImage 처리 수정
            if let date = contact.profileImage {
                let imageName = "profile_\(date.timeIntervalSince1970)"
                if let image = loadImageFromDocumentDirectory(imageName: imageName) {
                    cell.profileImageView.image = image
                } else {
                    cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
                }
            } else {
                cell.profileImageView.image = UIImage(systemName: "person.circle.fill")
            }
            return cell
        }

        // 이미지를 Documents 디렉토리에서 로드하는 함수 수정
        func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
            let fileManager = FileManager.default
            guard let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }
            let imageUrl = documentURL.appendingPathComponent(imageName)
            if fileManager.fileExists(atPath: imageUrl.path) {
                return UIImage(contentsOfFile: imageUrl.path)
            }
            return nil
        }

    
}
