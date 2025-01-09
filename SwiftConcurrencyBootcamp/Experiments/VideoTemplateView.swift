//
//  VideoTemplateView.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 13/12/2024.
//

import Foundation
import SwiftUI

struct SceneModel {
    let id: String
    var duration: Duration
}

struct VideoTemplateView: View {
    let sceneArray: [SceneModel] = [
        SceneModel(id: UUID().uuidString, duration: .seconds(2)),
        SceneModel(id: UUID().uuidString, duration: .seconds(4)),
        SceneModel(id: UUID().uuidString, duration: .seconds(6)),
        SceneModel(id: UUID().uuidString, duration: .seconds(3)),
        SceneModel(id: UUID().uuidString, duration: .seconds(4)),
    ]

    var body: some View {
        Text("Hello, World!")
    }
}


#Preview {
    VideoTemplateView()
}
