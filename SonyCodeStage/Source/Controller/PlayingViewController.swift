//
//  PlayingViewController.swift
//  SonyCodeStage
//
//  Created by livetouch on 01/11/20.
//

import UIKit

class PlayingViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nextCoverImageView: UIImageView!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var songArtistLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ouvindo"

        setupTheme()
    }

    func setupTheme() {
        coverImageView.layer.cornerRadius = .cornerRadius
        nextCoverImageView.layer.cornerRadius = .cornerRadius
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playButton.layer.cornerRadius = playButton.frame.width/2
    }

    init() {
        super.init(nibName: "\(Self.self)", bundle: nil)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
