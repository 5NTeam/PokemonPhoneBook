import UIKit
import CoreData

class PhoneBookViewController: UIViewController {
    
    private var phoneBookList: [NSManagedObject] = []
    private let phoneBookView = PhoneBookView()

    override func loadView() {
        view = phoneBookView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        fetchData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func configureTableView() {
        phoneBookView.tableView.delegate = self
        phoneBookView.tableView.dataSource = self
        phoneBookView.tableView.register(PhoneBookTableViewCell.self, forCellReuseIdentifier: PhoneBookTableViewCell.identifier)
    }
    
    private func configureActions() {
        phoneBookView.addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    @objc private func addButtonTapped() {
        let addVC = AddPhoneBookViewController()
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    private func fetchData() {
        phoneBookList = CoreDataManager.shared.fetchPhoneBooks()
        phoneBookView.tableView.reloadData()
    }
}

extension PhoneBookViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteConfirmationAlert(forRowAt: indexPath)
        }
    }
    
    private func showDeleteConfirmationAlert(forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "삭제 확인", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            let managedObject = self.phoneBookList[indexPath.row]
            if CoreDataManager.shared.deletePhoneBook(phoneBook: managedObject) {
                self.phoneBookList.remove(at: indexPath.row)
                self.phoneBookView.tableView.deleteRows(at: [indexPath], with: .fade)
            } else {
                print("삭제 실패")
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let phoneBook = phoneBookList[indexPath.row]
        let addVC = AddPhoneBookViewController()
        addVC.phoneBook = phoneBook
        addVC.isEditingMode = true
        navigationController?.pushViewController(addVC, animated: true)
    }
}
