//
//  EmailValidator.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import Foundation

class EmailValidator {
    func isValid(_ text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text)
    }
}
