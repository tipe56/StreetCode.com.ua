//
//  PersonGridView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

struct PersonGridView: View {
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(MockData.Persons) { person in
                    PersonCellView(person: person)
                }
            }
        }
    }
}

struct PersonGridView_Previews: PreviewProvider {
    static var previews: some View {
        PersonGridView()
    }
}
