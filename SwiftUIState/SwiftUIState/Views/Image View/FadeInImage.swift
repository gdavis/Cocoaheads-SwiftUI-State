//
//  FadeInImage.swift
//  SwiftUIState
//
//  Created by Grant Davis on 5/11/21.
//

import Combine
import Foundation
import SwiftUI

struct FadeInNetworkImage: View {
    @ObservedObject var imageViewModel: NetworkImageModel
    @State private var imageOpacity: Double {
        didSet {
            print("imageOpacity: \(imageOpacity)")
        }
    }

    let animation: Animation

    init(imageViewModel: NetworkImageModel, animation: Animation = .easeInOut(duration: 0.5)) {
        self.imageViewModel = imageViewModel
        self._imageOpacity = State(initialValue: imageViewModel.image != nil ? 1 : 0)
        self.animation = animation
    }

    var body: some View {
        Group {
            NetworkImage(imageViewModel: imageViewModel)
                .opacity(imageOpacity)
        }
        .drawingGroup(opaque: true, colorMode: ColorRenderingMode.linear)
        .onChange(of: imageViewModel.image) { image in
            withAnimation(animation) {
                imageOpacity = image != nil ? 1 : 0
            }
        }
    }
}




struct FadeInNetworkImage_Previews: PreviewProvider {
    @StateObject static var model = NetworkImageModel(url: URL(string: "https://picsum.photos/320/100"))

    static var previews: some View {
        FadeInNetworkImage(imageViewModel: model)
    }
}
