//
//  PersonCellView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

// TODO: Refactor whole this View

struct PersonCellView: View {
    
    let person: CatalogPersonEntity
    private let imageLoader: ImageLoadableType?

    init(person: CatalogPersonEntity, container: DIContainerable) {
        self.person = person
        self.imageLoader = container.resolve()
    }
    
    var body: some View {
        VStack {
            catalogImage
            VStack {
                Text(person.wrappedTitle)
                    .font(.closer(.medium, size: 18))
                Text(person.wrappedAlias)
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
                CatalogRemoteImage(imageLoader: imageLoader, imageId: Int(person.imageID))
                    .scaledToFill()
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(6)
            .shadow(color: Color.gray600,
                    radius: 4,
                    x: 0,
                    y: 4)
    }
}

#if DEBUG
struct PersonCellView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let manager = CoreDataService(logger: LoggerManager())
        let personEntity = CatalogPersonEntity(context: manager.context)
        personEntity.id = Int16(438)
        personEntity.title = "Роман Рáтушний «Сенека»"
        personEntity.alias = "Активіст, журналіст, доброволець"
        personEntity.imageID = Int16(2136)
        
        return PersonCellView(person: personEntity, container: DIContainer())
    }
}
#endif
