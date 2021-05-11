//
//  NetworkImageModel.swift
//  SwiftUIState
//
//  Created by Grant Davis on 5/11/21.
//

import Combine
import Foundation
import SwiftUI

class NetworkImageModel: ObservableObject {

    @Published var image: UIImage?

    let url: URL?
    let id = UUID().uuidString

    private var imageSubscriber: AnyCancellable? { didSet { oldValue?.cancel() }}

    init(url: URL?) {
        self.url = url

        print("\(NetworkImageModel.self) 🟢 \(#function) \(id)")
    }

    deinit {
        print("\(NetworkImageModel.self) 🔴 \(#function) \(id)")
    }

    func load() {
        guard let url = url,
              imageSubscriber == nil,
              image == nil
        else { return }

        print("\(NetworkImageModel.self) ✈️ \(#function) \(id)")

        imageSubscriber = URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) in
                UIImage(data: data)
            }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assignNoRetain(to: \.image, on: self)
    }

    func cancel() {
        imageSubscriber = nil
    }
}


// MARK: - Helper Extension

extension Publisher where Self.Failure == Never {

    public func assignNoRetain<Root>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>, on object: Root) -> AnyCancellable where Root: AnyObject {
        sink { [weak object] (value) in
            object?[keyPath: keyPath] = value
        }
    }
}
