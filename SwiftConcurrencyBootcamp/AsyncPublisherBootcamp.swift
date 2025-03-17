//
//  AsyncPublisherBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 14/03/2025.
//

import SwiftUI

class AsyncPublisherDataManager {
    @Published var myData: [String] = []

    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        myData.append("Watermelon")

    }
}

class AsyncPublisherBootcampViewModel: ObservableObject {
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()

    init() {
        addSubscribers()
    }

    private func addSubscribers() {
        Task {
            //Async Publisher
            for await value in manager.$myData.values {
                await MainActor.run {
                    self.dataArray = value
                }
            }
        }
    }

    func start() async {
       await manager.addData()
    }
}

struct AsyncPublisherBootcamp: View {
    @StateObject private var vm = AsyncPublisherBootcampViewModel()
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await vm.start()
        }
    }
}

#Preview {
    AsyncPublisherBootcamp()
}
