//
//  structure.swift
//  Yard House
//
//  Created by Toshiyuki-iMac on 2/2/20.
//  Copyright © 2020 OnOuchs. All rights reserved.
//

import UIKit
import Alamofire

enum serviceType {
    case rental
    case lesson
    case camp
    case membership
    case hittrax
}



class registerUser : NSObject {
    static let sharedInstance = registerUser()
    var fullName = "" // "E" & "L"
    var email = "" // "U" & "F" & "G"
    var password = ""
    var phoneNumber = ""
}

// UserData

// MARK: - User

class UserData: Codable {
    let id: Int
    var name, email, phoneNumber, token ,stripeCustomerID: String
    var stripeCards: [StripeCard]
    var defaultCardID, emailVerifiedAt, createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, email,token
        case phoneNumber = "phone_number"
        case stripeCustomerID = "stripe_customer_id"
        case stripeCards = "stripe_cards"
        case defaultCardID = "default_card_id"
        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(id: Int, name: String, email: String, phoneNumber: String, stripeCustomerID: String, stripeCards: [StripeCard], defaultCardID: String, emailVerifiedAt: String, createdAt: String, updatedAt: String , token : String) {
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.stripeCustomerID = stripeCustomerID
        self.stripeCards = stripeCards
        self.defaultCardID = defaultCardID
        self.emailVerifiedAt = emailVerifiedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.token = token
    }
}

// MARK: - StripeCard
class StripeCard: Codable {
    let id, brand: String
    let expMonth, expYear: Int
    let last4: String

    enum CodingKeys: String, CodingKey {
        case id, brand
        case expMonth = "exp_month"
        case expYear = "exp_year"
        case last4
    }

    init(id: String, brand: String, expMonth: Int, expYear: Int, last4: String) {
        self.id = id
        self.brand = brand
        self.expMonth = expMonth
        self.expYear = expYear
        self.last4 = last4
    }
}

struct OTPDetails {
    
    var country_Code:String!
    var message:String!
    var phone_No:String!
    var otp_No:String!
    var user_Status:String!
    var flag_Img:UIImage!
    var mode:String!
    init(country_Code:String,phone_No:String,otp_No:String,message:String,user_Status:String,flag_Img:UIImage,mode:String){
        
        self.country_Code = country_Code
        self.message = message
        self.phone_No = phone_No
        self.otp_No = otp_No
        self.user_Status = user_Status
        self.flag_Img = flag_Img
        self.mode = mode
        
    }
}

struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}


//#MARK: Initial DataModel

class InitialData : Codable {
    let stripePublicKey: String
    let rental: Rental
    let lesson: Lesson
    let camps : [Camp]
    let membership : Membership

    enum CodingKeys: String, CodingKey {
        case stripePublicKey = "stripe_public_key"
        case rental, lesson ,camps , membership
    }

    init(stripePublicKey: String, rental: Rental, lesson: Lesson , camps : [Camp] , membership : Membership ) {
        self.stripePublicKey = stripePublicKey
        self.rental = rental
        self.lesson = lesson
        self.camps = camps
        self.membership = membership
    }
}

// MARK: - Lesson
class Lesson: Codable {
    let tags: [lessonTag]
    let items: [LessonItem]

    init(tags: [lessonTag], items: [LessonItem]) {
        self.tags = tags
        self.items = items
    }
}

// MARK: - LessonItem
class LessonItem: Codable {
    let id: Int
    let name, itemDescription: String
    let tags, providers: [String]
    let hasTimeRelatedPrice: Int
    let timePrice: [TimePrice]
    let uniquePrice: JSONNull?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case itemDescription = "description"
        case tags, providers
        case hasTimeRelatedPrice = "has_time_related_price"
        case timePrice = "time_price"
        case uniquePrice = "unique_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(id: Int, name: String, itemDescription: String, tags: [String], providers: [String], hasTimeRelatedPrice: Int, timePrice: [TimePrice], uniquePrice: JSONNull?, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.itemDescription = itemDescription
        self.tags = tags
        self.providers = providers
        self.hasTimeRelatedPrice = hasTimeRelatedPrice
        self.timePrice = timePrice
        self.uniquePrice = uniquePrice
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - TimePrice
class TimePrice: Codable {
    let label: String
    let max: Int
    let price: Double

    init(label: String, max: Int, price: Double) {
        self.label = label
        self.max = max
        self.price = price
    }
}

enum Price: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Price.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Price"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - Tag
class lessonTag: Codable {
    let id: Int
    let name: String
    let icon: String
    let createdAt, updatedAt: String
    let coaches: [Coach]
    let coachesData : Data

    enum CodingKeys: String, CodingKey {
        case id, name, icon , coaches , coachesData
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(id: Int, name: String, icon: String, createdAt: String, updatedAt: String , coaches : [Coach] , coachesData : Data) {
        self.id = id
        self.name = name
        self.icon = icon
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.coaches = coaches
        self.coachesData = coachesData
    }
}

class Tag: Codable {
    let id: Int
    let name: String
    let icon: String
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, icon
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(id: Int, name: String, icon: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.icon = icon
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
}

// MARK: - Rental
class Rental: Codable {
    let tags: [Tag]
    let items: [RentalItem]

