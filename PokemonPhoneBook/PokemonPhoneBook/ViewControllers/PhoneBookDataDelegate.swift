//
//  PhonBookDataDelegate.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/8/24.
//

import UIKit
import CoreData

protocol PhoneBookDataDelegate {
    var container: NSPersistentContainer { get }
    
    func createNewPhoneNumber()
    
    func readAllData()
}

extension PhoneBookDataDelegate {
    var container: NSPersistentContainer {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer
    }
    
    func createNewPhoneNumber(_ name: String, number: String, profileImage: UIImage) {
        guard let entity = NSEntityDescription.entity(forEntityName: PhoneBookData.className, in: self.container.viewContext) else { return }
        
        let newNumber = NSManagedObject.init(entity: entity, insertInto: self.container.viewContext)
        newNumber.setValue(name, forKey: PhoneBookData.Key.name)
        newNumber.setValue(number, forKey: PhoneBookData.Key.number)
        newNumber.setValue(profileImage.pngData(), forKey: PhoneBookData.Key.profile)
        
        do {
            try self.container.viewContext.save()
            print("번호 저장 성공")
        } catch {
            print("번호 저장 실패", error)
            return
        }
    }
    
    func readAllData() -> [PhoneBookData] {
        do {
            let phoneBooks = try self.container.viewContext.fetch(PhoneBookData.fetchRequest())
            print("데이터 불러오기 성공")
            return phoneBooks
            
        } catch {
            print("데이터 불러오기 실패", error)
            return []
        }
    }
}
