//
//  PersonCellView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

// TODO: Refactor whole this View

struct PersonCellView: View {
    
    let person: CatalogPersonModel
    @ObservedObject var imageLoader: ImageLoader
    
    init(person: CatalogPersonModel, imageLoader: ImageLoader) {
        self.person = person
        self.imageLoader = imageLoader
    }
    
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray100)
                .aspectRatio(1, contentMode: .fit)
                .overlay(alignment: .top) {
                    CatalogRemoteImage(imageLoader: imageLoader, imageId: person.imageID)
                        .scaledToFill()
                        .offset(y: 5)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(6)
                .shadow(
                    color: Color.gray600,
                    radius: 4,
                    x: 0,
                    y: 4)
            
            VStack {
                Text(person.title)
                    .font(.closer(.medium, size: 18))
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text(person.alias)
                    .font(.closer(.medium, size: 14))
            }
            .frame(height: 45)
            .minimumScaleFactor(0.6)
            .foregroundColor(Color(.label))
            .multilineTextAlignment(.center)
        }
    }
}

struct PersonCellView_Previews: PreviewProvider {
    static var previews: some View {
        PersonCellView(person: CatalogPersonModel.mockData, imageLoader: ImageLoader(networkManager: WebAPIManager(), imageDecoder: ImageDecoder()))
    }
}
