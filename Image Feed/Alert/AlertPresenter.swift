//
//  AlertPresenter.swift
//  Image Feed
//
//  Created by Alexandr Seva on 23.08.2023.
//

import UIKit

final class AlertPresenter {
    private weak var viewControler: UIViewController?
    
    init(viewControler: UIViewController? = nil) {
        self.viewControler = viewControler
    }
}

extension AlertPresenter: AlertPresenterProtocol {
    func showAlert(with model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.massage,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert presenter"
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        alert.addAction(action)
        viewControler?.present(alert, animated: true)
    }
}