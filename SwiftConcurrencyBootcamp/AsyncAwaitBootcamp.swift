//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 09/12/2024.
//

import SwiftUI

class AsyncAwaitBootcampViewModel: ObservableObject {
    @Published var dataArray: [String] = []

    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title1 : \(Thread.current)")
        }
    }

    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "Title 2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)

                let title3 = "Title 3 : \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }

    func addAuthor1() async {
        let author = "Author1: \(Thread.current)"
        self.dataArray.append(author)

        try? await Task.sleep(nanoseconds: 2_000_000_000)

        let author2 = "Author2: \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(author2)

            let author3 = "Author3: \(Thread.current)"
            self.dataArray.append(author3)
        }

        await doSomething()
    }

    func doSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)

        let something1 = "something1: \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(something1)

            let something2 = "something2: \(Thread.current)"
            self.dataArray.append(something2)
        }
    }
}

struct AsyncAwaitBootcamp: View {
    @StateObject var vm = AsyncAwaitBootcampViewModel()
    var body: some View {
        List {
            ForEach(vm.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
//            vm.addTitle1()
//            vm.addTitle2()
            Task {
                await vm.addAuthor1()

                let finalText = "FINAL TEXT: \(Thread.current)"
                vm.dataArray.append(finalText )
            }
        }
    }
}

#Preview {
    AsyncAwaitBootcamp()
}
