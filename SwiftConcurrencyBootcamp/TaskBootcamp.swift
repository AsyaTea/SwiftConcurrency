//
//  TaskBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 12/12/2024.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil


    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {

            guard let url = URL(string: "https://picsum.photos/1000") else {
                return
            }
            let (data, _) =  try await URLSession.shared.data(from: url, delegate: nil)

            await MainActor.run {
                self.image = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchImage2() async {
        do {

            guard let url = URL(string: "https://picsum.photos/1000") else {
                return
            }
            let (data, _) =  try await URLSession.shared.data(from: url, delegate: nil)

            await MainActor.run {
                self.image2 = UIImage(data: data)            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcampHomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("CLICK ME!") {
                    TaskBootcamp()
                }
            }
        }
    }
}

struct TaskBootcamp: View {
    @StateObject private var vm = TaskBootcampViewModel()
    @State private var fetchImageTask: Task<(), Never>? = nil

    var body: some View {
        VStack(spacing: 40) {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }

            if let image = vm.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }

        }
        .task {
            await vm.fetchImage()
        }
//        .onDisappear(perform: {
//            fetchImageTask?.cancel()
//        })
//        .onAppear {
//            self.fetchImageTask = Task {
//            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await vm.fetchImage2()
//            }

//            Task(priority: .high) {
////                try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield() //Let other task get over the highest priority task
//                print("high: \(Thread.current) : \(Task.currentPriority.rawValue)")
//            }
//            Task(priority: .userInitiated) {
//                print("userInitiated: \(Thread.current) : \(Task.currentPriority.rawValue)")
//            }
//
//            Task(priority: .medium) {
//                print("Medium: \(Thread.current) : \(Task.currentPriority.rawValue)")
//            }
//            Task(priority: .utility) {
//                print("utility: \(Thread.current) : \(Task.currentPriority.rawValue)")
//            }
//
//            Task(priority: .low) {
//                print("Low: \(Thread.current) : \(Task.currentPriority.rawValue)")
//            }
//            Task(priority: .background) {
//                print("background: \(Thread.current) : \(Task.currentPriority.rawValue)")
//            }

//            Task(priority: .low) {
//                print("userInitiated: \(Thread.current) : \(Task.currentPriority.rawValue)")
//
//                Task.detached {
//                    print("detached: \(Thread.current) : \(Task.currentPriority.rawValue)")
//
//                }
//            }
//        }
    }
}

#Preview {
    TaskBootcamp()
}
