//
//  PieChartView.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 20.10.2024.
//

import SwiftUI

// The PieChartView displays data as a pie chart.
struct PieChartView: View {
    var data: [Double]
    var labels: [String]

    // Default colors for the pie slices.
    var colors: [Color] = [.red, .green, .blue, .orange, .purple, .yellow]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Draw each pie slice.
                ForEach(0..<self.data.count, id: \.self) { index in
                    PieSliceView(startAngle: self.startAngle(for: index),
                                 endAngle: self.endAngle(for: index))
                        .fill(self.colors[index % self.colors.count])
                }
            }
        }
    }

    // Calculates the total sum of the data.
    func total() -> Double {
        return data.reduce(0, +)
    }

    // Calculates the start angle for a given slice.
    func startAngle(for index: Int) -> Angle {
        let sum = data.prefix(index).reduce(0, +)
        return Angle(degrees: sum / total() * 360)
    }

    // Calculates the end angle for a given slice.
    func endAngle(for index: Int) -> Angle {
        let sum = data.prefix(index + 1).reduce(0, +)
        return Angle(degrees: sum / total() * 360)
    }
}

// The PieSliceView defines the shape of a single slice in the pie chart.
struct PieSliceView: Shape {
    var startAngle: Angle
    var endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        // Move to center and draw arc.
        path.move(to: center)
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle - Angle(degrees: 90),
                    endAngle: endAngle - Angle(degrees: 90),
                    clockwise: false)
        path.closeSubpath()

        return path
    }
}

// Preview provider for PieChartView.
struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(data: [30, 70], labels: ["Category 1", "Category 2"])
            .frame(width: 200, height: 200)
    }
}
