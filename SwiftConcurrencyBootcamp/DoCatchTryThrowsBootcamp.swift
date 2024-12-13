//
//  DoCatchTryThrowsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 03/12/2024.
//

import SwiftUI

//do-catch
//try
//throws

class DoTryCatchThrowsBootcampDataManager {

    let isActive: Bool = true

    func getTitle() -> String? {
        if isActive {
            return "New Text"
        } else{
            return nil
        }
    }

    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT!")
        } else{
            return .failure(URLError(.badURL))
        }
    }

    func getTitle3() throws -> String {
//        if isActive {
//            return "New Text"
//        } else{
            throw URLError(.badServerResponse)
//        }
    }

    func getTitle4() throws -> String {
        if isActive {
            return "Final Text"
        } else{
            throw URLError(.badServerResponse)
        }
    }
}

class DoTryCatchThrowsBootcampViewModel: ObservableObject {
    @Published var text = "Starting text."
    let manager = DoTryCatchThrowsBootcampDataManager()

    func fetchTitle() {
//        if let newTitle = manager.getTitle() {
//            self.text = newTitle
//        }
//        let result = manager.getTitle2()
//        switch result {
//        case .success(let success):
//            self.text = success
//        case .failure(let failure):
//            self.text = failure.localizedDescription
//        }

        do {
            let newTitle = try? manager.getTitle3()
            if let newTitle {
                self.text = newTitle
            }

            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch {
            self.text = error.localizedDescription
        }
    }
}

struct DoCatchTryThrowsBootcamp: View {
    @StateObject private var vm = DoTryCatchThrowsBootcampViewModel()
    var body: some View {
        Text(vm.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                vm.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowsBootcamp()
}
