//
//  UIViewController + Ext.swift
//  Bdc
//
//  Created by Francesco D'Angelo on 27/10/21.
//

import UIKit

extension UIViewController {
    /// Instantiate a view controller with a given identifier
    func getViewController(fromStoryboard storyboard: String, withIdentifier identifier: String) -> UIViewController {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: identifier)
    }

    /// Present alert with with action to dismiss it
    func presentAlert(alertText: String, alertMessage: String, actionTitle: String = "Ok!") {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        action.setValue(Theme.FSCalendarStandardSelectionColor, forKey: "titleTextColor")
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func presentActionSheet(title: String, message: String? = nil, mainAction: @escaping (UIAlertAction) -> Void, mainActionTitle: String,  cancelAction: @escaping (UIAlertAction) -> Void, cancelActionTitle: String = "Annulla") {
        
        let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let mainAction = UIAlertAction(title: mainActionTitle, style: .destructive, handler: mainAction)
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel,  handler: cancelAction)
        cancelAction.setValue(Theme.FSCalendarStandardSelectionColor, forKey: "titleTextColor")
        actionSheet.addAction(mainAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

//    static func presentWindow(with storyboard: UIStoryboard) {
//        DispatchQueue.main.async {
//            guard let viewController = storyboard.instantiateInitialViewController() else { return }
//            guard let window = UIApplication
//                .shared
//                .connectedScenes
//                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
//                .first { $0.isKeyWindow } { return }
//            window.rootViewController = viewController
//            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {}, completion: nil)
//        }
//    }
}
