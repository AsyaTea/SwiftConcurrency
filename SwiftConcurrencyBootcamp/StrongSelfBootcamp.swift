//
//  StrongSelfBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 17/03/2025.
//

import SwiftUI

final class StrongSelfDataService {
    func getData() async -> String {
        "UpdatedData"
    }
}

final class StrongSelfBootcampViewModel: ObservableObject {
    @Published var data: String = "Some title"
    let dataService = StrongSelfDataService()

    private var someTask: Task<Void, Never>? = nil
    private var myTasks: [Task<Void, Never>] = []

    func cancelTasks() {
        someTask?.cancel()
        someTask = nil

        myTasks.forEach({ $0.cancel() })
        myTasks = []
    }
    //This implies a strong reference
    func updateData() {
        Task {
            data = await dataService.getData()
        }
    }

    //This is a strong reference
    func updateData2() {
        Task {
            self.data = await dataService.getData()
        }
    }

    //Strong reference
    func updateData3() {
        Task { [self] in
            self.data = await dataService.getData()
        }
    }

    //This is a weak reference
    //N.B. Async/await tasks do not automatically cancel when the object is deallocated
    func updateData4() {
        Task { [weak self] in
            if let data = await self?.dataService.getData() {
                self?.data = data
            }
        }
    }

    //We don't need to manage weak/strong
    //We can manage the Task
    func updateData5() {
        let task1 = Task {
            self.data = await dataService.getData()
        }
        myTasks.append(task1)
    }

    func updateData6() {
        let task2 = Task {
            self.data = await dataService.getData()
        }
        myTasks.append(task2)
    }

    //We purposely do not cancel tasks to keep strong references
    func updateData7() {
        Task {
            self.data = await dataService.getData()
        }
        Task.detached {
            self.data = await self.dataService.getData()
        }
    }

    func updateData8() async {
        self.data = await dataService.getData()
    }
}

struct StrongSelfBootcamp: View {
    @StateObject private var vm = StrongSelfBootcampViewModel()
    var body: some View {
        Text(vm.data)
            .onAppear {
                vm.updateData()
            }
            .onDisappear {
                vm.cancelTasks()
            }
        //Automatically cancel tasks
            .task {
                await vm.updateData8()
            }
    }
}

#Preview {
    StrongSelfBootcamp()
}
