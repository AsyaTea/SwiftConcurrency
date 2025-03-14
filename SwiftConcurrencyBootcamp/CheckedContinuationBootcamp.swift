//
//  CheckedContinuationBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 09/01/2025.
//

import SwiftUI

class CheckedContinuationBootcampNetworkManager {

    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }

    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }

    }
}

class CheckedContinuationBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil

    let networkManager = CheckedContinuationBootcampNetworkManager()
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200/300") else { return }

        do {
            let data = try await networkManager.getData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }

        } catch {
            print(error)
        }
    }
}

struct CheckedContinuationBootcamp: View {
    @StateObject private var vm = CheckedContinuationBootcampViewModel()
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await vm.getImage()
        }
    }
}

#Preview {
    CheckedContinuationBootcamp()
}
