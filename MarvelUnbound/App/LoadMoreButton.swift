//
//  MoreButton.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.12.2024.
//

import SwiftUI

struct LoadMoreButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action){
            Text("Load More")
                .foregroundStyle(.white)
                .font(Font.customFont(.inter, style: .medium, size: 15))
                .padding(.horizontal, 15)
                .padding(.vertical, 9)
                .background(.black)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

#Preview {
    LoadMoreButton(action: {})
}
