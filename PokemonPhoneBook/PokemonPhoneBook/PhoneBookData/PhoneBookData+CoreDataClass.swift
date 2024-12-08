//
//  PhoneBookData+CoreDataClass.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/8/24.
//
//

import Foundation
import CoreData

@objc(PhoneBookData)
public class PhoneBookData: NSManagedObject {
    static let className: String = "PhoneBookData"
    enum Key {
        static let name: String = "name"
        static let number: String = "number"
        static let profile: String = "profile"
    }
}
