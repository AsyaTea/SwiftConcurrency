//
//  AsyncStreamBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 20/03/2025.
//

import SwiftUI

class AsyncStreamManager {

    func getAsyncStream() -> AsyncThrowingStream<Int, Error> {
        AsyncThrowingStream { [weak self] continuation in
            self?.getFakeData(newValue: { value in
                continuation.yield(value)
            }, onFinish: { error in
                continuation.finish(throwing: error)
            })
        }
    }

    func getFakeData(
        newValue: @escaping (_ value: Int) -> Void,
        onFinish: @escaping (_ error: Error?) -> Void) {
        let items: [Int] = [1,2,3,4,5,6,7,8,9,10]
        for item in items {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(item), execute: {
                newValue(item)
                print("New Data: \(item)")
                if item == items.last {
                    onFinish(nil)
                }
            })
        }
    }

}


class AsyncStreamViewModel: ObservableObject {
    @Published private(set) var currentNumber: Int = 0
    let manager = AsyncStreamManager()

    func onViewAppear() {
//        manager.getFakeData { [weak self] value in
//            self?.currentNumber = value
        //        }
        Task {
            do {
                //canceling the task will only cancel the code inside the completion(UI update) but won't cancel the AsyncStream
                for try  await value in manager.getAsyncStream().dropFirst(2) {
                    await MainActor.run {
                        currentNumber = value
                    }
                }
            } catch {
                print(error)
            }

        }
    }

}

struct AsyncStreamBootcamp: View {
    @StateObject private var vm = AsyncStreamViewModel()

    var body: some View {
        Text("\(vm.currentNumber)")
            .onAppear {
                vm.onViewAppear()
            }
    }
}

#Preview {
    AsyncStreamBootcamp()
}
