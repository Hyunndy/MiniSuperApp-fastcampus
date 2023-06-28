import ModernRIBs

/*
 Router는 리블렛간의 이동을 담당하는 객체 입니다.
 RIBs의 Tree 구조를 구성하는 역할도 담당합니다.
 이 말은, 자식리블렛을 뗏다 붙였다 하는것을 Router가 한다는 것 입니다.
 
 자식 리블렛의 Builder를 생성하고, Builder의 build()를 호출해 ROuter을 받습니다.
 
 */

protocol FinanceHomeInteractable: Interactable, SuperPayDashboardListener, CardOnFileDashboardListener {
    var router: FinanceHomeRouting? { get set }
    var listener: FinanceHomeListener? { get set }
}

protocol FinanceHomeViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>, FinanceHomeRouting {

    
    
    /*
     // TODO: Constructor inject child builder protocols to allow building children.
     
     자식 리블렛을 넣어주기 위해서는...
     Builder는 Buildable이라는 인터페이스를 받고있는데, 이 Router에서 Buildable 프로토콜 타입으로 받도록 수정이 필요하다~
     */
    private var superPayDashboardBuildable: SuperPayDashboardBuildable
    private var cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
    
    // child 중복 attach 방지용
    private var superPayRouting: Routing?
    private var cardOnFileRouting: Routing?
    
    init(
        interactor: FinanceHomeInteractable,
        viewController: FinanceHomeViewControllable,
        superPayDashboardBuilable: SuperPayDashboardBuildable,
        cardOnFileDashboardBuildale: CardOnFileDashboardBuildable
    ) {
        self.superPayDashboardBuildable = superPayDashboardBuilable
        self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildale
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    
    /*
     SPD를 FinanceHome에 붙여주기 위해 router에서 attachChild()를 시켜줘야한다.
     attach시켜주기 위해 자식 리블렛의 router에서 ViewController를 가져온다.
     
     여기서 SPD의 viewController는 Present 할 게 아니고, FinanceHomeViewController의
     subView로 들어갈 것이다.
     이를 위해 FinanceHomeViewControllable에 인터페이스를 하나 추가해줘야한다.
     
     FinanceHomeVC의 stackView에 SPD의 view를 추가해주었다면 (addDashboard)
     
     최종적으로 FinanceHome 리블렛에 SPD 리블렛을 attachChild 시켜준다.
     */
    func attachSuperPayDashboard() {
        if superPayRouting != nil { return }
        
        let router = superPayDashboardBuildable.build(withListener: interactor)
        
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
       
        /*
         똑같은 자식을 2번 attach하지 않기 위해 방어 로직을 추가해줘야 합니다.
         */
        self.superPayRouting = router
        attachChild(router)
    }
    
    func attachCardOnFileDashboard() {
        if cardOnFileRouting != nil { return }
        
        let router = cardOnFileDashboardBuildable.build(withListener: interactor)
        
        let dashboard = router.viewControllable
        viewController.addDashboard(dashboard)
       
        /*
         똑같은 자식을 2번 attach하지 않기 위해 방어 로직을 추가해줘야 합니다.
         */
        self.cardOnFileRouting = router
        attachChild(router)
    }
    
}
