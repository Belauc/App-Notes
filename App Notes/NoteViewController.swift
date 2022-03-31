//
//  ViewController.swift
//  App Notes
//
//  Created by Sergey on 27.03.2022.
//

import UIKit

final class NoteViewController: UIViewController {

    @IBOutlet weak var doneButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var headerTitleTextField: UITextField!

    var state: State = .editEnable {
        didSet {
            updateInterface()
        }
    }
    let note = UserSettings.noteModel

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        saveData()
        doNextState()
    }

    // Следующее состояние
    func doNextState() {
        self.state = self.state.nextState // тригерит didSet обсервер
    }

    // Обновление интерфейса(Кнопки "Готово")
    func updateInterface() {
        switch state {
        case .editEnable:
            doneButtonOutlet.isEnabled = true
            doneButtonOutlet.title = "Готово"
        case .editDisable:
            view.endEditing(true)
            doneButtonOutlet.isEnabled = false
            doneButtonOutlet.title = ""
        }
    }

    func enableButtonForStartEditing() {
        state == .editDisable ? doNextState() : nil
    }

    // MARK: - Работа с UserDefaults
    // Сохраннеие данных в памяти
    func saveData() {
        note.title = headerTitleTextField.text
        note.body = bodyTextView.text
        UserSettings.noteModel = note
    }

    // Выгрузка данных из памяти
    func restoreData() {
        headerTitleTextField.text = note.title
        bodyTextView.text = note.body
    }

    private func configure() {
        setupDelegate()
        setupViews()
    }

    private func setupViews() {
        bodyTextView.becomeFirstResponder()
        updateInterface()
        restoreData()
    }

    private func setupDelegate() {
        bodyTextView.delegate = self
        headerTitleTextField.delegate = self
    }
}

// MARK: - Extensions
extension NoteViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        enableButtonForStartEditing()
    }
}

extension NoteViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        enableButtonForStartEditing()
    }
}
