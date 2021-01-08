//
//  MainViewController.swift
//  acaiaExpression
//
//  Created by 藤井 悠太 on 2021/01/03.
//  Copyright © 2021 藤井 悠太. All rights reserved.
//

import UIKit
import AcaiaSDK

class MainViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var searchScaleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        AcaiaManager.shared().enableBackgroundRecovery = true
        searchScaleButton.addTarget(self, action: #selector(tappedButton(_:)), for: .touchUpInside)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        _addAcaiaEventsObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        _removeAcaiaEventsObserver()
    }

    @objc
    private func tappedButton(_ sender: UIButton) {
        self.present(AcaiaScaleTableVC(), animated: true, completion: nil)
    }

}

// MARK: Observe acaia events
extension MainViewController {
    private func _addAcaiaEventsObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_onConnect(noti:)),
                                               name: NSNotification.Name(rawValue: AcaiaScaleDidConnected),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_onDisconnect(noti:)),
                                               name: NSNotification.Name(rawValue: AcaiaScaleDidDisconnected),
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_onWeight(noti:)),
                                               name: NSNotification.Name(rawValue: AcaiaScaleWeight),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(_onTimer(noti:)),
                                               name: NSNotification.Name(rawValue: AcaiaScaleTimer),
                                               object: nil)
    }

    private func _removeAcaiaEventsObserver() {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: Acaia Events
extension MainViewController {
    @objc private func _onConnect(noti: NSNotification) {
//        _updateScaleStatusUI()
        Toast.show("Success connection!", self.view)
    }
    @objc private func _onFailed(noti: NSNotification) {
//        _updateScaleStatusUI()
        Toast.show("Failed connection...", self.view)
    }
    
    @objc private func _onDisconnect(noti: NSNotification) {
//        _updateScaleStatusUI()
        Toast.show("Success disconnection.", self.view)
    }
    
    @objc private func _onWeight(noti: NSNotification) {
        let unit = noti.userInfo![AcaiaScaleUserInfoKeyUnit]! as! NSNumber
        let weight = noti.userInfo![AcaiaScaleUserInfoKeyWeight]! as! Float

        if unit.intValue == AcaiaScaleWeightUnit.gram.rawValue {
//            _weightLabel.text = String(format: "%.1f g", weight)
        } else {
//            _weightLabel.text = String(format: "%.4f oz", weight)
        }
    }

    @objc private func _onTimer(noti: NSNotification) {
        guard let time = noti.userInfo?["time"] as? Int else { return }
//        _timerLabel.text = String(format: "%02d:%02d", time/60, time%60)
//        _isTimerStarted = true;
    }
}
