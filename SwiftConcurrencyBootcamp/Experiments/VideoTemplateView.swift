//
//  VideoTemplateView.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 13/12/2024.
//

import Foundation
import SwiftUI

//struct SceneModel {
//    var duration: CGFloat // Duration of the scene
//    var id: UUID = UUID() // Unique identifier for each scene
//}
//
//struct VideoTrimmingParentView: View {
//    @State private var scenes: [SceneModel] = [
//        SceneModel(duration: 100),
//        SceneModel(duration: 150),
//        SceneModel(duration: 200)
//    ]
//    private let totalWidthPadding: CGFloat = 20 // Padding between scenes
//
//    var body: some View {
//        GeometryReader { geometry in
//            let totalWidth = geometry.size.width
//            let totalDuration = scenes.reduce(0) { $0 + $1.duration }
//            let unitWidth = (totalWidth - totalWidthPadding) / totalDuration
//
//            HStack(spacing: 0) {
//                ForEach(scenes.indices, id: \.self) { index in
//                    VideoTrimmingView(
//                        scene: $scenes[index],
//                        unitWidth: unitWidth,
//                        totalDuration: totalDuration
//                    ) { newDuration in
//                        updateDurations(for: index, with: newDuration)
//                    }
//                }
//            }
//        }
//        .frame(height: 100)
//        Text("Hi")
//    }
//
//    private func updateDurations(for index: Int, with newDuration: CGFloat) {
//        guard newDuration > 50 else { return } // Prevent too small durations
//        scenes[index].duration = newDuration
//
//        // Adjust neighboring scenes to maintain overall balance
//        if index < scenes.count - 1 {
//            let delta = newDuration - scenes[index].duration
//            scenes[index + 1].duration -= delta
//        }
//    }
//}
//
//struct VideoTrimmingView: View {
//    @Binding var scene: SceneModel
//    let unitWidth: CGFloat
//    let totalDuration: CGFloat
//    let onDurationChange: (CGFloat) -> Void
//
//    var body: some View {
//        let sceneWidth = scene.duration * unitWidth
//
//        ZStack {
//            RoundedRectangle(cornerRadius: 5)
//                .fill(Color.gray.opacity(0.2))
//                .frame(width: sceneWidth, height: 80)
//
//            RoundedRectangle(cornerRadius: 5)
//                .stroke(Color.yellow, lineWidth: 2)
//                .frame(width: sceneWidth, height: 80)
//
//            HStack {
//                // Left Handle
//                Rectangle()
//                    .fill(Color.yellow)
//                    .frame(width: 10, height: 80)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                let delta = value.translation.width / unitWidth
//                                onDurationChange(max(50, scene.duration + delta)) // Minimum duration 50
//                            }
//                    )
//                    .padding(.leading, -5)
//
//                Spacer()
//
//                // Right Handle
//                Rectangle()
//                    .fill(Color.yellow)
//                    .frame(width: 10, height: 80)
//                    .gesture(
//                        DragGesture()
//                            .onChanged { value in
//                                let delta = value.translation.width / unitWidth
//                                onDurationChange(max(50, scene.duration + delta)) // Minimum duration 50
//                            }
//                    )
//                    .padding(.trailing, -5)
//            }
//        }
//    }
//}
