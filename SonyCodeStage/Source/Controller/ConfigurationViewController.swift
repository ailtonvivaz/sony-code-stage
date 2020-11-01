//
//  ConfigurationViewController.swift
//  SonyCodeStage
//
//  Created by livetouch on 01/11/20.
//

import UIKit

class ConfigurationViewController: UIViewController {
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var taskPicker: UIPickerView!
    @IBOutlet weak var feelingsPicker: UIPickerView!

    var moods: [Mood] = []
    var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        moods = Mood.allCases
        tasks = Task.allCases

        taskPicker.delegate = self
        taskPicker.dataSource = self

        feelingsPicker.delegate = self
        feelingsPicker.dataSource = self
    }

    @IBAction func handleContinuar(_ sender: Any) {
        if let vc = presentingViewController as? MainViewController {
            vc.setupMoodTask()
        }

        dismiss(animated: true)
    }

    init() {
        super.init(nibName: "\(Self.self)", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ConfigurationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == feelingsPicker {
            return moods.count
        }

        if pickerView == taskPicker {
            return tasks.count
        }

        return 0
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }

        label.textAlignment = .center
        label.textColor = UIColor(named: "tint2")
        label.font = UIFont.systemFont(ofSize: 26, weight: .regular)
        if pickerView == feelingsPicker {
            label.text = moods[row].rawValue
        } else {
            label.text = tasks[row].rawValue
        }
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == feelingsPicker {
            MusicPlayer.shared.mood = moods[row]
        } else {
            MusicPlayer.shared.task = tasks[row]
        }
    }

}
