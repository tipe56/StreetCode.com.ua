//
//  PersonCellView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

// TODO: Refactor whole this View

struct PersonCellView: View {
    
    let person: CatalogPerson
    @Environment(\.diContainer) var container

    init(person: CatalogPerson) {
        self.person = person
    }
    
    var body: some View {
        VStack {
            catalogImage
            VStack {
                Text(person.title)
                    .font(.closer(.medium, size: 18))
                Text(person.alias)
                    .font(.closer(.medium, size: 14))
            }
            .frame(height: 45)
            .minimumScaleFactor(0.6)
            .foregroundColor(Color(.label))
            .multilineTextAlignment(.center)
        }
    }
    
    @ViewBuilder private var catalogImage: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.gray100)
            .aspectRatio(1, contentMode: .fit)
            .overlay {
              CatalogRemoteImage(imageLoader: container.resolve(),
                                   imageId: person.imageID)
                .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(6)
            .shadow(
                color: Color.gray600,
                radius: 4,
                x: 0,
                y: 4)
    }
}

struct PersonCellView_Previews: PreviewProvider {
    static var previews: some View {
        PersonCellView(person: CatalogPerson.mockData)
    }
}
