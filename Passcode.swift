//
//  Passcode.swift
//  MPFManager
//
//  Created by Cyrena Fong on 26/11/2019.
//  Copyright © 2019 EE4304. All rights reserved.
//

import UIKit
import LocalAuthentication
import Valet

public enum Constants {
    static let nibName = "Passcode"
    static let kPincode = "pincode"
    static let duration = 0.3
    static let maxPinLength = 4
    
    enum button: Int {
      case delete = 1000
      case cancel = 1001
    }
}

public struct Appearance {
  public var title: String?
  public var color: UIColor?
  public init() {}
}

public enum Mode {
  case validate
  case change
  case deactive
  case create
}

public class Passcode: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var pinIndicators: [Indicator]!
    @IBOutlet weak var cancel: UIButton!
    
    static let valet = Valet.valet(with: Identifier(nonEmpty: "Druidia")!, accessibility: .whenUnlockedThisDeviceOnly)
    
    private let context = LAContext()
    private var pin = ""
    private var reservedPin = "" //for confirmation
    private var isFirstCreationStep = true
    private var savedPin: String? {
      get {
        return Passcode.valet.string(forKey: Constants.kPincode)
      }
      set {
        guard let newValue = newValue else { return }
        Passcode.valet.set(string: newValue, forKey: Constants.kPincode)
      }
    }
    
    fileprivate var mode: Mode? {
      didSet {
        let mode = self.mode ?? .validate
        switch mode {
        case .create:
          messageLabel.text = "Create your passcode"
        case .change:
          messageLabel.text = "Enter your passcode"
        case .deactive:
          messageLabel.text = "Enter your passcode"
        case .validate:
          messageLabel.text = "Enter your passcode"
          cancel.isHidden = true
          isFirstCreationStep = false
        }
      }
    }
    
    private func precreateSettings () { // Precreate settings for change mode
      mode = .create
      clearView()
    }
    
    private func drawing(isNeedClear: Bool, tag: Int? = nil) {
      let results = pinIndicators.filter { $0.isNeedClear == isNeedClear }
      let pinView = isNeedClear ? results.last : results.first
      pinView?.isNeedClear = !isNeedClear
      
      UIView.animate(withDuration: Constants.duration, animations: {
        pinView?.backgroundColor = isNeedClear ? .clear : .gray
      }) { _ in
        isNeedClear ? self.pin = String(self.pin.dropLast()) : self.pincodeChecker(tag ?? 0)
      }
    }
    
    //
    private func pincodeChecker(_ pinNumber: Int) {
      if pin.count < Constants.maxPinLength {
        pin.append("\(pinNumber)")
        if pin.count == Constants.maxPinLength {
          switch mode ?? .validate {
          case .create:
            createModeAction()
          case .change:
             changeModeAction()
          case .deactive:
            deactiveModeAction()
          case .validate:
            validateModeAction()
          }
        }
      }
    }
    
    // MARK: - Modes
    private func createModeAction() {
      if isFirstCreationStep {
        isFirstCreationStep = false
        reservedPin = pin
        clearView()
        messageLabel.text = "Confirm your pincode"
      } else {
        confirmPin()
      }
    }
    
    private func changeModeAction() {
      pin == savedPin ? precreateSettings() : incorrectPinAnimation()
    }
    
    private func deactiveModeAction() {
      pin == savedPin ? removePin() : incorrectPinAnimation()
    }
    
    private func validateModeAction() {
    
        pin == savedPin ? dismiss(animated: true, completion: nil) : incorrectPinAnimation()
    }

    private func removePin() {
        Passcode.valet.removeObject(forKey: Constants.kPincode)
        dismiss(animated: true, completion: nil)
    }
    
    private func confirmPin() {
      if pin == reservedPin {
        savedPin = pin
        dismiss(animated: true, completion: nil)
      } else {
        incorrectPinAnimation()
      }
    }
    
    private func incorrectPinAnimation() {
      pinIndicators.forEach { view in
        view.shake(delegate: self)
        view.backgroundColor = .clear
      }
    }
    
    fileprivate func clearView() {
      pin = ""
      pinIndicators.forEach { view in
        view.isNeedClear = false
        UIView.animate(withDuration: Constants.duration, animations: {
          view.backgroundColor = .clear
        })
      }
    }
    
    
    @IBAction func input(_ sender: UIButton) {
        switch sender.tag {
          case Constants.button.delete.rawValue:
            drawing(isNeedClear: true)
            let temp = pin.dropLast()
            pin = String(temp)
          case Constants.button.cancel.rawValue:
            clearView()
            dismiss(animated: true, completion: nil)
          default:
            drawing(isNeedClear: false, tag: sender.tag)
          }
        }
    
}

extension Passcode: CAAnimationDelegate {
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    clearView()
  }
}

public extension Passcode {
  class func present(with mode: Mode, and config: Appearance? = nil) {
    guard let root = UIApplication.shared.keyWindow?.rootViewController,

      let pass = Bundle(for: self.classForCoder()).loadNibNamed(Constants.nibName, owner: self, options: nil)?.first as? Passcode else {
        return
    }
    pass.messageLabel.text = config?.title ?? ""
    pass.view.backgroundColor = config?.color ?? .white
    pass.mode = mode
    pass.modalPresentationStyle = .fullScreen
    
    root.present(pass, animated: true, completion: nil)
   
  }
}
