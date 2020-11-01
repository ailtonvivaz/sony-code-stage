//
//  ServicesViewController.swift
//  SonyCodeStage
//
//  Created by livetouch on 01/11/20.
//

import UIKit
import StoreKit

class ServicesViewController: UIViewController {

    @IBOutlet weak var vincularButton: UIButton!
    @IBOutlet weak var vincularLabel: UILabel!
    @IBOutlet weak var continuarButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Integrações"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true

        vincularButton.addTarget(self, action: #selector(handleVincular), for: .touchUpInside)

        continuarButton.layer.cornerRadius = .cornerRadius
        continuarButton.addTarget(self, action: #selector(handleContinuar), for: .touchUpInside)
    }

    @objc func handleVincular() {
        SKCloudServiceController.requestAuthorization { status in
            if status == .authorized {
                self.vincularButton.isHidden = true
                self.vincularLabel.text = "Conectado"
                self.continuarButton.isEnabled = true
            }
        }
    }

    @objc func handleContinuar() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateInitialViewController() {
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }

    init() {
        super.init(nibName: "\(Self.self)", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
