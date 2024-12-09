//
//  PhoneBookViewController.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/6/24.
//

import UIKit
import SnapKit

// SubViewController
final class PhoneBookViewController: UIViewController, PhoneBookDataDelegate {
    // 현재 뷰의 상태 (새로 생성, 수정)
    enum ViewState {
        case create
        case edit
    }
    
    var state: ViewState = .create // 기본 상태는 새로 생성
    
    private var currentName: String = ""
    private var currentNumbrer: String = ""
    
    // MARK: - PhoneBookViewController UI
    private let profileImageView = UIImageView()
    private let profileImageRandomChangeButton = UIButton()
    private let nameTextField = UITextField()
    private let numberTextField = UITextField()
    
    // MARK: - PhoneBookViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
}

// MARK: - PhoneBookViewController UI Setting Method
private extension PhoneBookViewController {
    /// 서브 뷰의 모든 UI 요소를 배치 및 설정
    func configUI() {
        view.backgroundColor = .white
        
        [self.profileImageView,
         self.profileImageRandomChangeButton,
         self.nameTextField,
         self.numberTextField].forEach { view.addSubview($0) }

        setupImageView()
        setupChangeButton()
        setupTextField()
        setupNavigationTitle()
        setupNavigationRightButton()
        setupUILayout()
    }
    
    /// 프로필 이미지를 세팅하는 메소드
    func setupImageView() {
        self.profileImageView.contentMode = .scaleAspectFit
        self.profileImageView.backgroundColor = .clear
        self.profileImageView.layer.cornerRadius = 100
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderColor = UIColor.gray.cgColor
        self.profileImageView.layer.borderWidth = 2
    }
    
    /// 텍스트필드를 세팅하는 메소드
    func setupTextField() {
        [self.nameTextField, self.numberTextField].forEach {
            $0.font = UIFont.systemFont(ofSize: 15, weight: .light)
            $0.borderStyle = .roundedRect
            $0.textColor = .black
            $0.keyboardType = .default
            $0.clearButtonMode = .whileEditing
        }
        self.nameTextField.placeholder = "이름을 입력해 주세요"
        self.numberTextField.placeholder = "전화번호를 입력해 주세요"
    }
    