    init(tags: [Tag], items: [RentalItem]) {
        self.tags = tags
        self.items = items
    }
}

// MARK: - RentalItem
class RentalItem: Codable {
    let id: Int
    let name, itemDescription: String
    let rentalTags, rentalProviders: [String]
    let hasTimeRelatedPrice, hasNumberRelatedPrice: Int
    let timeOptions, numberOptions: [Option]
    let priceOptions: [[PriceOption]]
    let uniquePrice: JSONNull?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case itemDescription = "description"
        case rentalTags = "rental_tags"
        case rentalProviders = "rental_providers"
        case hasTimeRelatedPrice = "has_time_related_price"
        case hasNumberRelatedPrice = "has_number_related_price"
        case timeOptions = "time_options"
        case numberOptions = "number_options"
        case priceOptions = "price_options"
        case uniquePrice = "unique_price"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(id: Int, name: String, itemDescription: String, rentalTags: [String], rentalProviders: [String], hasTimeRelatedPrice: Int, hasNumberRelatedPrice: Int, timeOptions: [Option], numberOptions: [Option], priceOptions: [[PriceOption]], uniquePrice: JSONNull?, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.itemDescription = itemDescription
        self.rentalTags = rentalTags
        self.rentalProviders = rentalProviders
        self.hasTimeRelatedPrice = hasTimeRelatedPrice
        self.hasNumberRelatedPrice = hasNumberRelatedPrice
        self.timeOptions = timeOptions
        self.numberOptions = numberOptions
        self.priceOptions = priceOptions
        self.uniquePrice = uniquePrice
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Option
class Option: Codable {
    let label: String
    let max: Int

    init(label: String, max: Int) {
        self.label = label
        self.max = max
    }
}

// MARK: - PriceOption
class PriceOption: Codable {
    let price: Int
    let enabled: Bool

    init(price: Int, enabled: Bool) {
        self.price = price
        self.enabled = enabled
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

//coaches part

// MARK: - Welcome
//class Welcome: Codable {
//    let coaches: [Coach]
//
//    init(coaches: [Coach]) {
//        self.coaches = coaches
//    }
//}

// MARK: - Coach
class Coach: Codable {
    let id: Int
    let name, email, phone: String
    let profilePicture: String
    let dailyHours: [DailyHour]
    let lessonTags: [String]
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone
        case profilePicture = "profile_picture"
        case dailyHours = "daily_hours"
        case lessonTags = "lesson_tags"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(id: Int, name: String, email: String, phone: String, profilePicture: String, dailyHours: [DailyHour], lessonTags: [String], createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.profilePicture = profilePicture
        self.dailyHours = dailyHours
        self.lessonTags = lessonTags
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - DailyHour
class DailyHour: Codable {
    let dayTitle, beginTime, endTime: String

    enum CodingKeys: String, CodingKey {
        case dayTitle = "day_title"
        case beginTime = "begin_time"
        case endTime = "end_time"
    }

    init(dayTitle: String, beginTime: String, endTime: String) {
        self.dayTitle = dayTitle
        self.beginTime = beginTime
        self.endTime = endTime
    }
}

class Camp: Codable {
    let id: Int
    let name: String
    let price, maxPlayerNumber: Int
    let beginDate, endDate, age: String
    let campDescription: String?
    let campHours: [CampHour]
    let image: String
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, price
        case maxPlayerNumber = "max_player_number"
        case beginDate = "begin_date"
        case endDate = "end_date"
        case age
        case campDescription = "description"
        case campHours = "camp_hours"
        case image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(id: Int, name: String, price: Int, maxPlayerNumber: Int, beginDate: String, endDate: String, age: String, campDescription: String?, campHours: [CampHour], image: String, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.price = price
        self.maxPlayerNumber = maxPlayerNumber
        self.beginDate = beginDate
        self.endDate = endDate
        self.age = age
        self.campDescription = campDescription
        self.campHours = campHours
        self.image = image
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - CampHour
class CampHour: Codable {
    let day: Int
    let startTime, endTime: String

    enum CodingKeys: String, CodingKey {
        case day
        case startTime = "start_time"
        case endTime = "end_time"
    }

    init(day: Int, startTime: String, endTime: String) {
        self.day = day
        self.startTime = startTime
        self.endTime = endTime
    }
}

// MARK: - Membership
class Membership: Codable {
    let mvps, platinums: [MVP]

    init(mvps: [MVP], platinums: [MVP]) {
        self.mvps = mvps
        self.platinums = platinums
    }
}

// MARK: - MVP
class MVP: Codable {
    let id: Int
    let name: String
    let price, interval, duration: Int
    let subscriptionType, membershipKind: String
    let planID: String?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, price, interval, duration
        case subscriptionType = "subscription_type"
        case membershipKind = "membership_kind"
        case planID = "plan_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    init(id: Int, name: String, price: Int, interval: Int, duration: Int, subscriptionType: String, membershipKind: String, planID: String?, createdAt: String, updatedAt: String) {
        self.id = id
        self.name = name
        self.price = price
        self.interval = interval
        self.duration = duration
        self.subscriptionType = subscriptionType
        self.membershipKind = membershipKind
        self.planID = planID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

