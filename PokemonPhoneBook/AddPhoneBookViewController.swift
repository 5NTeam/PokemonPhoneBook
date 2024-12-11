import UIKit
import Alamofire
import SnapKit
import CoreData

class AddViewController: UIViewController {
    
    private var container: NSPersistentContainer!
    var phoneBook: NSManagedObject?
    var isEditingMode: Bool = false
    
    private let pokeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 100
        return imageView
    }()
    
    private let createButton: UIButton = {
        let button = UIButton()
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .light)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름을 입력하세요"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "전화번호를 입력하세요"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
        setupNavigationBar()
        setupLayout()
        configureEditingMode()
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
    
    private func setupLayout() {
        [
            pokeImageView,
            createButton,
            nameTextField,
            phoneTextField
        ].forEach { view.addSubview($0) }
        
        pokeImageView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalTo(200)
        }
        
        createButton.snp.makeConstraints{ make in
            make.top.equalTo(pokeImageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(createButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.leading.trailing.height.equalTo(nameTextField)
        }

    }
    
    @objc private func createButtonTapped() {
        print("이미지 생성 버튼 탭")
        let randomNumber = Int.random(in: 0...100)
        var urlComponents = URLComponents(string: "https://pokeapi.co/api/v2/pokemon/\(randomNumber)")
        
        guard let url = urlComponents?.url else {
            print("잘못된 URL")
            return
        }
        fetchData(url: url) { [weak self] (result: Result<PokeModel, AFError>) in
            guard let self else { return }
            switch result {
            case .success(let result):
                print("\(result)")
                guard let imageUrl = URL(string: result.sprites.frontDefault)else { return }
                
                AF.request(imageUrl).responseData{ response in
                    if let data = response.data , let image = UIImage(data: data){
                        DispatchQueue.main.async{
                            self.pokeImageView.image = image
                        }
                    }
                }
            case .failure(let error):
                print("데이터 로드가 실패했다.")
                print(error)
            }
        }
    }
    
    @objc private func addButtonTapped() {
        print("추가 버튼 탭됨")
        guard let name = nameTextField.text, !name.isEmpty,
              let phoneNumber = phoneTextField.text, !phoneNumber.isEmpty,
              let image = pokeImageView.image else {
            showAlert(message: "이미지생성과 이름과 전화번호를 모두 입력하세요.")
            return
        }
        if isEditingMode {
            updateData(name: name, phoneNumber: phoneNumber, image: image)
        } else {
            createData(name: name, phoneNumber: phoneNumber, image: image)
        }
        print("저장 버튼 탭됨")
        navigationController?.popViewController(animated: true)
    }
     
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Alamofire 를 사용해서 서버 데이터를 불러오는 메서드
    private func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, AFError>) -> Void){
        AF.request(url).responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
    
    private func createData(name: String, phoneNumber: String, image: UIImage){
        guard let entity = NSEntityDescription.entity(forEntityName: PokemonPhoneBook.className, in: self.container.viewContext) else{return}
        let newPhoneBook = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        newPhoneBook.setValue(name, forKey: PokemonPhoneBook.Key.name)
        newPhoneBook.setValue(phoneNumber, forKey: PokemonPhoneBook.Key.phoneNumber)
        // UIImage -> Data로 변환하여 저장
        if let imageData = image.pngData() {
            newPhoneBook.setValue(imageData, forKey: PokemonPhoneBook.Key.image)
        }
        
        do{
            try self.container.viewContext.save()
            print("문맥 저장 성공")
        } catch{
            print("문맥 저장 실패")
        }
    }
    
    private func updateData(name: String, phoneNumber: String, image: UIImage){
        
        guard let phoneBook = phoneBook else {
                print("편집 중인 연락처가 없습니다.")
                return
            }
            phoneBook.setValue(name, forKey: PokemonPhoneBook.Key.name)
            phoneBook.setValue(phoneNumber, forKey: PokemonPhoneBook.Key.phoneNumber)
            
            if let imageData = image.pngData() {
                phoneBook.setValue(imageData, forKey: PokemonPhoneBook.Key.image)
            }
            do {
                try self.container.viewContext.save()
                print("데이터 업데이트 성공")
            } catch {
                print("데이터 업데이트 실패: \(error)")
            }
    }
    
    private func configureEditingMode() {
        guard isEditingMode, let phoneBook = phoneBook else { return }
        navigationItem.title = phoneBook.value(forKey: PokemonPhoneBook.Key.name) as? String
        nameTextField.text = phoneBook.value(forKey: PokemonPhoneBook.Key.name) as? String
        phoneTextField.text = phoneBook.value(forKey: PokemonPhoneBook.Key.phoneNumber) as? String
        
        if let imageData = phoneBook.value(forKey: PokemonPhoneBook.Key.image) as? Data {
            pokeImageView.image = UIImage(data: imageData)
        } else {
            pokeImageView.image = nil
        }
    }
}
