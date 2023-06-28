import ModernRIBs

/*
 RIBs에서는 ViewController는 그냥 View로 취급하고
 비즈니스로직은 Interactor에서 다룬다.
 따라서 Interactor는 모든 로직의 출발점이다.
 */

/*
 자식 리블렛을 붙이기 위해 Router에게 일을 시키려면 이 protocol에 먼저 선언해준다.
 */
protocol FinanceHomeRouting: ViewableRouting {
    
    /// SuperPayDashboard RIB 붙이기
    func attachSuperPayDashboard()
    func attachCardOnFileDashboard()
}

protocol FinanceHomePresentable: Presentable {
    var listener: FinanceHomePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FinanceHomeListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>, FinanceHomeInteractable, FinanceHomePresentableListener {
    
    weak var router: FinanceHomeRouting?
    weak var listener: FinanceHomeListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: FinanceHomePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    /*
     FinanceHome 리블렛이 RIBs Tree 구조에 처음으로 attach 되어 활성화 될 때 불리는 메서드
     
     여기서 FinanceHome의 자식 리블렛도 attach 시켜줍니다.
     attach 시키려면 Router에게 일을 시켜야 합니다.
     */
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        
        router?.attachSuperPayDashboard()
        router?.attachCardOnFileDashboard()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
