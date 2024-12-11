//
//  ValidationAlert.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/9/24.
//

import UIKit

// Alert Manager
enum ValidationAlert {
    /// '확인' 버튼이 있는 커스텀 Alert
    /// - Parameters:
    ///   - viewController: Alert을 띄울 뷰 컨트롤러
    ///   - title: Alert의 title
    ///   - message: Alert의 message
    static func showValidationAlert(on viewController: UIViewController, title: String, message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        viewController.present(alert, animated: true)
    }
    
    /// 삭제를 최종적으로 확인하는 Alert
    /// - Parameters:
    ///   - viewController: Alert을 띄울 뷰 컨트롤러
    ///   - completion: 삭제를 선택한 뒤 실행할 작업
    static func confirmDeleteDataAlert(on viewController: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "경고", message: "정말 삭제 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            completion()
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        viewController.present(alert, animated: true)
    }
    
    /// 같은 번호가 존재할 때 알람을 보여줄 Alert
    /// - Parameters:
    ///   - viewController: Alert을 띄울 뷰 컨트롤러
    ///   - completion: 업데이트 작업을 실행하는 클로저
    static func promptPhoneNumberResolution(on viewController: UIViewController, completion: @escaping () -> Void) {
        let alert = UIAlertController(title: "알림", message: "이미 존재하는 번호입니다.\n연락처를 업데이트 하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "업데이트", style: .default, handler: { _ in
            completion()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        viewController.present(alert, animated: true)
    }
}
