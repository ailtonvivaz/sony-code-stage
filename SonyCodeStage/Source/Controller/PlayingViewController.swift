//
//  PlayingViewController.swift
//  SonyCodeStage
//
//  Created by livetouch on 01/11/20.
//

import UIKit

class PlayingViewController: UIViewController {
    @IBOutlet var playButton: UIButton!
    @IBOutlet weak var coverContainerView: UIView!
    @IBOutlet var coverImageView: UIImageView!
    @IBOutlet var nextCoverImageView: UIImageView!
    @IBOutlet var forwardButton: UIButton!
    @IBOutlet var songNameLabel: UILabel!
    @IBOutlet var songArtistLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ouvindo"

        setupTheme()
        
        MusicPlayer.shared.onChangeSong = { song in
            DispatchQueue.main.async {
                self.coverImageView.setImageBy(url: song.coverURL)
                self.songNameLabel.text = song.name
                self.songArtistLabel.text = song.artistName
            }
        }
        
        MusicPlayer.shared.onChangeNextSong = { song in
            DispatchQueue.main.async {
                self.nextCoverImageView.setImageBy(url: song.coverURL)
            }
        }
        
        MusicPlayer.shared.search()
    }

    func setupTheme() {
        coverContainerView.layer.cornerRadius = .cornerRadius
        coverImageView.layer.cornerRadius = .cornerRadius
        nextCoverImageView.layer.cornerRadius = .cornerRadius
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playButton.layer.cornerRadius = playButton.frame.width / 2
    }

    init() {
        super.init(nibName: "\(Self.self)", bundle: nil)
        navigationItem.setHidesBackButton(true, animated: false)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func onClickPlayPause(_ sender: Any) {
        if MusicPlayer.shared.isPlaying {
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
        MusicPlayer.shared.playPause()
    }

    @IBAction func onClickNext(_ sender: Any) {
        MusicPlayer.shared.next()
    }
}
