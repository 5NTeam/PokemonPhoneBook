//
//  ViewController.swift
//  PokemonPhoneBook
//
//  Created by 내일배움캠프 on 12/6/24.
//

import UIKit
import SnapKit
import CoreData

class PhoneBookViewController: UIViewController {
    
    private var container: NSPersistentContainer!
    private var phoneBook: [PhoneBook] = []
    private var phoneBookList: [NSManagedObject] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "친구 목록"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PhoneBookTableViewCell.self, forCellReuseIdentifier: PhoneBookTableViewCell.identifier)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        configureUI()
        loadPhoneBook()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        [
            stackView,
            tableView
        ].forEach { view.addSubview($0) }
        
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(addButton)
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(5)
            make.trailing.equalTo(-5)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(60)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func loadPhoneBook() {
        tableView.reloadData()
    }
    
    @objc private func addButtonTapped() {
        let addVC = AddViewController() // 연락처 추가 페이지 인스턴스 생성
        self.tableView.reloadData()
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    private func fetchData() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: PokemonPhoneBook.className)
        // 이름 순으로 정렬되게 정렬 조건 추가
        let sortDescriptor = NSSortDescriptor(key: PokemonPhoneBook.Key.name, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            phoneBookList = try self.container.viewContext.fetch(fetchRequest)
            tableView.reloadData() // 데이터를 가져온 후 테이블 뷰 갱신
        } catch {
            print("데이터 불러오기 실패: \(error.localizedDescription)")
        }
    }
}

extension PhoneBookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // 셀 높이를 80으로 설정
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phoneBookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhoneBookTableViewCell.identifier, for: indexPath) as? PhoneBookTableViewCell else {
            return UITableViewCell()
        }
        let managedObject = phoneBookList[indexPath.row]
        if let name = managedObject.value(forKey: PokemonPhoneBook.Key.name) as? String,
           let phoneNumber = managedObject.value(forKey: PokemonPhoneBook.Key.phoneNumber) as? String,
           let imageData = managedObject.value(forKey: PokemonPhoneBook.Key.image) as? Data,
           let image = UIImage(data: imageData) {
           let phoneBook = PhoneBook(name: name, phoneNumber: phoneNumber, image: image)
            cell.configure(with: phoneBook)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let phoneBook = phoneBookList[indexPath.row]
        print(phoneBook)
        let addVC = AddViewController()
        addVC.phoneBook = phoneBook
        addVC.isEditingMode = true
        self.tableView.reloadData()
        navigationController?.pushViewController(addVC, animated: true)
    }
}



