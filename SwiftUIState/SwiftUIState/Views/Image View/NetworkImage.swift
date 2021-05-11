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
//        .onDisappear() {
//            // TODO:(grant) remove this compiler check when Xcode fixes the issue with
//            // onAppear/onDisappear being called incorrectly in SwiftUI.
//            // There is an ongoing problem that keeps resurfacing that makes the image load
//            // cancel when it should peform a load. As of our tests on 5/5/21 this only seems
//            // to occur when using the NetworkImage on macOS. Here's a apple forum convo about it:
//            // https://developer.apple.com/forums/thread/656655
//            #if os(iOS)
//            self.imageViewModel.cancel()
//            #endif
//        }
    }
}
