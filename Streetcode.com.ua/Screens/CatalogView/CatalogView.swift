//
//  PersonGridView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

import SwiftUI

struct CatalogView<ViewModelType>: View where ViewModelType: CatalogViewModelType {
    
    private struct Constants {
        static var pageTitle: String { return "Стріткоди" }
        static var logoAnimationName: String { return "Logo-animation_40" }
        static var searchprompt: String { return "Я шукаю..." }
        static var unavaliableViewDescription: String { return "Такого героя поки що немає в каталозі" }
    }
    
    @ObservedObject var viewModel: ViewModelType
    
    // MARK: Body
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isLoading {
                    LoadingView(gifName: Constants.logoAnimationName)
                        .offset(y: -60.0)
                }
                catalogGridView
            }
            .padding(.horizontal, 4)
            .customNavigationBarModifier(hideSeparator: true)
            .navigationTitle(Constants.pageTitle)
            .background {
                BackgroundView()
            }
        }
        .tint(Color.red500)
        .onAppear {
            viewModel.getCatalogVM()
        }
    }
    
    // MARK: ViewBuilder
    @ViewBuilder private var catalogGridView: some View {
        
        let columns: [GridItem] = .init(repeating: GridItem(.flexible()), count: 2)
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewModel.filteredCatalog) { person in
                    NavigationLink {
                        ScrollView {
                            Text(person.title)
                                .font(.title3)
                                .bold()
                                .navigationTitle(person.title.components(separatedBy: " ").first ?? "")
                        }
                    } label: {
                        PersonCellView(person: person, container: viewModel.container)
                    }
                }
            }
            
        }
        .searchable(text: $viewModel.searchTerm, placement: .toolbar, prompt: Text(Constants.searchprompt))
        .overlay {
            if viewModel.filteredCatalog.isEmpty && !viewModel.isLoading {
                SearchUnavailableView(image: Image(systemName: "person.slash"),
                                      description: Constants.unavaliableViewDescription,
                                      searchText: viewModel.searchTerm)
            }
        }
    }
}

// MARK: Previews
struct CatalogView_Previews: PreviewProvider {
    static var vm = CatalogVM(container: DIContainer())
    static var previews: some View {
        CatalogView(viewModel: CatalogView_Previews.vm)
    }
}
