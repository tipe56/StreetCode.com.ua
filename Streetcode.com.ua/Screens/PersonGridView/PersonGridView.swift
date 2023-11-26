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
    
    @StateObject var viewModel = PersonPreviewViewModel()
    
    
    
 
// MARK: Body
    var body: some View {
        VStack {
            Section {
                GridView(viewModel: viewModel)
            } header: {
                gridHeader
                    .padding(.bottom, 5)
            }
        }
        .padding(.horizontal, 8)
        .background {
                BackgroundView()
            }
    }
    
    //MARK: ViewBuilders
    @ViewBuilder private var gridHeader: some View{
        HStack(alignment: .center) {
            Text(pageTitle)
                .padding(.leading, 10)
                .font(Font.closerTextMedium(size: 45))
                .foregroundColor(.gray)
            Spacer()
        }.frame(maxHeight: 30)
    }
    
    
}

// MARK: Previews
struct PersonGridView_Previews: PreviewProvider {
    static var previews: some View {
        PersonGridView()
    }
}


// MARK: SubViews
//struct GridHeader: View {
//    let gridTitle: String
//    
//    var body: some View {
//        HStack(alignment: .center) {
//            Text(gridTitle)
//                .padding(.leading, 10)
//                .font(.custom("CloserText-Medium.otf", size: 45))
//                .foregroundColor(.gray)
//            Spacer()
//        }.frame(maxHeight: 30)
//    }
//}

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
    
    @StateObject var viewModel: PersonPreviewViewModel
    
    private let columns: [GridItem] = .init(repeating: GridItem(.flexible()), count: 2)
//    [
//        GridItem(.flexible()),
//        GridItem(.flexible())
//    ]
    
    var presentView: Binding<Bool> {
            .init {
                viewModel.selectedPerson != nil
            } set: { _ in
                viewModel.selectedPerson = nil
            }
        }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(MockData.Persons) { person in
                    PersonCellView(person: person)
                        .onTapGesture {
                            viewModel.selectedPerson = person
                    }
                }
            }
        }
        .sheet(item: $viewModel.selectedPerson) { selectedPerson in
//            if let selectedPerson = viewModel.selectedPerson {
                PersonPreviewView(person: selectedPerson)
                // TODO: remove parameters isShowing
//            }
        }
    }
}
