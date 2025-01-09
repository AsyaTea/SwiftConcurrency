//
//  DraggableRectangle.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Asya Tealdi on 12/12/2024.
//

import SwiftUI

struct VideoTrimmingView: View {
    @State private var startX: CGFloat = 50    // Initial position for the leading edge
    @State private var endX: CGFloat = 250    // Initial position for the trailing edge
    private let height: CGFloat = 80          // Height of the rectangle

    var body: some View {
        ZStack {
            // Background track (gray rectangle)
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.2))
                .frame(width: endX - startX, height: height)
                .position(x: (startX + endX) / 2, y: height / 2)

            // Yellow resizable rectangle
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.yellow, lineWidth: 2)
                .frame(width: endX - startX, height: height)
                .position(x: (startX + endX) / 2, y: height / 2)

            // Left Handle
            Rectangle()
                .fill(Color.yellow)
                .frame(width: 10, height: height)
                .cornerRadius(3)
                .position(x: startX, y: height / 2)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            startX = min(max(value.location.x, 16), endX - 50)
                        }
                )

            // Right Handle
            Rectangle()
                .fill(Color.yellow)
                .frame(width: 10, height: height)
                .cornerRadius(3)
                .position(x: endX, y: height / 2)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            endX = max(min(value.location.x, UIScreen.main.bounds.width - 16), startX + 50)
                        }
                )
        }
        .frame(height: height + 20)
    }
}




#Preview {
    VideoTrimmingView()
}
