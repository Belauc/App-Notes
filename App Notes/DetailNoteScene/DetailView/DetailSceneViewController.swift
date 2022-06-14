//
//  ViewController.swift
//  App Notes
//
//  Created by Sergey on 27.03.2022.
//

import UIKit

final class DetailSceneViewController: UIViewController {

    private var doneBarButton = UIBarButtonItem()
    private var bodyTextView = UITextView()
    private var headerTitleTextField = UITextField()
    private var dateTimeLabel = UILabel()
    private var scrollView = UIScrollView()
    private var state: State = .editEnable {
        didSet {
            updateUI()
        }
    }
    private let datePicker = UIDatePicker()
    private enum UiSettings {
        static let marginTop: CGFloat = 20
        static let marginLeft: CGFloat = 20
        static let marginRight: CGFloat = -20
        static let paddingTop: CGFloat = 12
        static let titleFontSize: CGFloat = 22
        static let baseFontSize: CGFloat = 14
        static let placeholdeerForTitleNote = "Заголовок"
        static let titleForDoneButton = "Готово"
        static let titleAlertForCheckNil = "Внимание"
        static let messageAlertForCheckNil = "Необхоидмо заполнить хотя бы одно поле для сохранения"
        static let backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 254/255, alpha: 1)
    }
    var note: Note = Note()
    private enum State {
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
    private let router: DetailRouter
    private let interactor: DetailInteractor
    private let clouser: ((Note) -> Void)?

    init(router: DetailRouter, interactor: DetailInteractor, clouser: ((Note) -> Void)?) {
        self.router = router
        self.interactor = interactor
        self.clouser = clouser
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // Следующее состояние
    private func doNextState() {
        self.state = self.state.nextState // тригерит didSet обсервер
    }

    // Обновление интерфейса(Кнопки "Готово")
    private func updateUI() {
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

    private func enableButtonForStartEditing() {
        state == .editDisable ? doNextState() : nil
    }

    @objc
    private func doneButtonPressed() {
        note.title = headerTitleTextField.text
        note.body = bodyTextView.text
        note.date = Date()
        checkTextFieldOnNil()
        doNextState()
    }

    // MARK: - Настройка Views
    private func configure() {
        setupDelegate()
        setupViews()
    }

    private func setupViews() {
        setupUIBase()
        setupScrollView()
        setupUIDateLabel()
        setupUIHeader()
        setupUIBody()
        updateUI()
        interactor.presentSeletedNote(request: nil)
    }

    // MARK: - Настройка констрейтов и тд. для scrollView
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Настройка констрейтов и тд. для dateLabel
    private func setupUIDateLabel() {
        dateTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(dateTimeLabel)
        dateTimeLabel.widthAnchor.constraint(
            equalToConstant: view.frame.width - UiSettings.marginLeft * 2
        ).isActive = true
        dateTimeLabel.textAlignment = .center
        dateTimeLabel.topAnchor.constraint(
            equalTo: scrollView.topAnchor,
            constant: UiSettings.paddingTop
        ).isActive = true
        dateTimeLabel.leftAnchor.constraint(
            equalTo: scrollView.leftAnchor,
            constant: UiSettings.marginLeft
        ).isActive = true
        dateTimeLabel.rightAnchor.constraint(
            equalTo: scrollView.rightAnchor,
            constant: UiSettings.marginRight
        ).isActive = true
        dateTimeLabel.font = UIFont.systemFont(ofSize: UiSettings.baseFontSize)
        dateTimeLabel.textColor = UIColor(red: 172/255, green: 172/255, blue: 172/255, alpha: 1)
        dateTimeLabel.textAlignment = .center
    }

    // MARK: - Настройка констрейтов и тд. для HeaderTeftField
    private func setupUIHeader() {
        scrollView.addSubview(headerTitleTextField)
        headerTitleTextField.topAnchor.constraint(
            equalTo: dateTimeLabel.bottomAnchor,
            constant: UiSettings.marginTop
        ).isActive = true
        headerTitleTextField.leftAnchor.constraint(
            equalTo: scrollView.leftAnchor,
            constant: UiSettings.marginLeft
        ).isActive = true
        headerTitleTextField.rightAnchor.constraint(
            equalTo: scrollView.rightAnchor,
            constant: UiSettings.marginRight
        ).isActive = true
        headerTitleTextField.font = UIFont.systemFont(ofSize: UiSettings.titleFontSize)
        headerTitleTextField.placeholder = UiSettings.placeholdeerForTitleNote
        headerTitleTextField.autocorrectionType = .no
        headerTitleTextField.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Настройка констрейтов и тд. для bodyTeftField
    private func setupUIBody() {
        scrollView.addSubview(bodyTextView)
        bodyTextView.topAnchor.constraint(
            equalTo: headerTitleTextField.bottomAnchor,
            constant: UiSettings.paddingTop
        ).isActive = true
        bodyTextView.leftAnchor.constraint(
            equalTo: scrollView.leftAnchor,
            constant: UiSettings.marginLeft
        ).isActive = true
        bodyTextView.rightAnchor.constraint(
            equalTo: scrollView.rightAnchor,
            constant: UiSettings.marginRight
        ).isActive = true
        bodyTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bodyTextView.font = UIFont.systemFont(ofSize: UiSettings.baseFontSize)
        bodyTextView.autocorrectionType = .no
        bodyTextView.becomeFirstResponder()
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
        bodyTextView.backgroundColor = UiSettings.backgroundColor
        bodyTextView.adjustableForKeyboard()
    }

    // MARK: - Настройка общих views
    private func setupUIBase() {
        view.backgroundColor = UiSettings.backgroundColor
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
    }
}

// MARK: - Extensions для работы с делегатами
extension DetailSceneViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        enableButtonForStartEditing()
    }
}

extension DetailSceneViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        enableButtonForStartEditing()
    }
}

// MARK: - Extensions для работы с данными
extension DetailSceneViewController: DetailDisplayLogic {
    // Сохраннеие данных
    private func saveData() {
        note.title = headerTitleTextField.text
        note.body = bodyTextView.text
        note.date = Date()
        guard let clouser = clouser else { return }
        clouser(note)
    }
    // Отображение заметки
    func displayNote(viewModel: DetailModel.ShowSelectedNote.ViewModel) {
        note = viewModel.note
        headerTitleTextField.text = viewModel.note.title
        bodyTextView.text = viewModel.note.body
        dateTimeLabel.text = viewModel.note.stringDate
    }

    override func viewWillDisappear(_ animated: Bool) {
        saveData()
    }

}

// MARK: - Extensions для работы проверки на пустоту TextInput
extension DetailSceneViewController {
    private func checkTextFieldOnNil() {
        guard note.isEmtpy else { return }
        let alert = UIAlertController(title: UiSettings.titleAlertForCheckNil,
                                      message: UiSettings.messageAlertForCheckNil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

// MARK: - Extensions для обработки сдвига экрана при появлении клавиатуры
extension UITextView {
    func adjustableForKeyboard() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil)
    }

    @objc
    private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = convert(keyboardScreenEndFrame, from: window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            contentInset = .zero
        } else {
            contentInset = UIEdgeInsets(top: 0, left: 0,
                                        bottom: keyboardViewEndFrame.height - safeAreaInsets.bottom,
                                        right: 0)
        }

        scrollIndicatorInsets = contentInset
        scrollRangeToVisible(selectedRange)
    }
}
