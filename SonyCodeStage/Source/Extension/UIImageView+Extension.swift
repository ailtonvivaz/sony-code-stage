//
//  UIImageView+Extension.swift
//  SonyCodeStage
//
//  Created by Ailton Vieira Pinto Filho on 01/11/20.
//

import UIKit

extension UIImageView {
    func setImageBy(url: String) {
        guard let url = URL(string: url) else { return }
        print(url)
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
        
    }
}
