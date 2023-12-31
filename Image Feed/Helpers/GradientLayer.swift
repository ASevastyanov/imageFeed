//
//  GradientLayer.swift
//  Image Feed
//
//  Created by Alexandr Seva on 15.09.2023.
//

import UIKit

final class GradientLayer {
    static var shared = GradientLayer()
    private var animationLayers = [CALayer]()
    
    // MARK: - Functions
    func gradientLayer(view: UIView, width: Double, height: Double, cornerRadius: Double) {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = cornerRadius
        gradient.masksToBounds = true
        animationLayers.append(gradient)
        view.layer.addSublayer(gradient)
        addAnimation(gradient: gradient)
    }
    
    func gradientLayerTableView(view: UIView, width: Double, height: Double, cornerRadius: Double, origin: CGPoint) {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(origin: origin, size: CGSize(width: width, height: height))
        gradient.locations = [0, 0.1, 0.3]
        gradient.colors = [
            UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor,
            UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
            UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.cornerRadius = cornerRadius
        gradient.masksToBounds = true
        animationLayers.append(gradient)
        view.layer.addSublayer(gradient)
        addAnimation(gradient: gradient)
    }
    
    private func addAnimation(gradient: CAGradientLayer) {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.autoreverses = true
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0.1, 0.3]
        gradientChangeAnimation.toValue = [0, 0.8, 1]
        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }
    
    func removeFromSuperLayer(views: [UIView]) {
        views.forEach { view in
            guard let sublayers = view.layer.sublayers else { return }
            sublayers.forEach { layer in
                for layer in animationLayers where layer == layer {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    func animateLikeButton(_ sender: UIButton) {
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0,
                                options: .repeat) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                sender.transform = .init(scaleX: 1.25, y: 1.25)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                sender.transform = .identity
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2) {
                sender.transform = .init(scaleX: 1.25, y: 1.25)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.2) {
                sender.transform = .identity
            }
        }
    }
    
    func stopLikeButton(_ cell: ImagesListCell, photo: Photo) {
        UIView.transition(with: cell.likeButton,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            cell.setIsLiked(!photo.isLiked)
        })
        cell.likeButton.layer.removeAllAnimations()
    }
}
