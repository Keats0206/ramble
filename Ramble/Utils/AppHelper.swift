//
//  AppHelper.swift
//  Ramble
//
//  Created by P..D..! on 13/11/20.
//  Copyright © 2020 Peter Keating. All rights reserved.
//

import UIKit
import SwiftUI

public class AppHelper {
    static func alert(title: String = "Error", message: String? = "", ok: String? = "OK", cancel: String? = nil, onCancel: (() -> Void)? = nil, onSuccess:( () -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if cancel ?? "" != "" {
            alert.addAction(UIAlertAction(title: cancel, style: .default, handler: { (action) -> Void in
                onCancel?()
            }))
        }
        if ok ?? "" != "" {
            alert.addAction(UIAlertAction(title: ok, style: (cancel == nil) ? .cancel : .default, handler: { (action) -> Void in
                onSuccess?()
            }))
        }
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
