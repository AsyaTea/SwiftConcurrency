//
//  ActorsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 14/03/2025.
//

import SwiftUI

// 1. What is the problem that actor are solving?
// 2. How was this problem solved before actors?
// 3. Actors can solve the problem!

//Classes are not thread safe

class MyDataManager {
    static let instance = MyDataManager()
    private init() { }

    var data: [String] = []
    func getRandomData() -> String? {

        self.data.append(UUID().uuidString)
        print(Thread.current)
        return data.randomElement()
    }
}

struct HomeView: View {

    let manager = MyDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common, options: nil).autoconnect()

    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()

            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            DispatchQueue.global(qos: .background).async {
                if let data = manager.getRandomData() {
                    DispatchQueue.main.async {
                        self.text = data
                    }
                }
            }
        }
    }
}

struct BrowseView: View {

    let manager = MyDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.01, on: .main, in: .common, options: nil).autoconnect()

    var body: some View {
        ZStack {
            Color.yellow.opacity(0.8).ignoresSafeArea()

            Text(text)
                .font(.headline)
        }
        .onReceive(timer) { _ in
            DispatchQueue.global(qos: .default).async {
                if let data = manager.getRandomData() {
                    DispatchQueue.main.async {
                        self.text = data
                    }
                }
            }

        }
    }
}

struct ActorsBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    ActorsBootcamp()
}
