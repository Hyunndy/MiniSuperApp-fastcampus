//
//  CardOnFileDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by hyunndy on 2023/06/29.
//

import ModernRIBs

protocol CardOnFileDashboardDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    
    var cardOnFileRepository: CardOnFileRepository { get }
}

/*
 
 여기서 API 통신에서 받은 스트림이 들어있는 CardOnFileDashboardInteractorDependency을 채택했는데,
 그렇다면 이 데이터는
 - 부모에서 받을건지?
 - 이 RIB에서 생성할건지?
 를 결정해야 한다.
 
 부모에서 받도록한다.
 */
final class CardOnFileDashboardComponent: Component<CardOnFileDashboardDependency>, CardOnFileDashboardInteractorDependency {
    var cardOnFileRepository: CardOnFileRepository {
        dependency.cardOnFileRepository
    }
    

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol CardOnFileDashboardBuildable: Buildable {
    func build(withListener listener: CardOnFileDashboardListener) -> CardOnFileDashboardRouting
}

final class CardOnFileDashboardBuilder: Builder<CardOnFileDashboardDependency>, CardOnFileDashboardBuildable {

    override init(dependency: CardOnFileDashboardDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: CardOnFileDashboardListener) -> CardOnFileDashboardRouting {
        let component = CardOnFileDashboardComponent(dependency: dependency)
        let viewController = CardOnFileDashboardViewController()
        let interactor = CardOnFileDashboardInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return CardOnFileDashboardRouter(interactor: interactor, viewController: viewController)
    }
}
