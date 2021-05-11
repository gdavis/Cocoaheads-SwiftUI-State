//
//  BestImageListLazyVStackView.swift
//  SwiftUIState
//
//  Created by Grant Davis on 5/11/21.
//

import Foundation
import SwiftUI

struct BestImageListLazyVStackView: View {

    @State var viewModel = ListOfCachedImagesViewModel()
    @State var selectedRow: ImageRow?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Improvements:")
                    .fontWeight(.bold)
                VStack(alignment: .leading) {
                    Text("• Images load only when shown")
                    Text("• Images do not reload on second appearance")
                }
                .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity)

            LazyVStack {
                ForEach(viewModel.rows, id: \.id) { row in
                    Button(action: { selectedRow = row }, label: {
                        BestImageRowView(imageModel: viewModel.imageModel(for: row))
                    })
                    .overlay(
                        Group {
                            if selectedRow?.id == row.id {
                                Color.clear
                                    .border(Color.red, width: 4)
                            }
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("Best Image List")
    }
}


class ListOfCachedImagesViewModel: ObservableObject {
    var rows: [ImageRow]

    var imageModels: [Int: NetworkImageModel] = [:]

    init() {
        rows = (0..<100).map { row in
            ImageRow(id: row, url: URL(string: "https://picsum.photos/320/100")!)
        }
    }

    func imageModel(for row: ImageRow) -> NetworkImageModel {
        if let existingModel = imageModels[row.id] {
            return existingModel
        }

        let newModel = NetworkImageModel(url: row.url)
        imageModels[row.id] = newModel
        return newModel
    }
}



struct BestImageRowView: View {
    let imageModel: NetworkImageModel

    init(imageModel: NetworkImageModel) {
        self.imageModel = imageModel
    }

    var body: some View {
        FadeInNetworkImage(imageViewModel: imageModel)
            .frame(width: 320, height: 100)
            .cornerRadius(12)
    }
}
