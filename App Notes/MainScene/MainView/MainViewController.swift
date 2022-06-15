//
//  MainViewController.swift
//  App Notes
//
//  Created by Sergey on 09.06.2022.
//

import UIKit
import Foundation

final class MainSceneViewController: UIViewController {
    private let addButton = UIButton()
    private let tableView = UITableView()
    private var editBarButton = UIBarButtonItem()
    private var loadingView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    private enum UiSettings {
        static let marginTop: CGFloat = 16
        static let marginLeft: CGFloat = 16
        static let marginRight: CGFloat = -16
        static let heightWidthForButton: CGFloat = 50
        static let marginBottomForButton: CGFloat = -60
        static let cornerRadiusForButton: CGFloat = 25
        static let rowHeight: CGFloat = 94
        static let fontForButton = UIFont.systemFont(ofSize: 36, weight: .regular)
        static let colorForButton = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
        static let backgraundColor = UIColor(red: 249/255, green: 250/255, blue: 254/255, alpha: 1)
        static let highlightColor = UIColor(red: 233.0/255.0, green: 242.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        static let UnHighlightColor = UIColor.systemBackground
        static let titleForNavBar = "Заметки"
        static let titleForEditStateButton = "Готово"
        static let titleForSelectStateButton = "Выбрать"
        static let titleAlertForCheckNil = "Внимание"
        static let titleAlertButton = "Ок"
        static let messageAlertForCheckNil = "Вы не выбрали ни одной заметки"
    }
    private var addButtonBottomAnchor: NSLayoutConstraint?
    private var notes: [Note] = []
    private var selectedIndexs: [IndexPath] = []
    private var idSelectedNotes: [UUID] = []
    private var stateEditing = false

    // MARK: - References

    private let interactor: MainBusinessLogic
    public let router: MainRoutingLogic

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Init

    init(
      interactor: MainBusinessLogic,
      router: MainRoutingLogic
    ) {
        self.interactor = interactor
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Общая настройка
    private func configure() {
        interactor.fetchNotesData(request: MainModel.FetchData.Request())
        setupViews()
    }

    // MARK: - Настройка Views
    private func setupViews() {
        setupBase()
        setupTableView()
        setuploadingScreen()
        setupUIAddButton()
    }

    // MARK: - обработка нажатия на кнопку добавить/удалить
    @objc
    private func addEditTapButton() {
        if stateEditing {
            guard !selectedIndexs.isEmpty else {
                showAlertSelectedNill()
                return
            }
            changeState()
            deleteDataAfterEdit()
            saveData()
        } else {
            UIView.animateKeyframes(
                withDuration: 1,
                delay: 0,
                options: [],
                animations: { [weak self] in
                    guard let self = self else { return }
                    self.addKeyFrames()
                }
            )
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
                guard let self = self else { return }
                self.router.navigateToDetailScene(clouser: { [weak self] note in
                    self?.interactor.saveNote(request: MainModel.SaveNewNote.Request(note: note))
                    self?.saveData()
                })
            }
        }
    }

    // MARK: - Анимационные кейсы для скрытия кнопки добавления/удаления
    private func addKeyFrames() {
        UIView.addKeyframe(
            withRelativeStartTime: 0,
            relativeDuration: 0.2,
            animations: { [weak self] in
                guard let self = self else { return }
                self.addButton.frame.origin.y -= 15
            }
        )
        UIView.addKeyframe(
            withRelativeStartTime: 0.5,
            relativeDuration: 0.8,
            animations: { [weak self] in
                guard let self = self else { return }
                self.addButton.frame.origin.y += 200
            }
        )
    }

    // MARK: - Удаление данных после редактирования списка заметок
    private func deleteDataAfterEdit() {
        interactor.deleteNoteFromList(
            request: MainModel.DeleteNoteFromList.Request(selectedIds: idSelectedNotes)
        )
        saveData()
    }

    // MARK: - Проверка на количество выбранных заметок
    private func showAlertSelectedNill() {
        let alert = UIAlertController(title: UiSettings.titleAlertForCheckNil,
                                      message: UiSettings.messageAlertForCheckNil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: UiSettings.titleAlertButton, style: .default, handler: nil))
        present(alert, animated: true)
    }

    // MARK: - Обрабокта нажатия кнопки выбрать/готово в навбаре
    @objc
    private func editButtonPressed() {
        tableView.setEditing(stateEditing, animated: true)
        changeState()
        selectedIndexs.removeAll()
        idSelectedNotes.removeAll()
    }

    // MARK: - Изменения состояния, редактирование/выбор.
    private func changeState() {
        stateEditing = !stateEditing
        tableView.setEditing(stateEditing, animated: true)
        editBarButton.title = stateEditing ? UiSettings.titleForEditStateButton : UiSettings.titleForSelectStateButton
        let image = stateEditing ? UIImage(named: "delete") : UIImage(named: "plus")
        addButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        UIView.animate(
            withDuration: 1.2,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.2,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.addButton.setImage(image, for: .normal)
                self?.addButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        )
    }

