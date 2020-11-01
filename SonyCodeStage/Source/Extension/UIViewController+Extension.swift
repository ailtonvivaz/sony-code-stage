//
//  UIViewController+Extension.swift
//  SonyCodeStage
//
//  Created by Ailton Vieira Pinto Filho on 31/10/20.
//

import UIKit

extension CGFloat {
    static var cornerRadius: CGFloat = 16
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}

extension UIViewController {
    static func loadFromNib() -> Self {
        Self.init(nibName: String(describing: Self.self), bundle: nil)
    }
}
