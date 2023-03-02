//
//  Localizer.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/24/23.
//

import Foundation

final class Localizer {
    
    static let updateNotificationName = NSNotification.Name("localizaer.update")
    
    enum Language {
        case en
        case fr
    }
    
    static let shared = Localizer()
    
    private(set) var currentLanguage = Language.en
    
    private init() {
        if let lang = UserDefaults.standard.string(forKey: "i18n_language") {
            if lang == self.idnetifier(language: .en) {
                currentLanguage = .en
            }
            if lang == self.idnetifier(language: .fr) {
                currentLanguage = .fr
            }
        }
    }
    
    func set(language: Language) {
        let idnetifier = idnetifier(language: language)
        UserDefaults.standard.set(idnetifier, forKey: "i18n_language")
        
        self.currentLanguage = language
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Self.updateNotificationName, object: nil)
        }
    }
    
    func idnetifier(language: Language) -> String {
        switch language {
        case .en:
            return "en"
        case .fr:
            return "fr"
        }
    }
    
    func text(key: String) -> String? {
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        if let path = Bundle.main.path(forResource: lang, ofType: "lproj") {
            if let bundle = Bundle(path: path) {
                return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
            }
        }
        return nil
    }
    
}
