//
//  PhoneBookData+CoreDataProperties.swift
//  PokemonPhoneBook
//
//  Created by 장상경 on 12/8/24.
//
//

import Foundation
import CoreData


extension PhoneBookData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneBookData> {
        return NSFetchRequest<PhoneBookData>(entityName: "PhoneBookData")
    }

    @NSManaged public var name: String?
    @NSManaged public var number: String?
    @NSManaged public var profile: Data?

}

extension PhoneBookData : Identifiable {

}
