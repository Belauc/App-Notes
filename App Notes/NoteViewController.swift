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
    private let datePicker = UIDatePicker()
    private enum UiSettings {
        static let marginTop: CGFloat = 35
        static let marginLeft: CGFloat = 20
        static let marginRight: CGFloat = -20
        static let paddingTop: CGFloat = 10
        static let titleFontSize: CGFloat = 22
        static let bodyFontSize: CGFloat = 14
        static let placeholdeerForTitleNote = "Заголовок"
        static let titleForDoneButton = "Готово"
        static let titleAlertForCheckNil = "Внимание"
        static let messageAlertForCheckNil = "Необхоидмо заполнить хотя бы одно поле для сохранения"
        static var dateFormater: DateFormatter {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "Дата: dd MMMM yyyy"
            dateFormater.locale = locale
            return dateFormater
        }
        static var placeholdeerForDatePicker: String {
            let now = Date()
            let date = dateFormater.string(from: now)
            return date
        }
        static var locale: Locale = Locale(identifier: "ru_RU")
    }

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
            doneBarButton.title = UiSettings.titleForDoneButton
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
        let dateFormater = UiSettings.dateFormater
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
                                                  constant: UiSettings.marginTop).isActive = true
        headerTitleTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                   constant: UiSettings.marginLeft).isActive = true
        headerTitleTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                    constant: UiSettings.marginRight).isActive = true
        headerTitleTextField.font = UIFont.systemFont(ofSize: UiSettings.titleFontSize)
        headerTitleTextField.placeholder = UiSettings.placeholdeerForTitleNote
        headerTitleTextField.autocorrectionType = .no
        headerTitleTextField.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Настройка констрейтов и тд. для dateTeftField
    private func setupUIDateTextField() {
        dateTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateTimeTextField)
        dateTimeTextField.topAnchor.constraint(equalTo: headerTitleTextField.bottomAnchor,
                                                  constant: UiSettings.paddingTop).isActive = true
        dateTimeTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                   constant: UiSettings.marginLeft).isActive = true
        dateTimeTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                    constant: UiSettings.marginRight).isActive = true
        dateTimeTextField.font = UIFont.systemFont(ofSize: UiSettings.titleFontSize)
        dateTimeTextField.placeholder = UiSettings.placeholdeerForDatePicker
        dateTimeTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = UiSettings.locale
        datePicker.addTarget(self, action: #selector(changedDatePicker), for: .valueChanged)
    }

    // MARK: - Настройка констрейтов и тд. для bodyTeftField
    private func setupUIBody() {
        view.addSubview(bodyTextView)
        bodyTextView.topAnchor.constraint(equalTo: dateTimeTextField.bottomAnchor,
                                                  constant: UiSettings.paddingTop).isActive = true
        bodyTextView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                   constant: UiSettings.marginLeft).isActive = true
        bodyTextView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                    constant: UiSettings.marginRight).isActive = true
        bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bodyTextView.font = UIFont.systemFont(ofSize: UiSettings.bodyFontSize)
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
        let alert = UIAlertController(title: UiSettings.titleAlertForCheckNil,
                                      message: UiSettings.messageAlertForCheckNil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true)
    }
}
