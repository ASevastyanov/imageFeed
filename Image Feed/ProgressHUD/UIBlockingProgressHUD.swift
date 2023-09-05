//
//  UIBlockingProgressHUD.swift
//  Image Feed
//
//  Created by Alexandr Seva on 14.08.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    static var isShowing: Bool = false
    private static var window: UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first
                else {
                    return nil
                }
                return window
    }
    static func show() {
        isShowing = true
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    static func dismiss() {
        isShowing = false
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
