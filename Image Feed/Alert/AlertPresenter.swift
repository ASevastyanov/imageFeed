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
    
    func showAlertTwoAction(with model: AlertModelTwoAction) {
        let alert = UIAlertController(
            title: model.title,
            message: model.massage,
            preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Alert presenter"
        
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        let actionCancel = UIAlertAction(title: model.buttonTextCancel, style: .cancel) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        alert.addAction(actionCancel)
        viewControler?.present(alert, animated: true)
    }
}
