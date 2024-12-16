//
//  CoreDataManger.swift
//  PokemonPhoneBook
//
//  Created by 내일배움캠프 on 12/11/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: PokemonPhoneBook.className)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func createPhoneBook(name: String, phoneNumber: String, image: UIImage?) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: PokemonPhoneBook.className, in: context)
        let phoneBook = NSManagedObject(entity: entity!, insertInto: context)
        phoneBook.setValue(name, forKey: PokemonPhoneBook.Key.name)
        phoneBook.setValue(phoneNumber, forKey: PokemonPhoneBook.Key.phoneNumber)
        
        if let imageData = image?.pngData() {
            phoneBook.setValue(imageData, forKey: PokemonPhoneBook.Key.image)
        }
        
        do {
            try context.save()
            return true
        } catch {
            print("Failed to save phone book: \(error)")
            return false
        }
    }
    
    func fetchPhoneBooks() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: PokemonPhoneBook.className)
        let sortDescriptor = NSSortDescriptor(key: PokemonPhoneBook.Key.name, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch phone books: \(error)")
            return []
        }
    }
    
    func updatePhoneBook(phoneBook: NSManagedObject, name: String, phoneNumber: String, image: UIImage?) -> Bool {
        phoneBook.setValue(name, forKey: PokemonPhoneBook.Key.name)
        phoneBook.setValue(phoneNumber, forKey: PokemonPhoneBook.Key.phoneNumber)
        if let imageData = image?.pngData() {
            phoneBook.setValue(imageData, forKey: PokemonPhoneBook.Key.image)
        }
        do {
            try context.save()
            return true
        } catch {
            print("Failed to update phone book: \(error)")
            return false
        }
    }
    
    func deletePhoneBook(phoneBook: NSManagedObject) -> Bool {
        context.delete(phoneBook)
        do {
            try context.save()
            return true
        } catch {
            print("Failed to delete phone book: \(error)")
            return false
        }
    }
}
