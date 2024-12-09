//
//  ValidationAlert.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/9/24.
//

import UIKit

enum ValidationAlert {
    static func showValidationAlert(on viewController: UIViewController) {
        let alert = UIAlertController(title: "잘못된 입력", message: "입력값이 올바르지 않거나 형식이 잘못되었습니다.\n다시 입력해주세요.", preferredStyle: .alert)
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
