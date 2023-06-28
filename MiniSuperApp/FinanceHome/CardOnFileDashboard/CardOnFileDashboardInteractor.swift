//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by hyunndy on 2023/06/29.
//

import ModernRIBs
import RxSwift

protocol CardOnFileDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
    var listener: CardOnFileDashboardPresentableListener? { get set }
    
    func update(with models: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

/*
 이 Interactor에서는 API 통신으로 받은 객체를 받아야한다!!
 
 Dependency로부터 API 객체의 스트림을 받으면, Interactor의 didBecomeActive에서 Subscribe해준다!!
 
 */
protocol CardOnFileDashboardInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>, CardOnFileDashboardInteractable, CardOnFileDashboardPresentableListener {

    let disposeBag = DisposeBag()
    
    weak var router: CardOnFileDashboardRouting?
    weak var listener: CardOnFileDashboardListener?
    
    private let dependency: CardOnFileDashboardInteractorDependency

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    
    
    init(presenter: CardOnFileDashboardPresentable, dependency: CardOnFileDashboardInteractorDependency) {
        self.dependency = dependency
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        /*
         API로부터 받은 데이터를 Presenter에게 넘겨줘야한다!!
         
         */
        dependency.cardOnFileRepository.cardOnFileRelay
            .subscribe(with: self, onNext: { owner, methods in
                
                let viewModel = methods.map(PaymentMethodViewModel.init)
                owner.presenter.update(with: viewModel)
            }).disposed(by: self.disposeBag)
            
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
