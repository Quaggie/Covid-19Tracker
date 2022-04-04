//
//  CountryModel.swift
//  Data
//
//  Created by Jonathan Bijos on 01/04/20.
//  Copyright © 2020 DevsCarioca. All rights reserved.
//

public struct CountryModel: Codable {
    public let country: String
    public let countryInfo: CountryInfoModel
    public let cases: Int
    public let todayCases: Int
    public let deaths: Int
    public let todayDeaths: Int
    public let recovered: Int
    public let active: Int
}
