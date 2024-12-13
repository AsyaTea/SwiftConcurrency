//
//  Exercises.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 11/12/2024.
//

import Foundation
import SwiftUI

struct ProgressBarView: View {
    @State private var fillProgress: CGFloat = 0.0
    let duration: Double = 2.0 // Replace with your desired duration

    var body: some View {
        VStack(spacing: 20) {
            ZStack(alignment: .leading) {
                // Background rectangle
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue)
                    .frame(width: 200 * fillProgress, height: 50)
                    .animation(.linear(duration: duration), value: fillProgress)
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 2)
                    .frame(width: 200, height: 50)
                

                // Filling rectangle

            }

            Button(action: {
                fillProgress = 1.0 // Start the animation to fill the rectangle
            }) {
                Text("Animate Fill")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView()
    }
}
