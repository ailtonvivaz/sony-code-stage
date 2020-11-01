//
//  ViewController.swift
//  SonyCodeStage
//
//  Created by Ailton Vieira Pinto Filho on 31/10/20.
//

import UIKit

class MainViewController: UIViewController {
    var gradientLayer: CAGradientLayer!

    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var innerCircleView: UIView!
    @IBOutlet weak var logoImage: UIImageView!

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bpmStack: UIStackView!
    @IBOutlet weak var thumbView : UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var moodTaskButton: UIButton!

    @IBOutlet weak var stepLabel: UILabel!

    var step : Int = 0 {
        didSet {
            if oldValue != self.step {
                setupStep(step: step)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bpmStack.alpha = 0
        self.thumbView.isHidden = true

        setupGradient()
        setupTheme()

        bottomConstraint.constant = view.frame.height/2

        setupPulseAnimation()

        circleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleNext)))

        thumbView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))

        thumbImageView.image = UIImage(named: "logo")?.withRenderingMode(.alwaysTemplate)

        setupProgress(progress: 0.5)
        stepLabel.isHidden = true

        setupMoodTask()
    }

    func setupMoodTask() {
        if let mood = MusicPlayer.shared.mood, let task = MusicPlayer.shared.task {
            moodTaskButton.setTitle("\(task.rawValue) & \(mood.rawValue)", for: .normal)
        } else {
            DispatchQueue.main.async {
                let vc = ConfigurationViewController()
                self.present(vc, animated: true)
            }
        }
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let gesture = gesture.location(in: circleView)
        setupProgress(progress: gesture.x/circleView.frame.width)
    }

    func setupProgress(progress: CGFloat) {
        let minAngle = CGFloat(5.0).degreesToRadians
        let maxAngle = CGFloat.pi-minAngle
        let angle = min(max(minAngle, progress * CGFloat.pi), maxAngle)
        let y = sin(angle) * ((innerCircleView.frame.height + thumbView.frame.width/2)/2)
        let x = cos(angle) * ((innerCircleView.frame.width + thumbView.frame.width/2)/2)
        thumbView.transform = CGAffineTransform(translationX: -x, y: -y)

        let step = (maxAngle - minAngle)/4
        self.step = Int(round((angle - minAngle) / step))
    }

    func setupStep(step: Int) {

        switch step {
        case 0:
            thumbImageView.tintColor = UIColor(named: "tint2")
            stepLabel.text = "Diminua bastante meu ritmo"
        case 1:
            thumbImageView.tintColor = UIColor(named: "color1")
            stepLabel.text = "Diminua meu ritmo"
        case 2:
            //Mantenha ritmo
            thumbImageView.tintColor = UIColor(named: "color2")
            stepLabel.text = "Mantenha meu ritmo"
        case 3:
            thumbImageView.tintColor = UIColor(named: "color2")
            stepLabel.text = "Acelere meu ritmo"
        case 4:
            thumbImageView.tintColor = UIColor(named: "color3")
            stepLabel.text = "Acelere bastante meu ritmo"
        default:
            return
        }

        thumbView.layer.shadowColor = UIColor.gray.cgColor
        thumbView.layer.shadowOffset = .init(width: 1, height: 2)
        thumbView.layer.shadowOpacity = 0.3
        thumbView.layer.shadowRadius = 5

        thumbView.backgroundColor = UIColor(named: "tint")
        stepLabel.alpha = 0

        UIView.animate(withDuration: 0.5) {
            self.stepLabel.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 2, options: []) {
                self.stepLabel.alpha = 0
            }
        }

    }

    @objc func handleNext() {
        let vc = PlayingViewController()
        (self.children.first as? UINavigationController)?.pushViewController(vc, animated: true)

        bottomConstraint.constant = 0
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
            self.logoImage.alpha = 0
        } completion: { _ in
            self.thumbView.isHidden = false
            self.stepLabel.isHidden = false
            self.stepLabel.alpha = 0
            self.logoImage.isHidden = true
            self.innerCircleView.layer.removeAllAnimations()

            UIView.animate(withDuration: 0.5) {
                self.bpmStack.alpha = 1
            }
        }

    }

    func setupTheme() {
        innerCircleView.backgroundColor = UIColor(named: "tint")

        circleView.layer.masksToBounds = true
        circleView.clipsToBounds = true
    }

    override func viewDidLayoutSubviews() {
        gradientLayer.frame = circleView.bounds
        circleView.layer.cornerRadius = circleView.frame.width/2
        innerCircleView.layer.cornerRadius = innerCircleView.frame.width/2

        thumbView.layer.cornerRadius = thumbView.frame.width/2
    }

    func setupGradient() {
        gradientLayer = CAGradientLayer()

        let colors = [UIColor(named: "tint2")!, UIColor(named: "color1")!, UIColor(named: "color2")!, UIColor(named: "color3")]

        gradientLayer.colors = colors.map { $0?.cgColor }
        gradientLayer.locations = [0.0, 0.25, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = circleView.bounds

        gradientLayer.masksToBounds = true
        circleView.layer.insertSublayer(gradientLayer, at: 0)
    }

    func setupPulseAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.9
        pulseAnimation.fromValue = 0.9
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        self.innerCircleView.layer.add(pulseAnimation, forKey: "pulseAnimation")
    }

}

