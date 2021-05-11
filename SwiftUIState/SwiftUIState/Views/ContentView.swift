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

                List(viewModel.rows, id: \.self) { row in
                    NavigationLink(row.title, destination: row.destination)
                }
            }
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
        case improperViewModelList
        case improvedVStackList
        case betterLazyVStackList
        case bestLazyVStackList

        var title: String {
            switch self {
            case .improperViewModelList:
                return "Image List with Poor State Management"

            case .improvedVStackList:
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
                case .improperViewModelList:
                    ImproperImageListVStack()

                case .improvedVStackList:
                    ImageListVStackView()

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
