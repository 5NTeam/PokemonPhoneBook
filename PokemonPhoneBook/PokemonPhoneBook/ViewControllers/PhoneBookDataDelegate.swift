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
    
    func readSelectData(_ selectData: String) -> PhoneBookData?
    
    func updatePhoneNumber(currentName: String, currentNumber: String, updateName: String, updateNumber: String, updateImage: UIImage)
    
    func deleteData(name: String, number: String)
    
    func deleteAllData()
}

// MARK: - CoreData CRUD Method
extension PhoneBookDataDelegate {
    // 코어데이터와 연결하는 프로퍼티
    var container: NSPersistentContainer {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer
    }
    
    /// 코어데이터에 새로운 데이터를 저장하는 메소드
    /// - Parameters:
    ///   - name: 저장할 데이터 이름
    ///   - number: 저장할 데이터 번호
    ///   - profileImage: 저장할 데이터 이미지
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
    
    /// 코어 데이터의 모든 정보를 불러오는 메소드
    /// - Returns: JSON 디코딩 데이터 모델 배열
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
    
    /// 코어 데이터의 특정 정보를 불러오는 메소드
    /// - Parameter selectData: 찾을 데이터
    /// - Returns: JSON 디코딩 데이터 모델 데이터
    func readSelectData(_ selectData: String) -> PhoneBookData? {
        let fetchRequest = PhoneBookData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "number == %@", selectData)
        
        do {
            let fetchData = try self.container.viewContext.fetch(fetchRequest)
            
            guard let data = fetchData.first else { return nil }
            
            return data
            
        } catch {
            print("존재하지 않는 데이터 입니다", error)
            return nil
        }
    }
    
    /// 특정 데이터의 정보를 수정(updata)하는 메소드
    /// - Parameters:
    ///   - currentName: 수정 할 데이터 이름
    ///   - currentNumber: 수정 할 데이터 번호
    ///   - updateName: 새로운 이름
    ///   - updateNumber: 새로운 번호
    ///   - updateImage: 새로운 이미지
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
            
            try self.container.viewContext.save()
            print("데이터 업데이트 성공")
            
        } catch {
            print("업데이트 실패", error)
        }
    }
    
    /// 코어 데이터의 특정 데이터를 삭제하는 메소드
    /// - Parameters:
    ///   - name: 삭제할 데이터의 이름
    ///   - number: 삭제할 데이터의 번호
    func deleteData(name: String, number: String) {
        let fetchRequest = PhoneBookData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND number == %@", name, number)
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                self.container.viewContext.delete(data)
            }
            
            try self.container.viewContext.save()
            print("데이터 삭제 성공")
            
        } catch {
            print("데이터 삭제 실패", error)
        }
    }
    
    /// 코어 데이터의 모든 데이터를 삭제하는 메소드
    func deleteAllData() {
        do {
            let result = try self.container.viewContext.fetch(PhoneBookData.fetchRequest())
            
            for data in result as [NSManagedObject] {
                self.container.viewContext.delete(data)
            }
            
            try self.container.viewContext.save()
            print("데이터 전체 삭제 성공")
        } catch {
            print("데이터 전체 삭제 실패", error)
        }
    }
}
