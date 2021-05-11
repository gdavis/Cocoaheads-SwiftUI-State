//
//  BadImageListVStack.swift
//  SwiftUIState
//
//  Created by Grant Davis on 5/11/21.
//

import Foundation
import SwiftUI

struct BadImageVStackView: View {

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
                        // creating the view model here will cause it to be re-created
                        // each time the view renders the body. which is a lot.
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
        .navigationTitle("Bad Image List")
    }
}


struct ImproperImageRowView: View {
    @ObservedObject var imageModel: NetworkImageModel

    init(imageModel: NetworkImageModel) {
        self.imageModel = imageModel

        // invoking an image load directly from the init can cause
        // more than you want to load. its better to rely on onAppear
        // to trigger actions that perform significant work
        imageModel.load()
    }

    var body: some View {
        FadeInNetworkImage(imageViewModel: imageModel)
            .frame(width: 320, height: 100)
            .cornerRadius(12)
    }
}
