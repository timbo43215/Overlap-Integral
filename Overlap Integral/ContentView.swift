//
//  ContentView.swift
//  Overlap Integral
//
//  Created by IIT PHYS 440 on 2/10/23.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State private var interatomicSpacing = 0.5 // Initial interatomic spacing
    @State private var numSamples = 100000 // Number of samples for Monte Carlo Integration
    @State private var overlap = 0.0 // Overlap integral
    
    var body: some View {
        VStack {
            Text("Interatomic spacing: \(interatomicSpacing, specifier: "%.2f")")
                .padding()
            Slider(value: $interatomicSpacing, in: 0.5...5, step: 0.1)
                .padding(.horizontal)
            Text("Number of samples: \(numSamples)")
                .padding()
            Stepper("Samples: \(numSamples)", value: $numSamples, in: 1000...100000, step: 1000)
                .padding(.horizontal)
            Button("Calculate overlap") {
                overlap = calculateOverlap(interatomicSpacing: interatomicSpacing, numSamples: numSamples)
            }
            Text("Overlap integral: \(overlap, specifier: "%.5f")")
                .padding()
        }
    }
    
    func calculateOverlap(interatomicSpacing: Double, numSamples: Int) -> Double {
        let pi = 3.14159
        var overlap = 0.0
        for _ in 0..<numSamples {
            let r1 = Double.random(in: 0...interatomicSpacing/2)
            let r2 = Double.random(in: 0...interatomicSpacing/2)
            let theta1 = Double.random(in: 0...2 * pi)
            let theta2 = Double.random(in: 0...2 * pi)
            let phi1 = Double.random(in: 0...pi)
            let phi2 = Double.random(in: 0...pi)
            let x1 = r1 * sin(phi1) * cos(theta1)
            let y1 = r1 * sin(phi1) * sin(theta1)
            let z1 = r1 * cos(phi1)
            let x2 = r2 * sin(phi2) * cos(theta2) + interatomicSpacing
            let y2 = r2 * sin(phi2) * sin(theta2)
            let z2 = r2 * cos(phi2)
            let distance = sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) + (z1 - z2) * (z1 - z2))
            if distance < 1e-8 {
                overlap += 1
            } else {
                overlap += 2 * exp(-distance) / distance
            }
        }
        overlap /= Double(numSamples)
        return overlap
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
