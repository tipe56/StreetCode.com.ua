//
//  PersonGridView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

struct CatalogView<ViewModelType>: View where ViewModelType: CatalogViewModelType {
    
    private let pageTitle: String = "Стріткоди"
    @ObservedObject var viewmodel: ViewModelType
    @Environment(\.diContainer) var container

    // MARK: Body
    var body: some View {
        NavigationStack {
            ZStack {
                if viewmodel.isLoading {
                    LoadingView(gifName: "Logo-animation_40")
                    .frame(width: 420, height: 420)
                    .offset(y: -60.0)
                }
                catalogGridView
            }
            .padding(.horizontal, 4)
            .customNavigationBarModifier(hideSeparator: true)
            .navigationTitle(pageTitle)
            .background {
                BackgroundView()
            }
        }
        .tint(Color.red500)
        .onAppear {
            viewmodel.container = container
            viewmodel.getCatalogVM()
        }
    }
    
    // MARK: ViewBuilder
    @ViewBuilder private var catalogGridView: some View {
        let columns: [GridItem] = .init(repeating: GridItem(.flexible()), count: 2)
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewmodel.filteredCatalog) { person in
                    NavigationLink {
                        ScrollView {
                            Text(person.title)
                                .font(.title3)
                                .bold()
                                .navigationTitle(person.title.components(separatedBy: " ").first ?? "")
                        }
                    } label: {
                        PersonCellView(person: person)
                    }
                }
            }
            
        }
        .searchable(text: $viewmodel.searchTerm, placement: .toolbar, prompt: Text("Я шукаю..."))
        .overlay {
            if viewmodel.filteredCatalog.isEmpty && !viewmodel.isLoading {
                SearchUnavailableView(image: Image(systemName: "person.slash"),
                                      description: "Такого героя поки що немає в каталозі",
                                      searchText: viewmodel.searchTerm)
            }
        }
    }
}

// MARK: Previews
struct CatalogView_Previews: PreviewProvider {
    static var vm = CatalogVM()
    static var previews: some View {
        CatalogView(viewmodel: CatalogView_Previews.vm)
    }
}
