//
//  BetterImageListLazyVStack.swift
//  SwiftUIState
//
//  Created by Grant Davis on 5/11/21.
//

import Foundation
import SwiftUI

struct BetterImageListLazyVStack: View {

    @State var viewModel = ListOfImagesViewModel()
    @State var selectedRow: ImageRow?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Improvements:")
                    .fontWeight(.bold)
                VStack(alignment: .leading) {
                    Text("• Views are lazily created")
                    Text("• Images load only when shown")
                }
                Text("Issues:")
                    .fontWeight(.bold)
                VStack(alignment: .leading) {
                    Text("• Images reload when brought back on screen")
                }
                .padding(.leading, 10)
            }
            .frame(maxWidth: .infinity)

            LazyVStack {
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
        .navigationTitle("Better Image List")
    }
}
