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
    private let uiSettings = UISettings.shared
    private let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()

    }

    @objc
    func doneButtonPressed(_ sender: UIBarButtonItem) {
        saveData()
        doNextState()
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
            doneBarButton.title = "Готово"
        case .editDisable:
            view.endEditing(true)
            doneBarButton.isEnabled = false
            doneBarButton.title = ""
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

    private func getStringFromDate(date: Date) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd MMMM yyyy"
        dateFormater.locale = uiSettings.locale
        return dateFormater.string(from: date)
    }

    @objc
    func doneButtonPressedDatePicker() {
        let dateFromPicker = getStringFromDate(date: datePicker.date)
        dateTimeTextField.text = dateFromPicker
    }

    // MARK: - Настройка Views
    private func configure() {
        setupDelegate()
        setupViews()
    }

    private func setupViews() {
        setupUIBase()
        setupUIHeader()
        setupUIBody()
        setupUIDateTextField()
        updateUI()
        restoreData()
    }

    // MARK: - Настройка констрейтов и тд. для HeaderTeftField
    private func setupUIHeader() {
        view.addSubview(headerTitleTextField)
        headerTitleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                  constant: uiSettings.marginTop).isActive = true
        headerTitleTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                   constant: uiSettings.marginLeft).isActive = true
        headerTitleTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                    constant: uiSettings.marginRight).isActive = true
        headerTitleTextField.font = UIFont.systemFont(ofSize: uiSettings.titleFontSize)
        headerTitleTextField.placeholder = uiSettings.placeholdeerForTitleNote
        headerTitleTextField.autocorrectionType = .no
        headerTitleTextField.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Настройка констрейтов и тд. для bodyTeftField
    private func setupUIBody() {
        view.addSubview(bodyTextView)
        bodyTextView.topAnchor.constraint(equalTo: dateTimeTextField.bottomAnchor,
                                                  constant: uiSettings.paddingTop).isActive = true
        bodyTextView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                   constant: uiSettings.marginLeft).isActive = true
        bodyTextView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                    constant: uiSettings.marginRight).isActive = true
        bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bodyTextView.font = UIFont.systemFont(ofSize: uiSettings.bodyFontSize)
        bodyTextView.autocorrectionType = .no
        bodyTextView.becomeFirstResponder()
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false

    }

    // MARK: - Настройка констрейтов и тд. для dateTeftField
    private func setupUIDateTextField() {
        dateTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateTimeTextField)
        dateTimeTextField.topAnchor.constraint(equalTo: headerTitleTextField.bottomAnchor,
                                                  constant: uiSettings.paddingTop).isActive = true
        dateTimeTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                                   constant: uiSettings.marginLeft).isActive = true
        dateTimeTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                                    constant: uiSettings.marginRight).isActive = true
        dateTimeTextField.font = UIFont.systemFont(ofSize: uiSettings.titleFontSize)
        dateTimeTextField.placeholder = uiSettings.placeholdeerForTitleNote
        dateTimeTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = uiSettings.locale
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 45))
        toolBar.sizeToFit()
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let doneBtnToolBar = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(doneButtonPressedDatePicker))
        let flexSpaceToolBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpaceToolBar, doneBtnToolBar], animated: true)
        dateTimeTextField.inputAccessoryView = toolBar
        dateTimeTextField.autocorrectionType = .no
    }

    // MARK: - Настройка общих views
    func setupUIBase() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    // MARK: - Настройка делегатов
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
