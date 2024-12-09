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
    
    func createNewPhoneNumber(name: String, number: String, profileImage: UIImage)
    
    func readAllData() -> [PhoneBookData]
    
    func updatePhoneNumber(currentName: String, currentNumber: String, updateName: String, updateNumber: String, updateImage: UIImage)
    
    func deleteData(name: String, number: String)
}

extension PhoneBookDataDelegate {
    var container: NSPersistentContainer {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer
    }
    
    func createNewPhoneNumber(name: String, number: String, profileImage: UIImage) {
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
    
    func updatePhoneNumber(currentName: String, currentNumber: String, updateName: String, updateNumber: String, updateImage: UIImage) {
        let fetchRequest = PhoneBookData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND number == %@", currentName, currentNumber)
        
        do {
            let fetchData = try self.container.viewContext.fetch(fetchRequest)
            let result = fetchData as [NSManagedObject]
            
            if let data = result.first {
                data.setValue(updateName, forKey: PhoneBookData.Key.name)
                data.setValue(updateNumber, forKey: PhoneBookData.Key.number)
                data.setValue(updateImage.pngData(), forKey: PhoneBookData.Key.profile)
            }
            
            print("데이터 업데이트 성공")
            
        } catch {
            print("업데이트 실패", error)
        }
    }
    
    func deleteData(name: String, number: String) {
        let fetchRequest = PhoneBookData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND number == %@", name, number)
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                self.container.viewContext.delete(data)
            }
            
        } catch {
            print("데이터 삭제 실패", error)
        }
    }
}
