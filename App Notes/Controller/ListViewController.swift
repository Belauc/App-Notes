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

final class ListViewController: UIViewController {
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    private let addButton = UIButton()
    private let tableView = UITableView()
    private enum UiSettings {
        static let marginTop: CGFloat = 16
        static let marginLeft: CGFloat = 16
        static let marginRight: CGFloat = -16
        static let heightWidthForButton: CGFloat = 50
        static let marginBottomForButton: CGFloat = -60
        static let cornerRadiusForButton: CGFloat = 25
        static let fontForButton = UIFont.systemFont(ofSize: 36, weight: .regular)
        static let colorForButton = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        static let backgraundColor = UIColor(red: 249/255, green: 250/255, blue: 254/255, alpha: 1)
        static let highlightColor = UIColor(red: 233.0/255.0, green: 242.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        static let UnHighlightColor = UIColor.systemBackground
        static let titleForNavBar = "Заметки"
        static var fullDateFormatNow: String {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd.MM.yyyy EEEE HH:mm:ss"
            dateFormater.locale = Locale(identifier: "ru_RU")
            let date = dateFormater.string(from: Date())
            return date
        }
    }
    private var notes: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Настройка Views
    private func configure() {
        setupViews()
    }

    private func setupViews() {
        setupTableView()
        setupUIAddButton()
        setupBase()
    }

    // MARK: - Настройка констрейтов и тд. для TableView
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: UiSettings.marginTop
        ).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UiSettings.backgraundColor
        tableView.separatorStyle = .none
    }

    // MARK: - Настройка отображения кнопки добавить
    private func setupUIAddButton() {
        view.addSubview(addButton)
        addButton.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: UiSettings.marginBottomForButton
        ).isActive = true
        addButton.rightAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.rightAnchor,
            constant: UiSettings.marginRight
        ).isActive = true
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = UiSettings.cornerRadiusForButton
        addButton.widthAnchor.constraint(equalToConstant: UiSettings.heightWidthForButton).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: UiSettings.heightWidthForButton).isActive = true
        addButton.clipsToBounds = true
        addButton.contentVerticalAlignment = .center
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UiSettings.fontForButton
        addButton.backgroundColor = UiSettings.colorForButton
        addButton.addTarget(self, action: #selector(addTapButton), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - обработка нажатия на кнопку добавить
    @objc
    func addTapButton() {
        let noteViewController = NoteViewController()
        noteViewController.delegate = self
        navigationController?.pushViewController(noteViewController, animated: true)
    }

    // MARK: - Настройка общих views
    func setupBase() {
        view.backgroundColor = UiSettings.backgraundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = UiSettings.titleForNavBar
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: NoteViewController(), action: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoteCardView.self, forCellReuseIdentifier: NoteCardView.identificator)
        tableView.rowHeight = 94
    }
}

// MARK: - Расширение для UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteCardView.identificator,
            for: indexPath
        ) as? NoteCardView else { return UITableViewCell() }
        cell.model = notes[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NoteCardView else {return }
        cell.backView.backgroundColor = UiSettings.highlightColor
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NoteCardView else {return }
        cell.backView.backgroundColor = UiSettings.UnHighlightColor
    }
}

// MARK: - Расширение для UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clickedItem = notes[indexPath.row]
        let noteViewController = NoteViewController()
        noteViewController.delegate = self
        noteViewController.note = clickedItem
        navigationController?.pushViewController(noteViewController, animated: true)
    }
}

// MARK: - Работы с UpdateNotesListDelegate
extension ListViewController: UpdateNotesListDelegate {
    func updateNoteList(note: Note) {
        guard !note.isEmtpy else { return }
        guard notes.contains(where: { $0.id == note.id }) else {
            note.fullDateTime = UiSettings.fullDateFormatNow
            notes.append(note)
            sortNotes()
            return
        }
        guard let index = notes.firstIndex(of: note) else { return }
        note.fullDateTime = UiSettings.fullDateFormatNow
        notes[index] = note
        sortNotes()
    }

    func sortNotes() {
        notes = notes.sorted(by: { $0.fullDateTime ?? "0" > $1.fullDateTime ?? "1" })
        tableView.reloadData()
    }
}