    // MARK: - Изменения жиненного цикла
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addButtonBottomAnchor?.isActive = false
        addButtonBottomAnchor = addButton.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: 50
        )
        addButtonBottomAnchor?.isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(
            withDuration: 1.8,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.2,
            options: .curveEaseIn,
            animations: { [weak self] in
                guard let self = self else { return }
                self.addButtonBottomAnchor?.isActive = false
                self.addButtonBottomAnchor = self.addButton.bottomAnchor.constraint(
                    equalTo: self.view.safeAreaLayoutGuide.bottomAnchor,
                    constant: UiSettings.marginBottomForButton
                )
                self.addButtonBottomAnchor?.isActive = true
                self.view.layoutSubviews()
            }
        )
    }
}

// MARK: - Расширение для UITableViewDataSource
extension MainSceneViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NoteCardView.identificator,
            for: indexPath
        ) as? NoteCardView else { return UITableViewCell() }
        cell.model = notes[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NoteCardView else {return }
        cell.backView.backgroundColor = UiSettings.highlightColor
        cell.contentView.backgroundColor = UiSettings.backgraundColor
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NoteCardView else {return }
        cell.backView.backgroundColor = UiSettings.UnHighlightColor
    }
}

// MARK: - Расширение для UITableViewDelegate
extension MainSceneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if stateEditing {
            selectedIndexs.append(indexPath)
            idSelectedNotes.append(notes[indexPath.row].id)
        } else {
            let clickedItem = notes[indexPath.row]
            interactor.saveStorageData(request: MainModel.SaveStorageData.Request(note: clickedItem))
            router.navigateToDetailScene(clouser: { [weak self] note in
                self?.interactor.saveNote(request: MainModel.SaveNewNote.Request(note: note))
            })
            interactor.clearStorageData()
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedIndexs.removeAll(where: {$0 == indexPath})
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, _ in
            guard let self = self else { return }
            let noteIdForDelete = self.notes[indexPath.row].id
            self.selectedIndexs.append(indexPath)
            self.interactor.deleteNoteFromList(
                request: MainModel.DeleteNoteFromList.Request(selectedIds: [noteIdForDelete])
            )
        }
        saveData()
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - Работы с UserDefaults
extension MainSceneViewController {
    private func saveData() {
        interactor.saveNotesToDefaults(request: MainModel.SaveNotesToDefaults.Request(notes: notes))
    }
}

// MARK: - Экстеншен настройки констрейтов и views
extension MainSceneViewController {
    // MARK: - Настройка констрейтов и тд. для TableView
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: UiSettings.marginTop
        ).isActive = true
        tableView.leftAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leftAnchor,
            constant: UiSettings.marginLeft
        ).isActive = true
        tableView.rightAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.rightAnchor,
            constant: UiSettings.marginRight).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UiSettings.backgraundColor
        tableView.separatorStyle = .none
        tableView.rowHeight = UiSettings.rowHeight
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NoteCardView.self, forCellReuseIdentifier: NoteCardView.identificator)
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
    }

    // MARK: - Настройка констрейтов и тд. для ActivityIndicator
    private func setuploadingScreen() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = UiSettings.backgraundColor
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.color = .gray
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
        loadingView.topAnchor.constraint(
            equalTo: tableView.topAnchor
        ).isActive = true
        loadingView.leftAnchor.constraint(
            equalTo: tableView.leftAnchor
        ).isActive = true
        loadingView.rightAnchor.constraint(
            equalTo: tableView.rightAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor).isActive = true
        activityIndicator.startAnimating()
    }

    private func removeLoadingScreen() {
        UIView.animate(
            withDuration: 0.8,
            delay: 0.0,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.loadingView.layer.opacity = 0
            },
            completion: {[weak self] _ in
                self?.loadingView.isHidden = true
            }
        )
        activityIndicator.stopAnimating()
    }

    // MARK: - Настройка отображения кнопки добавить
    private func setupUIAddButton() {
        view.addSubview(addButton)
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
        addButton.setImage(UIImage(named: "plus"), for: .normal)
        addButton.titleLabel?.font = UiSettings.fontForButton
        addButton.backgroundColor = UiSettings.colorForButton
        addButton.addTarget(self, action: #selector(addEditTapButton), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: - Настройка общих views
    private func setupBase() {
        view.backgroundColor = UiSettings.backgraundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = UiSettings.titleForNavBar
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: DetailSceneAssembly.builder(note: Note()) { [weak self] note in
                self?.interactor.saveNote(request: MainModel.SaveNewNote.Request(note: note))
            }, action: nil)
        editBarButton.target = self
        editBarButton.action = #selector(editButtonPressed)
        editBarButton.title = UiSettings.titleForSelectStateButton
        navigationItem.rightBarButtonItem = editBarButton
    }
}

extension MainSceneViewController: MainDisplayLogic {
    func updateNotesListAfterAdded(viewModel: MainModel.SaveNewNote.ViewModel) {
        notes = viewModel.notes
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        saveData()
    }

    func updateNotesListAfterDeleted(viewModel: MainModel.DeleteNoteFromList.ViewModel) {
        notes = viewModel.notes
        tableView.deleteRows(at: selectedIndexs, with: .middle)
        selectedIndexs.removeAll()
        idSelectedNotes.removeAll()
        saveData()
    }

    func displayNotes(viewModel: MainModel.FetchData.ViewModel) {
        notes = viewModel.notes
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.removeLoadingScreen()
        }
    }
}
