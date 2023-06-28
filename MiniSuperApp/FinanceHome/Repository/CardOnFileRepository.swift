//
//  CardOnFileRepository.swift
//  MiniSuperApp
//
//  Created by hyunndy on 2023/06/29.
//

import Foundation
import RxSwift
import RxRelay

/**
 백엔드로부터 데이터를 받아올 객체
 
 왜 프로토콜로 만드는걸까?
 서버 API를 호출해서 유저의 정보 가져오기/
 
 카드 목록이 필요한 곳에서 이 프로토콜을 conform하게 하기 위해..
 
 이 Repository의 최종 목표가 무엇이냐?
 Interactor에서 이 값을 읽어서 사용하는것이다.
 
 -> CardOnFileDashboardInteractorDependency
 */

protocol CardOnFileRepository {
    var cardOnFileRelay: BehaviorRelay<[PaymentMethod]> { get }
}

final class CardOnFileRepositoryImp: CardOnFileRepository {
    var cardOnFileRelay: RxRelay.BehaviorRelay<[PaymentMethod]> {
        paymentRelay
    }
    
    private let paymentRelay = BehaviorRelay<[PaymentMethod]>(value: [
            PaymentMethod(id: "0", name: "우리은행", digits: "0123", color: "#f19a38ff", isPrimary: false),
            PaymentMethod(id: "1", name: "신한카드", digits: "0987", color: "#3478f6ff", isPrimary: false),
            PaymentMethod(id: "2", name: "현대카드", digits: "8121", color: "#78c5f5ff", isPrimary: false),
            PaymentMethod(id: "3", name: "국민은행", digits: "2812", color: "#65c466ff", isPrimary: false),
            PaymentMethod(id: "4", name: "카카오뱅크", digits: "8751", color: "#ffcc00ff", isPrimary: false)
    ])
}
