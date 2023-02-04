//
//  UIViewController+Extension.swift
//  IMDBClone
//
//  Created by Mina on 04/02/2023.
//

import Foundation
import UIKit
import ProgressHUD

extension UIViewController {
    func showAlert( _ message: String ) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showprogress() {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.show()
    }
    
    func hideProgress() {
        ProgressHUD.dismiss()
    }
}
