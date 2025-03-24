//
//  MVVMBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 19/03/2025.
//

import SwiftUI

final class MyManagerClass {
    func getData() async throws -> String {
        "Some data"
    }
}

actor MyManagerActor {
    func getData() async throws -> String {
        "Some data"
    }
}

//Keep tasks in the ViewModel, there are few cases when it makes sense to have them in the view. Try to keep the views synchronous
//If many tasks, declare them as an array so that we're able to cancel them whenever we want
@MainActor
final class MVVMBootcampViewModel: ObservableObject {

    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()

    @Published private(set) var myData = "Starting text"

    private var tasks: [Task<Void, Never>] = []

    func onCallToActionButtonPressed() {
        let task = Task {
            do {
//                myData = try await managerClass.getData()
                //If we call this function from the main actor and pass it to an actor running on a background thread, the response will automatically switch back to the main actor when the data is returned.
                //Most of the VMs will likely be @MainActors calling functions from the background
                myData = try await managerActor.getData()
            } catch {
                print(error)
            }
        }
        tasks.append(task)
    }

    func cancelTasks() {
        tasks.forEach { $0.cancel() }
        tasks = []
    }
}

struct MVVMBootcamp: View {
    @StateObject private var vm = MVVMBootcampViewModel()
    var body: some View {
        VStack {
            Button(vm.myData) {
                vm.onCallToActionButtonPressed()
            }
        }
        .onDisappear {
            vm.cancelTasks()
        }
    }
}

#Preview {
    MVVMBootcamp()
}
