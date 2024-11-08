//
//  FilterView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 06.11.2024.
//

import SwiftUI

struct SortView: View {
    @Binding var selected: SortSelection
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20){
                SortSelectionButton(selection: .popular, selected: $selected)
                SortSelectionButton(selection: .alphabeticalAscending, selected: $selected)
                SortSelectionButton(selection: .alphabeticalDescending, selected: $selected)
                SortSelectionButton(selection: .lastModified, selected: $selected)
                SortSelectionButton(selection: .firstModified, selected: $selected)
            }
        }
        .padding(.horizontal, 20)
    }
}

private struct SortSelectionButton: View {
    let selection: SortSelection
    @Binding var selected: SortSelection
    
    var body: some View {
        Button{
            selected = selection
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
    SortView(selected: $selectedSortSelection)
}
