//
//  ContentView.swift
//  SwiftUIState
//
//  Created by Grant Davis on 5/11/21.
//

import SwiftUI

struct ContentView: View {
    let viewModel = ContentViewModel()

    @StateObject var imageModel = NetworkImageModel(url: URL(string: "https://picsum.photos/320/240"))

    var body: some View {
        NavigationView {
            VStack {
                FadeInNetworkImage(imageViewModel: imageModel)
                    .overlay(
                        Text("SwiftUI State Management Tips")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(radius: 4)
                            .padding(4)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    )

                List(viewModel.rows, id: \.self) { row in
                    NavigationLink(row.title, destination: row.destination)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


class ContentViewModel {

    enum Row: CaseIterable {
        case badImageListView
        case okayImageListView
        case betterLazyVStackList
        case bestLazyVStackList

        var title: String {
            switch self {
            case .badImageListView:
                return "Image List with Poor State Management"

            case .okayImageListView:
                return "Image List with Improved State Management"

            case .betterLazyVStackList:
                return "Image List with Better Lazy State Management"

            case .bestLazyVStackList:
                return "Image List with Best State Management"
            }
        }

        var destination: some View {
            Group {
                switch self {
                case .badImageListView:
                    BadImageVStackView()

                case .okayImageListView:
                    OkayImageVStackView()

                case .betterLazyVStackList:
                    BetterImageListLazyVStack()

                case .bestLazyVStackList:
                    BestImageListLazyVStackView()
                }
            }
        }
    }

    let rows = Row.allCases
}
