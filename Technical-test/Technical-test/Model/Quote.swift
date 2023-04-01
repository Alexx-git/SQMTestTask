//
//  Quote.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 29.04.21.
//

import Foundation

enum VariationColors: String, Codable {
    case green, red
}

struct Quote: Codable {
    
    var symbol:String?
    var name:String?
    var currency:String?
    var readableLastChangePercent:String?
    var last:String?
    var variationColor: VariationColors?
    
    // TODO: this var is currenly not in use, may be it was added for the future, but for now it will be commented
//    var myMarket:Market?
}
