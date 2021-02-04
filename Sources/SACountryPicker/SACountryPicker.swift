//
//  SACountryPicker.swift
//  CountryPickerDemo
//
//  Created by Stebin Alex on 04/02/21.
//

import UIKit

public class SACountryPicker {



    private func jsonDataForPath(_ path: String) -> Data? {
        return Bundle.module.path(forResource: path, ofType: "json")?.data(using: .utf8)
    }

    private var countryInfos: PhoneCountryCode? {
        do {
            if let path = Bundle.module.path(forResource: "phone_country_code", ofType: "json") {
                return try JSONDecoder().decode(PhoneCountryCode.self, from: Data(contentsOf: URL(fileURLWithPath: path)))
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    private var flagIndices: FlagIndices? {
        do {
            if let path = Bundle.module.path(forResource: "flag_indices", ofType: "json") {
                return try JSONDecoder().decode(FlagIndices.self, from: Data(contentsOf: URL(fileURLWithPath: path)))
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

    public func imageForCountryCode(_ code: String) -> UIImage {
        var n = flagIndices?[code]
        n = n == nil ? 0 : n
        let fullImage = UIImage(contentsOfFile: Bundle.module.path(forResource: "flags", ofType: "png") ?? "")?.cgImage
        let cgImage: CGImage = (fullImage?.cropping(to:  CGRect(x: 0, y: n! * 2, width: 32, height: 32))!)!
        let result = UIImage(cgImage: cgImage, scale: 2.0, orientation: .up)
        return result
    }

    public func phoneCodeForCountryCode(_ code: String) -> Int? {
        return countryInfos?.filter {$0.countryCode == code}.first?.phoneCode
    }

    public func countryCodeForPhoneCode(_ code: Int) -> String? {
        return countryInfos?.filter {$0.phoneCode == code}.first?.countryCode
    }

    func countryList() -> PhoneCountryCode? {
        return countryInfos
    }

}



