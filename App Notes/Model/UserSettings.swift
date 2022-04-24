//
//  UserDefaults.swift
//  App Notes
//
//  Created by Sergey on 23.04.2022.
//

import Foundation

final class UserSettings {
    private enum SettingsKeys: String {
        case noteModels
    }
    static var noteModel: [Note] {
        get {
            guard
                let savedData = UserDefaults.standard.object(forKey: SettingsKeys.noteModels.rawValue) as? Data,
                let decodedModels = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? [Note]
            else {
                return []
            }
            return decodedModels
        }

        set {
            let defaults = UserDefaults.standard
            let key = SettingsKeys.noteModels.rawValue
            if let saveData = try? NSKeyedArchiver.archivedData(
                withRootObject: newValue,
                requiringSecureCoding: false
            ) {
                defaults.set(saveData, forKey: key)
            }
        }
    }
}
