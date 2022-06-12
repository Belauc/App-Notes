//
//  MainModels.swift
//  App Notes
//
//  Created by Sergey on 09.06.2022.
//

import Foundation

enum MainModel {
    enum FetchData {
        struct Request {}
        struct Response {
            var notes = [Note]()
        }
        struct ViewModel {
            var notes = [Note]()
        }
    }

    enum SaveNewNote {
        struct Request {
            var note: Note
        }
        struct Response {
            var notes = [Note]()
        }
        struct ViewModel {
            var notes = [Note]()
        }
    }

    enum SaveStorageData {
        struct Request {
            var note: Note
        }
        struct Response { }
        struct ViewModel { }
    }

    enum DeleteNoteFromList {
        struct Request {
            var selectedIds = [UUID]()
        }
        struct Response {
            var notes = [Note]()
        }
        struct ViewModel {
            var notes = [Note]()
        }
    }

    enum SaveNotesToDefaults {
        struct Request {
            var notes = [Note]()
        }
        struct Response { }
        struct ViewModel { }
    }

    enum GetNotesFromDefaults {
        struct Request { }
        struct Response {
            var notes = [Note]()
        }
        struct ViewModel {
            var notes = [Note]()
        }
    }
}
