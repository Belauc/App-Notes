//
//  ListViewController.swift
//  App Notes
//
//  Created by Sergey on 10.04.2022.
//

import UIKit

protocol UpdateNotesListDelegate: AnyObject {
    func updateNoteList(note: Note)
}

final class ListViewController: UIViewController, UpdateNotesListDelegate {
    var stackView = UIStackView()
    var scrollView = UIScrollView()
    private let addButton = UIButton()
    private enum UiSettings {
        static let marginTop: CGFloat = 16
        static let marginLeft: CGFloat = 16
        static let marginRight: CGFloat = -16
        static let paddingTop: CGFloat = 10
        static let titleFontSize: CGFloat = 22
        static let bodyFontSize: CGFloat = 14
        static let stackViewSpacing: CGFloat = 4
        static let titleForNavBar = "Заметки"
        static var fullDateFormatNow: String {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd.MM.yyyy EEEE HH:mm:ss"
            dateFormater.locale = locale
            let date = dateFormater.string(from: Date())
            return date
        }
        static var locale: Locale = Locale(identifier: "ru_RU")
    }

    var notes: [Note] = []
    let note: Note = Note()
    var clickedCardViewInStack = NoteCardView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Настройка Views
    private func configure() {
        setupViews()
//        notes.append(Note(title: "asdasd", body: "asdasd", date: "21.03.2022 среда 21:55"))
//        notes.append(Note(title: "22222", body: "asdasd", date: "21.03.2022 среда 21:55"))
//        notes.append(Note(title: "asd333333asd", body: "asdasd", date: "21.03.2022 среда 21:55"))
//        notes.append(Note(title: "asd44444asd", body: "asdasd", date: "21.03.2022 среда 21:55"))
//        notes.append(Note(title: "asd5555asd", body: "asdasd", date: "21.03.2022 среда 21:55"))
//        notes.append(Note(title: "asd5555asd", body: "asdasd", date: "21.03.2022 среда 21:55"))
//        notes.append(Note(title: "asd5555asd", body: "asdasd", date: "21.03.2022 среда 21:55"))
//        notes.append(Note(title: "asd5555asd", body: "asdasd", date: "21.03.2022 среда 21:55"))
//        notes.append(Note(title: "asd5555asd", body: "asdasd", date: "21.03.2022 среда 21:55"))
//        notes.append(Note(title: "asd5555asd", body: "asdasd", date: "21.03.2022 среда 21:55"))
        loadDate()
    }

    private func setupViews() {
        setupScrollView()
        setupUIStack()
        setupUIAddButton()
        setupUIBase()
    }

    // MARK: - Настройка констрейтов и тд. для scrollView
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.alwaysBounceVertical = true
        scrollView.isDirectionalLockEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollView.frame.height)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Настройка констрейтов и тд. для UIStack
    private func setupUIStack() {
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = UiSettings.stackViewSpacing
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: UiSettings.marginTop).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: UiSettings.marginLeft).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor,
                                         constant: UiSettings.marginRight).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        let tapOnStackView = UITapGestureRecognizer(target: self, action: #selector(itemStackViewTapped(_:)))
        stackView.addGestureRecognizer(tapOnStackView)
    }

    // MARK: - Обработка нажатия на элемент StackView
    @objc
    func itemStackViewTapped(_ recognizer: UIGestureRecognizer) {
        let clickedViewInStack = stackView.arrangedSubviews
            .first(where: {$0.bounds.contains(recognizer.location(in: $0))})
        guard let cardView = clickedViewInStack as? NoteCardView else {
            return
        }
        clickedCardViewInStack = cardView
        let noteForSend = notes.first(where: {
                $0.date == clickedCardViewInStack.dateTextLabel.text &&
                $0.title == clickedCardViewInStack.headerTextLabel.text &&
                $0.body == clickedCardViewInStack.bodyTextLabel.text
        })
        let noteViewController = NoteViewController()
        noteViewController.delegate = self
        noteViewController.note = noteForSend ?? Note()
        navigationController?.pushViewController(noteViewController, animated: true)
    }

    private func setupUIAddButton() {
        view.addSubview(addButton)
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        addButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor,
                                         constant: -19).isActive = true
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = 25
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.clipsToBounds = true
        addButton.contentVerticalAlignment = .center
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        addButton.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        addButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
    }

    @objc
    func didTapButton() {
        let noteViewController = NoteViewController()
        noteViewController.delegate = self
        navigationController?.pushViewController(noteViewController, animated: true)
    }

    // MARK: - Настройка общих views
    func setupUIBase() {
        view.backgroundColor = UIColor(red: 249/255, green: 250/255, blue: 254/255, alpha: 1)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = UiSettings.titleForNavBar
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
    }
}

// MARK: - Работы с данными в stackView
extension ListViewController {
    private func loadDate() {
        notes.forEach { addNoteCardInStackView(note: $0 ) }
    }

    func updateNoteList(note: Note) {
        guard notes.contains(where: { $0.fullDateTime == note.fullDateTime }) else {
            addToNoteList(note: note)
            return
        }
        guard let index = notes.firstIndex(of: note) else { return }
        note.fullDateTime = UiSettings.fullDateFormatNow
        notes[index] = note
        updateStackView(note: note)
    }

    func addToNoteList(note: Note) {
        note.fullDateTime = UiSettings.fullDateFormatNow
        notes.append(note)
        updateStackView(note: note)
    }

    func updateStackView(note: Note) {
        stackView.removeArrangedSubview(clickedCardViewInStack)
        clickedCardViewInStack.removeFromSuperview()
        addNoteCardInStackView(note: note)
        sortStackView()
    }

    func sortStackView() {
        let count = stackView.arrangedSubviews.count - 1
        for index in (0...count).reversed() {
            stackView.addArrangedSubview(stackView.subviews[index])
        }
    }

    func addNoteCardInStackView(note: Note) {
        let noteView = NoteCardView(frame: CGRect(x: 0, y: 0, width: 150, height: 90))
        noteView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        noteView.bodyTextLabel.text = note.body
        noteView.headerTextLabel.text = note.title
        noteView.dateTextLabel.text = note.date
        stackView.addArrangedSubview(noteView)
    }
}
