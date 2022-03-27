//
//  UserSettings.swift
//  App Notes
//
//  Created by Sergey on 27.03.2022.
//

import Foundation

enum SettingsKeys: String {
    case noteModel
}

final class UserSettings{
    
    static var noteModel: Note! {
        get{
            guard let savedData = UserDefaults.standard.object(forKey: SettingsKeys.noteModel.rawValue) as? Data, let decodedModel = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? Note else {
                return Note(title: "", body: "")
            }
            return decodedModel
        }
        set{
            let defaults = UserDefaults.standard
            let key = SettingsKeys.noteModel.rawValue
            
            if let userModel = newValue {
                if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: userModel, requiringSecureCoding: false){
                    defaults.set(saveData, forKey: key)
                }
            }
        }
    }
}
