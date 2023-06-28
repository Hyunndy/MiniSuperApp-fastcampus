import ModernRIBs
import RxSwift
import RxRelay

protocol FinanceHomeDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

/*
 자식인 SuperPayDashboard에서 잔액이 필요하다.
 이 RIB에서 직접 생성해서 넘겨줄건데,
 두 가지 정보가 있다.
 - 자식에게 줄 변경 불가 Observable
 - 내가 갖고있을 값 변경 가능 BehaviorRelay
 
 자식인 CardDashboard에서 API에서 받아온 PaymentMethod 리스트가 필요하다.
 여기서 API 구현 객체를 생성해서 넘겨준다!
 
 */
final class FinanceHomeComponent: Component<FinanceHomeDependency>, SuperPayDashboardDependency, CardOnFileDashboardDependency {
    
    var banlance: Observable<Double> {
        return balanceRelay.asObservable()
    }
    
    private let balanceRelay: BehaviorRelay<Double>
    var cardOnFileRepository: CardOnFileRepository
    
    
    init(
        dependency: FinanceHomeDependency,
        balanceRelay: BehaviorRelay<Double>,
        cardOnFileRepository: CardOnFileRepository) {
            self.balanceRelay = balanceRelay
            self.cardOnFileRepository = cardOnFileRepository
            super.init(dependency: dependency)
        }
    
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
    
    override init(dependency: FinanceHomeDependency) {
        super.init(dependency: dependency)
    }
    
    /*
     SuperPayDashboard 리블렛을 추가하기 위해 SPD의 Builder를 생성해준다.
     */
    func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
        
        /*
         필요한 데이터를 받는 방법에는 2가지가 있다고 했다.
         1. 부모로부터 받거나
         2. 직접 생성하기
         
         부모로부터 받고싶으면 Dependency 프로토콜에 정의하면 되고,
         직접 생성하고 싶으면 Component의 생성자에 넣자.
         
         */
        let balanceRelay = BehaviorRelay<Double>(value: 1000.0)
        
        
        /*
         Component는..?
         리블렛에게 필요한 객체들을 담는 바구니의 개념.
         이 리블렛은 자식 리블렛이 필요한것들도 담을 수 있는 바구니 입니다.
         그래서 자식들의 Dependency를 Component가 Conform 하도록 한다.
         
         */
        
        /*
         API 구현체인 Imp도 여기서 구현체를 직접! 만들어서 넣어진다.
         */
        let component = FinanceHomeComponent(
            dependency: dependency,
            balanceRelay: balanceRelay,
            cardOnFileRepository: CardOnFileRepositoryImp()
        )
        let viewController = FinanceHomeViewController()
        let interactor = FinanceHomeInteractor(presenter: viewController)
        interactor.listener = listener
        
        /*
         Builder의 생성자는 Dependency를 인자로 받는다.
         Dependency는 해당 리블렛이 동작하는데 필요한 객체를 담고있다.
         */
        
        let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
        let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
        
        return FinanceHomeRouter(
            interactor: interactor,
            viewController: viewController,
            superPayDashboardBuilable: superPayDashboardBuilder,
            cardOnFileDashboardBuildale: cardOnFileDashboardBuilder)
    }
}
