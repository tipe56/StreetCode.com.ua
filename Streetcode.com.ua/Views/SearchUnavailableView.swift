//
//  SearchUnavailableView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 3.01.24.
//

import SwiftUI

struct SearchUnavailableView: View {
    
    let searchMessage: String
    let image: Image
    let description: String
    var searchText: String
    
    init(image: Image, description: String, searchText: String, searchMessage: String = "Немає результатів для:") {
        self.image = image
        self.description = description
        self.searchText = searchText
        self.searchMessage = searchMessage
    }
    
    var body: some View {
        ZStack {
            BackgroundView().ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack(spacing: 8) {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25)
                        .foregroundStyle(Color.gray700)
                    
                    Text(searchMessage + " \"\(searchText)\"")
                        .font(Font.closer(.medium, size: 27))
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                    Text(description)
                        .font(.headline)
                        .fontWeight(.light)
                        .foregroundStyle(Color.gray)
                }
                .padding(.top, geometry.size.height * 0.3)
                .padding(.horizontal, 15)
                .frame(maxWidth: .infinity, alignment: .center)
                
            }
        }
    }
}

#Preview {
    SearchUnavailableView(image: Image(systemName: "person.slash"), description: "Такого героя поки що немає в каталозі", searchText: "Грушевский" )
}
