//
//  NetworkImage.swift
//  SwiftUIState
//
//  Created by Grant Davis on 5/11/21.
//

import Combine
import Foundation
import SwiftUI

struct NetworkImage: View {
    @ObservedObject var imageViewModel: NetworkImageModel

    var body: some View {
        Group {
            if let image = imageViewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Color.clear
            }
        }
        .onAppear() {
            self.imageViewModel.load()
        }
        // use with caution! there is currently a bug that causes
        // onAppear to be called in the wrong order. uncommenting
        // this will cause weirdness if we try to cancel
        // previous image loads before they finish.
//        .onDisappear() {
//            self.imageViewModel.cancel()
//        }
    }
}
