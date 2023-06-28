//
//  SuperPayDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by hyunndy on 2023/06/28.
//

import ModernRIBs
import RxSwift

protocol SuperPayDashboardRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol SuperPayDashboardPresentable: Presentable {
    var listener: SuperPayDashboardPresentableListener? { get set }
    
    func updateBalance(with balance: String)
    
}

protocol SuperPayDashboardListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

/**
 Interactor에게 필요한 데이터.
 Builder에서 만들어질 때는 Component가 들어오게 된다.
 
 왜냐?
 Component는 본인과 자식의 리블렛이 필요한 것을 담는 바구니 이기 때문이다.
 */
protocol SuperPayDashboardInteractorDependency {
    var balance: Observable<Double> { get }
}

final class SuperPayDashboardInteractor: PresentableInteractor<SuperPayDashboardPresentable>, SuperPayDashboardInteractable, SuperPayDashboardPresentableListener {
    
    weak var router: SuperPayDashboardRouting?
    weak var listener: SuperPayDashboardListener?
    
    private let dependency: SuperPayDashboardInteractorDependency
    
    let disposeBag = DisposeBag()
    
    /**
     Interactor에게 필요한 데이터 == 잔액
     잔액을 얻기 위해서는 어딘가에서 Interactor에 전달해주어야 한다.
     
     그럼 쉽게생각했을 떄는 interactor의 생성자에 넣는게 맞는데,
     interactor의 생성자에 데이터를 생으로 넣게 되면 수정해야 할게 많으니까,
     InteractorRequired라는것을 만든다.
     */
    init(presenter: SuperPayDashboardPresentable, interactorDependency: SuperPayDashboardInteractorDependency) {
        self.dependency = interactorDependency
        
        super.init(presenter: presenter)
        presenter.listener = self
    }

    
    override func didBecomeActive() {
        super.didBecomeActive()
        
        
        /*
         여기서 부모 Component (FInanceHome)으로 부터 받은 Observable을 통해 uI를 업데이트할 수 있다.
         Interactor에서 UI를 업데이트 할 때는 presenter를 호출한다.
         따라서 SuperPayDashboardPresentable에 명령을 정의해야한다.
         */
        
        dependency.balance
            .subscribe(with: self, onNext: { owner, balance in
                owner.presenter.updateBalance(with: "\(balance)")
            })
            .disposed(by: disposeBag)
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