    /// 프로필 이미지 변경 버튼을 세팅하는 메소드
    func setupChangeButton() {
        var config = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString.init("랜덤 이미지 생성")
        titleAttr.font = .systemFont(ofSize: 20, weight: .medium)
        
        config.attributedTitle = titleAttr
        config.baseForegroundColor = .gray
        
        self.profileImageRandomChangeButton.configuration = config
        self.profileImageRandomChangeButton.backgroundColor = .clear
        self.profileImageRandomChangeButton.addTarget(self, action: #selector(changeProfileImage), for: .touchDown)
    }
    
    /// 프로필 이미지를 랜덤으로 변경하는 메소드
    @objc func changeProfileImage() {
        print("Button Tapped")
        
        self.fetchData { [weak self] (result: PokemonModel?) in
            guard let self, let result else {
                print("데이터 불러오기 오류")
                return
            }
            
            // 이로치 포켓몬 등장 확률
            let luck = Int.random(in: 1...4096) == 777
            let url = luck ? result.sprites.frontShiny : result.sprites.frontDefault
            
            guard let imageURL = URL(string: url) else {
                print("잘못된 이미지 URL")
                return
            }
            
            if let imageData = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        if luck {
                            self.profileImageView.image = image
                            self.shiningImage()
                            self.view.layoutIfNeeded()
                        } else {
                            self.profileImageView.image = image
                            self.view.layoutIfNeeded()
                        }
                        print("이미지 변환 성공")
                    }
                } else {
                    print("이미지 변환 실패")
                }
            } else {
                print("이미지 URL, 데이터 변환 실패")
            }
        }
    }
    
    /// 이미지 특수효과 적용 메소드
    func shiningImage() {
        let gradientLayer = CAGradientLayer()
        let gradationColor = [UIColor.clear, .yellow.withAlphaComponent(0.15), .clear]
        gradientLayer.frame = self.profileImageView.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.colors = gradationColor.map { $0.cgColor }
        gradientLayer.locations = [-0.5, -0.25, 0]
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-0.5, -0.25, 0]
        animation.toValue = [1, 1.25, 1.5]
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.repeatCount = 2
        animation.duration = 0.5
        gradientLayer.add(animation, forKey: "shimmering")
        
        self.profileImageView.layer.addSublayer(gradientLayer)
    }
    
    /// 서브 뷰의 모든 UI 레이아웃을 설정하는 메소드
    func setupUILayout() {
        self.profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(200)
        }
        
        self.profileImageRandomChangeButton.snp.makeConstraints {
            $0.top.equalTo(self.profileImageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
        
        self.nameTextField.snp.makeConstraints {
            $0.top.equalTo(self.profileImageRandomChangeButton.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(40)
        }
        
        self.numberTextField.snp.makeConstraints {
            $0.top.equalTo(self.nameTextField.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(300)
            $0.height.equalTo(40)
        }
    }
    
    /// 네비게이션 타이틀을 설정하는 메소드
    func setupNavigationTitle() {
        let title = UILabel()
        title.text = self.state == .create ? "연락처 추가" : self.currentName
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        title.textAlignment = .center
        title.backgroundColor = .clear
        
        self.navigationItem.titleView = title
    }
    
    /// 네비게이션바의 오른쪽 버튼을 세팅하는 메소드
    func setupNavigationRightButton() {
        if self.state == .create {
            let rightButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(savePhoneNumber))
            self.navigationItem.rightBarButtonItem = rightButton
        } else {
            let rightButton = UIBarButtonItem(title: "수정", style: .plain, target: self, action: #selector(updatePhoneNumber))
            self.navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    /// 현재 입력한 정보를 저장하는 메소드
    @objc func savePhoneNumber() {
        guard let name = self.nameTextField.text, let number = self.numberTextField.text, let image = self.profileImageView.image else { return }
        guard checkTextField() else {
            ValidationAlert.showValidationAlert(on: self)
            print("입력 오류")
            return
        }
        
        self.createNewPhoneNumber(name: name, number: number, profileImage: image)
        self.navigationController?.popViewController(animated: true) // 이전 뷰로 돌아가기
    }
    
    @objc func updatePhoneNumber() {
        guard let name = self.nameTextField.text, let number = self.numberTextField.text, let image = self.profileImageView.image else { return }
        guard checkTextField() else {
            ValidationAlert.showValidationAlert(on: self)
            print("입력 오류")
            return
        }
        
        self.updatePhoneNumber(currentName: self.currentName, currentNumber: self.currentNumbrer, updateName: name, updateNumber: number, updateImage: image)
        self.navigationController?.popViewController(animated: true) // 이전 뷰로 돌아가기
    }
}

// MARK: - PhoneBookViewController Fetch Method
private extension PhoneBookViewController {
    
    /// 서버에서 데이터를 받아오는 메소드
    /// - Parameter completion: 받아온 데이터를 디코딩하고 클로저에 전달
    func fetchData<T: Decodable>(_ completion: @escaping (T?) -> Void) {
        let randomNumber = Int.random(in: 1...1000)
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(randomNumber)") else {
            print("잘못된 URL 입니다")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data, error == nil else {
                print("잘못된 호출입니다.")
                completion(nil)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                
                let successRange: Range = 200..<300
                guard successRange.contains(response.statusCode) else {
                    print("데이터 요청 실패")
                    completion(nil)
                    return
                }
                
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    print("디코딩 성공")
                    completion(decodedData)
                    return
                } catch {
                    print(error)
                    completion(nil)
                }
                
            } else {
                print("http 요청 실패")
                completion(nil)
            }
        }.resume()
    }
}

// MARK: - PhoneBookViewController Method
extension PhoneBookViewController {
    /// 연락처 수정을 위해 수정할 연락처의 정보를 가져오는 메소드
    /// - Parameters:
    ///   - name: 수정할 연락처의 이름
    ///   - number: 수정할 연락처의 번호
    ///   - image: 수정할 연락처의 프로필 이미지
    func editPhoneNumber(name: String, number: String, image: UIImage) {
        self.nameTextField.text = name
        self.numberTextField.text = number
        self.profileImageView.image = image
        
        self.currentName = name
        self.currentNumbrer = number
    }
    
    private func checkTextField() -> Bool {
        guard let name = self.nameTextField.text, let number = self.numberTextField.text, let profile = self.profileImageView.image?.pngData() else { return false }
        
        if name.isEmpty || number.isEmpty || profile.isEmpty {
            return false
        } else {
            return true
        }
    }
}
