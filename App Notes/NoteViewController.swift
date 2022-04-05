//
//  ViewController.swift
//  App Notes
//
//  Created by Sergey on 27.03.2022.
//

import UIKit

enum State {
    case editEnable
    case editDisable
    var nextState: State {
        switch self {
        case .editEnable:
            return .editDisable
        case .editDisable:
            return .editEnable
        }
    }
}

final class NoteViewController: UIViewController {

    private var doneBarButton = UIBarButtonItem()
    private var bodyTextView = UITextView()
    private var headerTitleTextField = UITextField()
    private var dateTimeTextField = UITextField()
    private var state: State = .editEnable {
        didSet {
            updateUI()
        }
    }
    private let note = UserSettings.noteModel
    private let projectSettings = ProjectSettings.shared
    private let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // Следующее состояние
    func doNextState() {
        self.state = self.state.nextState // тригерит didSet обсервер
    }

    // Обновление интерфейса(Кнопки "Готово")
    func updateUI() {
        switch state {
        case .editEnable:
            doneBarButton.isEnabled = true
            doneBarButton.title = projectSettings.titleForDoneButton
        case .editDisable:
            view.endEditing(true)
            doneBarButton.isEnabled = false
            doneBarButton.title = ""
        }
    }

    func enableButtonForStartEditing() {
        state == .editDisable ? doNextState() : nil
    }

    private func getDateFromDatePicker() -> String {
        let dateFormater = projectSettings.dateFormater
        let date = datePicker.date
        return dateFormater.string(from: date)
    }

    @objc
    func doneButtonPressed() {
        saveData()
        checkTextFieldOnNil()
        doNextState()
    }

    @objc
    func changedDatePicker() {
        let date = getDateFromDatePicker()
        dateTimeTextField.text = date
    }

    // MARK: - Настройка Views
    private func configure() {
        setupDelegate()
        setupViews()
    }

    private func setupViews() {
        setupUIBase()
        setupUIHeader()
        setupUIDateTextField()
        setupUIBody()
        updateUI()
        restoreData()
    }

    // MARK: - Настройка констрейтов и тд. для HeaderTeftField
    private func setupUIHeader() {
        view.addSubview(headerTitleTextField)
        headerTitleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                  constant: projectSettings.marginTop).isActive = true
        headerTitleTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                   constant: projectSettings.marginLeft).isActive = true
        headerTitleTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                    constant: projectSettings.marginRight).isActive = true
        headerTitleTextField.font = UIFont.systemFont(ofSize: projectSettings.titleFontSize)
        headerTitleTextField.placeholder = projectSettings.placeholdeerForTitleNote
        headerTitleTextField.autocorrectionType = .no
        headerTitleTextField.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Настройка констрейтов и тд. для dateTeftField
    private func setupUIDateTextField() {
        dateTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateTimeTextField)
        dateTimeTextField.topAnchor.constraint(equalTo: headerTitleTextField.bottomAnchor,
                                                  constant: projectSettings.paddingTop).isActive = true
        dateTimeTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                   constant: projectSettings.marginLeft).isActive = true
        dateTimeTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                    constant: projectSettings.marginRight).isActive = true
        dateTimeTextField.font = UIFont.systemFont(ofSize: projectSettings.titleFontSize)
        dateTimeTextField.placeholder = projectSettings.placeholdeerForDatePicker
        dateTimeTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = projectSettings.locale
        datePicker.addTarget(self, action: #selector(changedDatePicker), for: .valueChanged)
    }

    // MARK: - Настройка констрейтов и тд. для bodyTeftField
    private func setupUIBody() {
        view.addSubview(bodyTextView)
        bodyTextView.topAnchor.constraint(equalTo: dateTimeTextField.bottomAnchor,
                                                  constant: projectSettings.paddingTop).isActive = true
        bodyTextView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                   constant: projectSettings.marginLeft).isActive = true
        bodyTextView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                    constant: projectSettings.marginRight).isActive = true
        bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bodyTextView.font = UIFont.systemFont(ofSize: projectSettings.bodyFontSize)
        bodyTextView.autocorrectionType = .no
        bodyTextView.becomeFirstResponder()
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Настройка общих views
    func setupUIBase() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        doneBarButton.target = self
        doneBarButton.action = #selector(doneButtonPressed)
        self.navigationItem.rightBarButtonItem = doneBarButton
    }

    // MARK: - Настройка делегатов
    private func setupDelegate() {
        bodyTextView.delegate = self
        headerTitleTextField.delegate = self
        dateTimeTextField.delegate = self
    }
}

// MARK: - Extensions для работы с делегатами
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

// MARK: - Extensions для работы с UserDefaults
extension NoteViewController {
    // Сохраннеие данных в памяти
    func saveData() {
        note.title = headerTitleTextField.text
        note.body = bodyTextView.text
        note.date = dateTimeTextField.text
        UserSettings.noteModel = note
    }

    // Выгрузка данных из памяти
    func restoreData() {
        headerTitleTextField.text = note.title
        bodyTextView.text = note.body
        dateTimeTextField.text = note.date
    }

}

// MARK: - Extensions для работы проверки на пустоту TextInput
extension NoteViewController {
    func checkTextFieldOnNil() {
        guard note.isEmtpy else { return }
        let alert = UIAlertController(title: projectSettings.titleAlertForCheckNil,
                                      message: projectSettings.messageAlertForCheckNil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
