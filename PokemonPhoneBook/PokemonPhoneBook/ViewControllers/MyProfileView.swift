//
//  MyProfileView.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/10/24.
//

import UIKit
import SnapKit

final class MyProfileView: UIView {
    
    private let stackView = UIStackView()
    
    private let profileImageView = UIImageView()
    
    private let titleLabel = UILabel()
    
    private let nameLabel = UILabel()
    
    private let numberLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configUI()
    }
    
    func reloadData() {
        setupImageView()
        setupProfileText()
    }
}

private extension MyProfileView {
    
    func configUI() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.stackView)
        
        setupTitleLabel()
        setupStackView()
        setupImageView()
        setupLabelView()
        setupUILayout()
    }
    
    func setupStackView() {
        [self.profileImageView,
         self.nameLabel,
         self.numberLabel].forEach { self.stackView.addArrangedSubview($0) }
        
        self.stackView.axis = .horizontal
        self.stackView.distribution = .fill
        self.stackView.spacing = 10
        self.stackView.alignment = .center
        self.stackView.backgroundColor = .clear
    }
    
    func setupTitleLabel() {
        let gradientColor = CAGradientLayer()
        let colors: [UIColor] = [.blue.withAlphaComponent(0.1), .cyan.withAlphaComponent(0.5)]
        gradientColor.frame = CGRect(x: 0, y: 0, width: 402, height: 25)
        gradientColor.colors = colors.map { $0.cgColor }
        gradientColor.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientColor.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        self.titleLabel.text = "  내 프로필"
        self.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        self.titleLabel.backgroundColor = .clear
        self.titleLabel.textAlignment = .left
        
        self.titleLabel.layer.addSublayer(gradientColor)
    }
    
    func setupLabelView() {
        [self.nameLabel, self.numberLabel].forEach {
            $0.textColor = .label
            $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            $0.backgroundColor = .clear
            $0.numberOfLines = 1
        }
        self.nameLabel.textAlignment = .left
        self.numberLabel.textAlignment = .right
        self.numberLabel.textColor = .systemGray
        
        setupProfileText()
    }
    
    func setupImageView() {
        self.profileImageView.contentMode = .scaleAspectFit
        self.profileImageView.backgroundColor = .white
        self.profileImageView.layer.cornerRadius = 30
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderColor = UIColor.cyan.cgColor
        self.profileImageView.layer.borderWidth = 2
        
        setupProfileImage()
    }
    
    func setupProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "myProfile") {
            guard let image = UIImage(data: imageData) else { return }
            self.profileImageView.image = image
            self.layoutIfNeeded()
        } else {
            fetchRandomImage()
        }
    }
    
    func setupProfileText() {
        if let name = UserDefaults.standard.string(forKey: "myName"), let number = UserDefaults.standard.string(forKey: "myNumber") {
            self.nameLabel.text = name
            self.numberLabel.text = number
        } else {
            self.nameLabel.text = "User"
            self.numberLabel.text = "010-1234-5678"
            
            UserDefaults.standard.set(self.nameLabel.text, forKey: "myName")
            UserDefaults.standard.set(self.numberLabel.text, forKey: "myNumber")
        }
    }
    
    func setupUILayout() {
        self.titleLabel.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(25)
        }
        
        self.stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.top.equalTo(self.titleLabel.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        self.profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(60)
            $0.centerY.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.centerY.equalToSuperview()
        }
        
        self.numberLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
    
    func fetchRandomImage() {
        fetchData { [weak self] (result: PokemonModel?) in
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
                            UserDefaults.standard.set(imageData, forKey: "myProfile")
                            self.layoutIfNeeded()
                        } else {
                            self.profileImageView.image = image
                            UserDefaults.standard.set(imageData, forKey: "myProfile")
                            self.layoutIfNeeded()
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
    
    /// 서버에서 데이터를 받아오는 메소드
    /// - Parameter completion: 받아온 데이터를 디코딩하고 클로저에 전달
    func fetchData<T: Decodable>(_ completion: @escaping (T?) -> Void) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/25") else {
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

