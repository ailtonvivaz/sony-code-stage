//
//  UIViewController+Extension.swift
//  SonyCodeStage
//
//  Created by Ailton Vieira Pinto Filho on 31/10/20.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        Self.init(nibName: String(describing: Self.self), bundle: nil)
    }
}
