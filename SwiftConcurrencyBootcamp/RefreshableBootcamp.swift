//
//  RefreshableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 20/03/2025.
//

import SwiftUI

final class RefreshableDataService {
    func getData() async throws -> [String] {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        return ["Apple", "Orange", "Banana"].shuffled()
    }
}

@MainActor
final class RefreshableBootcampViewModel: ObservableObject  {
    @Published private(set) var items: [String] = []
    let manager = RefreshableDataService()
    func loadData() async {
        do {
            items = try await manager.getData()
        } catch {
            print(error)
        }
    }
}

struct RefreshableBootcamp: View {
    @StateObject private var vm = RefreshableBootcampViewModel()
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(vm.items, id: \.self) { item in
                        Text(item)
                            .font(.headline)
                    }
                }
            }
            .refreshable {
                await vm.loadData()
            }
            .navigationTitle("Refreshable")
            .task {
                await vm.loadData()
            }
        }
    }
}

#Preview {
    RefreshableBootcamp()
}
