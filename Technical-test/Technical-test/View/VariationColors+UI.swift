//
//  VariationColors+UI.swift
//  Technical-test
//
//  Created by Alexx on 31.03.2023.
//

import UIKit

// Mapping VariationColors to UIColor
extension VariationColors {
    var color: UIColor {
        switch self {
        case .green:
            return .green
        case .red:
            return .red
        }
    }
}
