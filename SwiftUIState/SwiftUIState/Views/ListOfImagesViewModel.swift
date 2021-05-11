//
//  ListOfImagesViewModel.swift
//  SwiftUIState
//
//  Created by Grant Davis on 5/11/21.
//

import Foundation

struct ImageRow {
    let id: Int
    let url: URL
}

class ListOfImagesViewModel: ObservableObject {
    var rows: [ImageRow]

    init() {
        rows = (0..<100).map { row in
            ImageRow(id: row, url: URL(string: "https://picsum.photos/320/100")!)
        }
    }
}
