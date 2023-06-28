//
//  PaymentModel.swift
//  MiniSuperApp
//
//  Created by hyunndy on 2023/06/29.
//

import Foundation

/**
 백엔드로부터 받는 데이터 모델
 */
struct PaymentMethod: Decodable {
    var id: String
    var name: String
    var digits: String
    var color: String
    var isPrimary: Bool
}

