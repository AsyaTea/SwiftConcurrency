//
//  DownloadImageAsync.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 06/12/2024.
//

import SwiftUI
import Combine

class DownloadImageAsyncImageLoader {
    let url = URL(string: "https://picsum.photos/200")!

    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
                return nil
        }
        return image
    }

    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume() //To make it start
    }

    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }

    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }

}

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    var cancellables: Set<AnyCancellable> = []

    func fetchImage() async {
        //MARK: Method 1 Escaping closure

        //        loader.downloadWithEscaping { [weak self] image, error in
        //            DispatchQueue.main.async {
        //                self?.image = image
        //            }
        //        }

        //MARK: Method 2  Combine
        //        loader.downloadWithCombine()
        //            .receive(on: DispatchQueue.main)
        //            .sink { _ in } receiveValue: { [weak self] image in
        //                self?.image = image
        //            }
        //            .store(in: &cancellables)

        //MARK: Method 3 Async/Await
        let image = try? await loader.downloadWithAsync()
        await MainActor.run {
            self.image = image
        }
    }
}

struct DownloadImageAsync: View {
    @StateObject private var vm = DownloadImageAsyncViewModel()
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .task {
            await vm.fetchImage()
        }
    }
}

#Preview {
    DownloadImageAsync()
}
