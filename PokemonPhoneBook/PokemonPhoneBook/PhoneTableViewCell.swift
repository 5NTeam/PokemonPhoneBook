//
//  PhoneTableViewCell.swift
//  PokemonPhoneBook
//
//  Created by YangJeongMu on 12/11/24.
//

import UIKit

class PhoneTableViewCell: UITableViewCell {
    

    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    let phoneLabel = UILabel()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        
      }
       
      required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
          
          
      }
       
      private func configureUI() {
          self.contentView.addSubview(profileImageView)
          self.contentView.addSubview(nameLabel)
          self.contentView.addSubview(phoneLabel)

          nameLabel.text = "pokemom"
          phoneLabel.text = "010-0000-0000"
          phoneLabel.textAlignment = .right
          profileImageView.layer.cornerRadius = 25
          profileImageView.layer.borderColor = UIColor.lightGray.cgColor
          profileImageView.layer.borderWidth = 1
          
          
          profileImageView.snp.makeConstraints{ make in
              make.leading.equalToSuperview().offset(16)
              make.top.equalToSuperview().offset(16)
              make.width.equalTo(50)
              make.height.equalTo(50)
          }
         
          nameLabel.snp.makeConstraints{ make in
              make.leading.equalTo(profileImageView.snp.trailing).offset(16)
              make.top.equalToSuperview().offset(16)
              make.width.equalTo(100)
              make.height.equalTo(50)
            
          }
          
          phoneLabel.snp.makeConstraints{ make in
              
              make.trailing.equalToSuperview().offset(-16)
              make.top.equalToSuperview().offset(16)
              make.width.equalTo(150)
              make.height.equalTo(50)
          }
          
      }



}
