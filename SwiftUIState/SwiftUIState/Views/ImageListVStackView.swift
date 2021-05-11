//
//  ListWithImagesView.swift
//  SwiftUIState
//
//  Created by Grant Davis on 5/11/21.
//

import Foundation
import SwiftUI

struct ImageListVStackView: View {

    @State var viewModel = ListOfImagesViewModel()
    @State var selectedRow: ImageRow?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Improvements:")
                VStack(alignment: .leading) {
                    Text("• Fading works")
                    Text("• Images load properly")
                    Text("• Images only load once")
                    Text("• Selection does not reload images")
                }
                Text("Issues:")
                VStack(alignment: .leading) {
                    Text("• All images load immediately")
                }
                .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity)

            VStack {
                ForEach(viewModel.rows, id: \.id) { row in
                    Button(action: { selectedRow = row }, label: {
                        ProperImageRowView(row: row)
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
        .navigationTitle("Improved Image List")
    }
}


struct ProperImageRowView: View {

    @StateObject var imageModel: NetworkImageModel

    init(row: ImageRow) {
        self._imageModel = StateObject(wrappedValue: NetworkImageModel(url: row.url))
    }

    var body: some View {
        FadeInNetworkImage(imageViewModel: imageModel)
            .frame(width: 320, height: 100)
            .cornerRadius(12)
            .onAppear() {
                imageModel.load()
            }
    }
}
