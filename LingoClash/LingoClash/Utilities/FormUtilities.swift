//
//  FormUtilities.swift
//  LingoClash
//
//  Created by Ai Ling Hong on 29/3/22.
//

import UIKit

class FormUtilities {
    static func isEmailValid(_ password: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: password)
    }

    /// Check if password has at least 8 characters, contains a special character and a number.
    static func isPasswordValid(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }

    static func getTrimmedString(textField: UITextField) -> String {
        textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    static func validateFieldsNotEmpty(_ fields: FormFields) -> String? {
        let mirror = Mirror(reflecting: fields)
        for child in mirror.children {
            if let value = child.value as? String, value.isEmpty {
                return "Please fill in all fields."
            }
        }
        return nil
    }

    static func validateEmail(email: String) -> String? {
        if !isEmailValid(email) {
            return "Please input a valid email."
        }
        return nil
    }

    static func validatePassword(password: String) -> String? {
        // TODO: Reinstate after dev
        return nil
    }
}
