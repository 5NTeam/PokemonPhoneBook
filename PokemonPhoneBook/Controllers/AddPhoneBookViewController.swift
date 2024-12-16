import UIKit
import CoreData
import Alamofire

class AddPhoneBookViewController: UIViewController {
    
    private let addPhoneBookView = AddPhoneBookView()
    
    var phoneBook: NSManagedObject?
    var isEditingMode: Bool = false
    
    override func loadView() {
        view = addPhoneBookView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureEditingMode()
        addActions()
    }
    
    private func setupNavigationBar() {
        let addButton = UIBarButtonItem(
            title: "적용",
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        navigationItem.title = "연락처 추가"
        navigationItem.rightBarButtonItem = addButton
    }
    
    private func addActions() {
        addPhoneBookView.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    @objc private func createButtonTapped() {
        let randomNumber = Int.random(in: 0...1000)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(randomNumber)") else { return }
        
        PokeAPIManager.shared.fetchPokemonData(url: url) { [weak self] (result: Result<PokeMon, AFError>) in
            guard let self = self else { return }
            switch result {
            case .success(let pokemon):
                guard let imageUrl = URL(string: pokemon.sprites.frontDefault) else { return }
                PokeAPIManager.shared.fetchImage(url: imageUrl) { imageResult in
                    switch imageResult {
                    case .success(let image):
                        DispatchQueue.main.async {
                            self.addPhoneBookView.updateImage(image)
                        }
                    case .failure(let error):
                        print("이미지 로드 실패: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("데이터 로드 실패: \(error)")
            }
        }
    }
    
    @objc private func addButtonTapped() {
        guard let formData = addPhoneBookView.getFormData() else {
            showAlert(message: "이미지 생성과 이름, 전화번호를 모두 입력하세요.")
            return
        }
        if isEditingMode {
            updateData(name: formData.name, phoneNumber: formData.phoneNumber, image: formData.image!)
        } else {
            createData(name: formData.name, phoneNumber: formData.phoneNumber, image: formData.image!)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func createData(name: String, phoneNumber: String, image: UIImage) {
        if CoreDataManager.shared.createPhoneBook(name: name, phoneNumber: phoneNumber, image: image) {
            print("연락처 저장 성공")
        } else {
            print("연락처 저장 실패")
        }
    }
    
    private func updateData(name: String, phoneNumber: String, image: UIImage) {
        guard let phoneBook = phoneBook else { return }
        if CoreDataManager.shared.updatePhoneBook(phoneBook: phoneBook, name: name, phoneNumber: phoneNumber, image: image) {
            print("연락처 업데이트 성공")
        } else {
            print("연락처 업데이트 실패")
        }
    }
    
    private func configureEditingMode() {
        guard isEditingMode, let phoneBook = phoneBook else { return }
        let phoneBook1 = PhoneBook(
            name: phoneBook.value(forKey: PokemonPhoneBook.Key.name) as? String ?? "",
            phoneNumber: phoneBook.value(forKey: PokemonPhoneBook.Key.phoneNumber) as? String ?? "",
            image: (phoneBook.value(forKey: PokemonPhoneBook.Key.image) as? Data).flatMap { UIImage(data: $0) }
        )
        addPhoneBookView.updateView(with: phoneBook1)
    }
}
