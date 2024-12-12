//
//  PhoneBookViewController.swift
//  PokemonPhoneBook
//
//  Created by YangJeongMu on 12/11/24.
//

import UIKit
import SnapKit

class PhoneBookViewController: UIViewController {
    
    
   
    
    let randomProfileImage = UIImageView()
    let randomImageButton = UIButton()
    let namebar = UITextField()
    let phoneNumberBar = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        // 네비게이션 바 제목
        self.title = "연락처 추가"
        
        // 네비게이션 바 적용 버튼
        let applyButton = UIBarButtonItem(title: "적용", style: .plain, target: self, action: #selector(applyButtonClicked))
        self.navigationItem.rightBarButtonItem = applyButton
        
        // 버튼 액션 설정
        
    }
    
    
    
    private func configureUI() {
        view.backgroundColor = .white
        
        // 프로필 이미지
        randomProfileImage.layer.cornerRadius = 75
        randomProfileImage.layer.borderColor = UIColor.lightGray.cgColor
        randomProfileImage.layer.borderWidth = 2
        randomProfileImage.clipsToBounds = true
        
        view.addSubview(randomProfileImage)
        randomProfileImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(150)
            
            
            // 랜덤 이미지 생성 버튼
            randomImageButton.setTitle("랜덤 이미지 생성", for: .normal)
            randomImageButton.setTitleColor(.systemGray, for: .normal)
            
            view.addSubview(randomImageButton)
            randomImageButton.snp.makeConstraints{ make in
                make.top.equalTo(randomProfileImage.snp.top).offset(160)
                make.centerX.equalToSuperview()
                make.width.equalTo(150)
                make.height.equalTo(50)
            }
            // 이름
            namebar.layer.cornerRadius = 8
            namebar.layer.borderColor = UIColor.lightGray.cgColor
            namebar.layer.borderWidth = 1
            namebar.clipsToBounds = true
            
            view.addSubview(namebar)
            namebar.snp.makeConstraints{ make in
                make.top.equalTo(randomImageButton.snp.top).offset(70)
                make.centerX.equalToSuperview()
                make.width.equalTo(350)
                make.height.equalTo(50)
            }
            
            // 전화번호
            phoneNumberBar.layer.cornerRadius = 8
            phoneNumberBar.layer.borderColor = UIColor.lightGray.cgColor
            phoneNumberBar.layer.borderWidth = 1
            phoneNumberBar.clipsToBounds = true
            
            view.addSubview(phoneNumberBar)
            phoneNumberBar.snp.makeConstraints { make in
                make.top.equalTo(namebar.snp.top).offset(60)
                make.centerX.equalToSuperview()
                make.width.equalTo(350)
                make.height.equalTo(50)
            }
            
            
            
            
        }
        
        
        
    }
    
    @objc
    private func applyButtonClicked() {
        self.navigationController?.pushViewController(PhoneBookViewController(), animated: true)
        print("적용")
    }
    
}





/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


