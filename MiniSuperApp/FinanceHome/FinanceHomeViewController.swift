import ModernRIBs
import UIKit

protocol FinanceHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class FinanceHomeViewController: UIViewController, FinanceHomePresentable, FinanceHomeViewControllable {
    
    weak var listener: FinanceHomePresentableListener?
    
    private lazy var stackView: UIStackView = {
      let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 4.0
        return stackView
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
    }
    
    /*
     Root 리블렛에서 자식 리블렛을 붙이려면
     1) 자식 리블렛의 Builder를 만든다. (이 객체 생성은 부모의 Bilder에서 한다.)
     2) 자식 리블렛의 Buinder.build()를 통해 Router을 받는다.
     3) attachChild()를 호출한다.
     4) ViewController를 호출한다.
     
     */
    func setupViews() {
        title = "슈퍼페이"
        tabBarItem = UITabBarItem(title: "슈퍼페이", image: UIImage(systemName: "creditcard"), selectedImage: UIImage(systemName: "creditcard.fill"))
        view.backgroundColor = .white
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    /*
     SPD라는 자식 리블렛의 ViewController는 present하는게 아닌 이 View의 subView로 들어가야하기 때문에
     FinanceHomeViewControllable에 addDashboard 함수를 추가해주었다.
     */
    func addDashboard(_ view: ViewControllable) {
        
        // 먼저 viewControllable을 통해 VC를 받아온다.
        let vc = view.uiviewController
        
        // 이걸 FinanceHomeVC의 childViewController로 추가해준다.
        // (UIKit 함수임)
        addChild(vc)
        stackView.addArrangedSubview(vc.view)
        
        // childVC의 didMove를 호출해줘야 lifeCycle 유지 가능
        vc.didMove(toParent: self)
    }
}
