//
//  FilterView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 06.11.2024.
//

import SwiftUI

struct SortView: View {
    @Binding var selected: SortSelection
    let actionButton: () -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20){
                SortSelectionButton(selection: .popular, selected: $selected, action: actionButton)
                SortSelectionButton(selection: .alphabeticalAscending, selected: $selected, action: actionButton)
                SortSelectionButton(selection: .alphabeticalDescending, selected: $selected, action: actionButton)
                SortSelectionButton(selection: .lastModified, selected: $selected, action: actionButton)
                SortSelectionButton(selection: .firstModified, selected: $selected, action: actionButton)
            }
        }
        .padding(.horizontal, 20)
    }
}

private struct SortSelectionButton: View {
    let selection: SortSelection
    @Binding var selected: SortSelection
    let action: () -> Void
    
    var body: some View {
        Button{
            if selected != selection{
                selected = selection
                action()
            }
        } label: {
            Text(selection.rawValue)
                .font(Font.customFont(.roboto, style: .bold, size: 20))
                .foregroundStyle(selected == selection ? .white : .black)
                .padding(14)
                .background(selected == selection ? .black : .white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    @Previewable @State var selectedSortSelection: SortSelection = .popular
    SortView(selected: $selectedSortSelection, actionButton: {
        
    })
}
