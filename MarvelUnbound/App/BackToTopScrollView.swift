//
//  BackToTopScrollView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 08.11.2024.
//

import SwiftUI

struct BackToTopScrollView<Content: View>: View {
    private let contentView: (ScrollViewProxy) -> Content
    private var invisibleTopViewId: String = "TOP_ID"
    private var coordinateSpaceName: String = "BACK_TO_TOP_SCROLLVIEW"
    private var minimumScrollOffset: CGFloat = 20
    @State private var offset: CGPoint = .zero
    @State private var showBackButton: Bool = false
    
    init( @ViewBuilder contentView: @escaping(ScrollViewProxy) -> Content){
        self.contentView = contentView
    }
    
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(showsIndicators: false) {
                Color.clear
                    .frame(height: 0)
                    .id(invisibleTopViewId)
                
                PositionObservingView(
                    coordinateSpace: .named(coordinateSpaceName),
                    position: Binding(
                        get: { offset },
                        set: { newOffset in
                            offset = CGPoint(
                                x: -newOffset.x,
                                y: -newOffset.y
                            )
                        }),
                    content: {
                        contentView(scrollProxy)
                    }
                )
            }
            .overlay(alignment: .top){
                if showBackButton {
                    Button{
                        withAnimation{
                            scrollProxy.scrollTo(invisibleTopViewId)
                        }
                    } label: {
                        HStack(spacing: 5){
                            Image(systemName: "chevron.up")
                            Text("Back to top")
                                .font(Font.customFont(.inter, style: .medium, size: 15))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 9)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .transition(
                        AnyTransition
                            .move(edge: .top)
                            .combined(with: .opacity)
                            .combined(with: .scale(scale: 0.5))
                    )
                    .padding()
                }
            }
            .onChange(of: offset.y) { _, newValue in
                withAnimation(.easeInOut) {
                    if newValue > minimumScrollOffset && !showBackButton {
                        showBackButton = true
                    } else if newValue < minimumScrollOffset && showBackButton{
                        showBackButton = false
                    }
                }
            }
        }
    }
}

private struct PositionObservingView<Content: View>: View {
    var coordinateSpace: CoordinateSpace
    @Binding var position: CGPoint
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: PreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace).origin
                )
            })
            .onPreferenceChange(PreferenceKey.self) { position in
                self.position = position
            }
    }
}

private extension PositionObservingView {
    struct PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGPoint { .zero }
        
        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        }
    }
}

#Preview {
    BackToTopScrollView { _ in
        VStack {
            ForEach(0..<100) { i in
                Text("\(i)")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
    }
}
