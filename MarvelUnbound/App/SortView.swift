//
//  FilterView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 06.11.2024.
//

import SwiftUI

struct SortView<Service: EntityServiceable>: View {
    @Binding var service: Service
    
    let actionButton: () -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20){
                SortSelectionButton(selection: .popular, service: $service, action: actionButton)
                SortSelectionButton(selection: .alphabeticalAscending, service: $service, action: actionButton)
                SortSelectionButton(selection: .alphabeticalDescending, service: $service, action: actionButton)
                SortSelectionButton(selection: .lastModified, service: $service, action: actionButton)
                SortSelectionButton(selection: .firstModified, service: $service, action: actionButton)
            }
        }
        .padding(.horizontal, 20)
    }
}

private struct SortSelectionButton<Service: EntityServiceable>: View {
    let selection: SortSelection
    @Binding var service: Service
    let action: () -> Void
    
    var body: some View {
        Button{
            if service.sortSelection != selection{
                service.sortSelection = selection
                action()
            }
        } label: {
            Text(selection.rawValue)
                .font(Font.customFont(.roboto, style: .bold, size: 20))
                .foregroundStyle(service.sortSelection == selection ? .white : .black)
                .padding(14)
                .background(service.sortSelection == selection ? .black : .white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SortView(service: .constant(CharactersService()), actionButton: {
        
    })
}
