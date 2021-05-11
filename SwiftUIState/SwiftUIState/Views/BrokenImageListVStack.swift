//
//  BrokenImageListVStack.swift
//  SwiftUIState
//
//  Created by Grant Davis on 5/11/21.
//

import Foundation
import SwiftUI

struct ImproperImageListVStack: View {

    @State var viewModel = ListOfImagesViewModel()
    @State var selectedRow: ImageRow?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Issues:")
                VStack(alignment: .leading) {
                    Text("• All images are loaded immediately")
                    Text("• Fading only works on first images")
                    Text("• Selecting a row reloads everything")
                }
                .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity)

            VStack {
                ForEach(viewModel.rows, id: \.id) { row in
                    Button(action: { selectedRow = row }, label: {
                        ImproperImageRowView(imageModel: NetworkImageModel(url: row.url))
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
        .navigationTitle("Improper Image List")
    }
}


struct ImproperImageRowView: View {
    @ObservedObject var imageModel: NetworkImageModel

    init(imageModel: NetworkImageModel) {
        self.imageModel = imageModel

        imageModel.load()
    }

    var body: some View {
        FadeInNetworkImage(imageViewModel: imageModel)
            .frame(width: 320, height: 100)
            .cornerRadius(12)
    }
}
