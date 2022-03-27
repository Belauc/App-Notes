//
//  ViewController.swift
//  App Notes
//
//  Created by Sergey on 27.03.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var doneButtonOutlet: UIButton!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var headerTitleTextField: UITextField!
    
    var state : State = .editEnable {
        didSet {
            updateInterface()
        }
    }
    let note = UserSettings.noteModel
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyTextView.becomeFirstResponder()
        updateInterface()
        bodyTextView.delegate = self
        headerTitleTextField.delegate = self
        restoreData()
    }

    @IBAction func DoneButtonPressed(_ sender: UIButton) {
        saveData()
        doNextState()
    }
    
    //Следующее состояние
    func doNextState() {
        self.state = self.state.nextState // тригерит didSet обсервер
    }
    
    // Обновление интерфейса(Кнопки "Готово")
    func updateInterface() {
        switch state {
        case .editEnable:
            doneButtonOutlet.isEnabled = true
            doneButtonOutlet.setTitle("Готово", for: .normal)
        case .editDisable:
            view.endEditing(true)
            doneButtonOutlet.isEnabled = false
            doneButtonOutlet.setTitle("", for: .disabled)
        }
    }
    
    func enableButtonForStartEditing() {
        state == .editDisable ? doNextState() : nil
    }
    
    // Сохраннеие данных в памяти
    func saveData() {
        note?.title = headerTitleTextField.text ?? ""
        note?.body = bodyTextView.text ?? ""
        UserSettings.noteModel = note
    }
    
    // Выгрузка данных из памяти
    func restoreData() {
        headerTitleTextField.text = note?.title
        bodyTextView.text = note?.body
    }
}

// MARK: Extensions
extension ViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        enableButtonForStartEditing()
    }
    
}
extension ViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        enableButtonForStartEditing()
    }
}

