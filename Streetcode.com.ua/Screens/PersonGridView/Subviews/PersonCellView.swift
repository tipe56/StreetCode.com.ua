//
//  PersonCellView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

struct PersonCellView: View {
    
    let person: HistoricalPerson
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("PersonCellBackground"))
                    .aspectRatio(1, contentMode: .fit)
            }
            .overlay(alignment: .top) {
                Image(person.imageBundle)
                    .resizable()
                    .scaledToFill()
                    .offset(y: 5)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(
                color: Color("PersonCellShadow"),
                radius: 4,
                x: 0,
                y: 4)
            
            VStack {
                Text(person.title)
                    .font(.custom("CloserText-Medium.otf", size: 18))
                
                if let aliasTitle = person.aliasTitle {
                    Text("\"\(aliasTitle)\"")
                        .font(.custom("CloserText-Medium.otf", size: 14))
                    
                }
                
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
        PersonCellView(person: MockData.sampleHistoricalPerson)
    }
}
