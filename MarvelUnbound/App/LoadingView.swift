//
//  LoadingView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 08.11.2024.
//

import SwiftUI

struct LoadingView: View {
    @State private var animation = false
    let sizeText: CGFloat
    
    var body: some View {
        Text("Marvel unbound")
            .font(Font.customFont(.bangers, style: .regular, size: sizeText))
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        .blue,
                        .purple,
                        .pink,
                        .orange,
                        .yellow,
                        .blue
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .mask {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .clear,
                                .white.opacity(0.8),
                                .white,
                                .white.opacity(0.8),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .offset(x: animation ? 200 : -200)
            }
            .onAppear{
                withAnimation(.linear(duration: 1.5) .repeatForever(autoreverses: true)){
                    animation.toggle()
                }
            }
        
    }
}

#Preview {
    LoadingView(sizeText: 30)
}
