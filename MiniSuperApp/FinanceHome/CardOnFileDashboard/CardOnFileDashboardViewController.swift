//
//  CardOnFileDashboardViewController.swift
//  MiniSuperApp
//
//  Created by hyunndy on 2023/06/29.
//

import ModernRIBs
import UIKit

protocol CardOnFileDashboardPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class CardOnFileDashboardViewController: UIViewController, CardOnFileDashboardPresentable, CardOnFileDashboardViewControllable {
    
    
    weak var listener: CardOnFileDashboardPresentableListener?
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22.0, weight: .semibold)
        label.text = "카드 및 계좌"
        return label
    }()
    
    private let seeAllButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("충전하기", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(SuperPayDashboardViewController.self, action: #selector(seeAllButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private let cardOnFileStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = 12.0
        return stack
    }()
    
    private let plusButton: AddPaymentMethodButton = {
        let button = AddPaymentMethodButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray
        button.addTarget(SuperPayDashboardViewController.self, action: #selector(plusButtonButtonDidTap), for: .touchUpInside)
        return button
    }()
    
//    private let paymentMethodView = PaymentMethodView = {
//        let view = PaymentMethodView()
//        view.backgroundColor = .green
//        return view
//    }
    
    @objc
    func seeAllButtonDidTap() {
        
    }
    
    @objc
    func plusButtonButtonDidTap() {
        
    }
    
    func update(with models: [PaymentMethodViewModel]) {
        cardOnFileStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        
        // [PaymentMethodViewModel] -> [PaymentMethodView]
        let views = models.map(PaymentMethodView.init)
        views.forEach {
            cardOnFileStackView.addArrangedSubview($0)
        }
        
        cardOnFileStackView.addArrangedSubview(plusButton)
        
        let heightAnc = views.map { $0.heightAnchor.constraint(equalToConstant: 60) }
        NSLayoutConstraint.activate(heightAnc)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        view.addSubview(headerStackView)
        view.addSubview(cardOnFileStackView)
        
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(seeAllButton)
        
        cardOnFileStackView.addArrangedSubview(plusButton)
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cardOnFileStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            cardOnFileStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardOnFileStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardOnFileStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            plusButton.heightAnchor.constraint(equalToConstant: 60.0),
        ])
    }
}
