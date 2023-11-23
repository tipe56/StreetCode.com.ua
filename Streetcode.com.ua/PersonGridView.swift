//
//  PersonGridView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

struct PersonGridView: View {
// MARK: Properties
    
    private let pageTitle: String = "Стріткоди"
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
 
// MARK: Body
    var body: some View {
        VStack {
            Section {
                GridView(columns: columns)
            } header: {
                GridHeader(gridTitle: pageTitle)
                    .padding(.bottom, 5)
            }
        }.padding(.horizontal, 8)
            .background {
                BackgroundView()
            }
    }
}

// MARK: Previews
struct PersonGridView_Previews: PreviewProvider {
    static var previews: some View {
        PersonGridView()
    }
}




// MARK: SubViews
struct GridHeader: View {
    var gridTitle: String
    
    var body: some View {
        HStack(alignment: .center) {
            Text(gridTitle)
                .padding(.leading, 10)
                .font(.custom("CloserText-Medium.otf", size: 45))
                .foregroundColor(.gray)
            Spacer()
        }.frame(maxHeight: 30)
    }
}

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Image("gridBackground")
                .resizable(resizingMode: .tile)
                .frame(alignment: .top)
            Rectangle()
                .fill(LinearGradient(
                    colors: [.clear, .white, .white],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            
        }.ignoresSafeArea(edges: .top)
    }
}

struct GridView: View {
    var columns: [GridItem]
    
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
