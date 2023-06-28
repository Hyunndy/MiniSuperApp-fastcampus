//
//  SuperPayDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by hyunndy on 2023/06/28.
//

import ModernRIBs
import RxSwift

protocol SuperPayDashboardDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    
    var banlance: Observable<Double> { get }
}

/*
 그렇다면 이 "잔액" 데이터가 담긴게 어디서 와야할까..?
 1. Builder에서 새로 만들던지 -> DynamicRequired
 2. 부모 Component로 부터 받던지 -> StaticRequired

 둘 중 하나이다.
 
 하지만 SuperPayDashboard는 뷰를 담당하는데 더 치중된 RIB.
 따라서 여기서 직접 만드는 것 보다는 부모로부터 받아와야한다.
 
 부모로부터 받고싶은 데이터는 SUperPayDashBoardDependency에 정의한다.
 그러면 부모 RIB인 FinanceHomeBuilder에서 오류가 날 것 이고, 거기서 구현해주겠지

 */
final class SuperPayDashboardComponent: Component<SuperPayDashboardDependency>, SuperPayDashboardInteractorDependency {
    var balance: Observable<Double> {
        dependency.banlance
    }
    

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SuperPayDashboardBuildable: Buildable {
    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting
}

final class SuperPayDashboardBuilder: Builder<SuperPayDashboardDependency>, SuperPayDashboardBuildable {

    override init(dependency: SuperPayDashboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting {
        let component = SuperPayDashboardComponent(dependency: dependency)
        let viewController = SuperPayDashboardViewController()
        let interactor = SuperPayDashboardInteractor(presenter: viewController, interactorDependency: component)
        interactor.listener = listener
        return SuperPayDashboardRouter(interactor: interactor, viewController: viewController)
    }
}
