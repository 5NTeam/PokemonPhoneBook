//
//  ValidationAlert.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/9/24.
//

import UIKit

enum ValidationAlert {
    static func showValidationAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        viewController.present(alert, animated: true)
    }
    
    static func confirmDeleteDataAlert(on viewController: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "경고", message: "정말 삭제 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            completion()
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        viewController.present(alert, animated: true)
    }
}
