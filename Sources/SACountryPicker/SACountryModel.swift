//
//  SACountryModel.swift
//  CountryPickerDemo
//
//  Created by Stebin Alex on 04/02/21.
//

import Foundation

struct phoneCountryCode: Codable {
    let countryCode, countryEn, countryCN: String
    let phoneCode: Int

    enum CodingKeys: String, CodingKey {
        case countryCode = "country_code"
        case countryEn = "country_en"
        case countryCN = "country_cn"
        case phoneCode = "phone_code"
    }
}

typealias PhoneCountryCode = [phoneCountryCode]
typealias FlagIndices = [String: Int]
