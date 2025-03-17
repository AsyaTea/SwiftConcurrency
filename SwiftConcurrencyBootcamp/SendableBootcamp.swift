//
//  SendableBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 14/03/2025.
//

import SwiftUI

actor CurrentUserManager {

    func updateDatabase(userInfo: MyClassUserInfo) {

    }
}

struct MyUserInfo: Sendable {
    let name: String
}

//Thread safe because properties within are immutable, therefore it cannot be changed from anywhere
//With vars it won't compile unless using @unchecked, however then we have to make sure all tasks within the object run on the same thread.
final class MyClassUserInfo: @unchecked Sendable {
    var name: String

    init(name: String) {
        self.name = name
    }

    func updateName(name: String) {
        self.name = name
    }
}

class SendableBootcampViewModel: ObservableObject {
    let manager = CurrentUserManager()

    func updateCurrentUserInfo() async {

        let info = MyClassUserInfo(name: "info")
        await manager.updateDatabase(userInfo: info)
    }
}

struct SendableBootcamp: View {
    @StateObject private var vm = SendableBootcampViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .task {

            }
    }
}

#Preview {
    SendableBootcamp()
}
