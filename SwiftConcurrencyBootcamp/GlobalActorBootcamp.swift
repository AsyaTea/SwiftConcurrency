//
//  GlobalActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 14/03/2025.
//

import SwiftUI

@globalActor struct MyFirstGlobalActor {
    typealias ActorType = MyNewDataManager

    static var shared = MyNewDataManager()
}

actor MyNewDataManager {
    func getDataFromDatabase() -> [String] {
        return ["Hello", "World", "Swift", "Concurrency", "Five"]
    }
}

class GlobalActorBootcampViewModel: ObservableObject {

    @Published var dataArray: [String] = []
    private let manager = MyFirstGlobalActor.shared

    @MyFirstGlobalActor
    func getData() async {
        let data = await manager.getDataFromDatabase()
        self.dataArray = data
    }
}

struct GlobalActorBootcamp: View {
    @StateObject private var vm = GlobalActorBootcampViewModel()
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
            await vm.getData()
        }
    }
}

#Preview {
    GlobalActorBootcamp()
}
