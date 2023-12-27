//
//  PersonGridView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 23.11.23.
//

// swiftlint:disable all

import SwiftUI

struct CatalogView<VM>: View where VM: CatalogViewModelProtocol {
    // MARK: Properties
    
    private let pageTitle: String = "Стріткоди"
    @ObservedObject var viewmodel: VM
        
    // Dependency
    private let networkManager: WebAPIManagerProtocol
    private let imageDecoder: ImageDecoderProtocol
    
    init(viewmodel: VM, networkManager: WebAPIManagerProtocol, imageDecoder: ImageDecoderProtocol) {
        self.viewmodel = viewmodel
        self.networkManager = networkManager
        self.imageDecoder = imageDecoder
    }
    
    // MARK: Body
    var body: some View {
        VStack {
            Section {
                gridView
            } header: {
                gridHeader
                    .padding(.bottom, 5)
            }
        }
        .padding(.horizontal, 4)
        .background {
            BackgroundView()
        }.onAppear {
            viewmodel.getCatalogVM()
        }
    }
    
    
    
    //MARK: ViewBuilders
    @ViewBuilder private var gridHeader: some View {
        HStack(alignment: .center) {
            Text(pageTitle)
                .padding(.leading, 10)
                .font(.closer(.medium, size: 45))
                .foregroundColor(.gray700)
            Spacer()
        }.frame(maxHeight: 30)
    }
    
    
    @ViewBuilder private var gridView: some View {
        
        let columns: [GridItem] = .init(repeating: GridItem(.flexible()), count: 2)
        
//        var presentView: Binding<Bool> {
//            .init {
//                viewModel.selectedPerson != nil
//            } set: { _ in
//                viewModel.selectedPerson = nil
//            }
//        }
        
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(viewmodel.catalog) { person in
                    PersonCellView(person: person, imageLoader: ImageLoader(networkManager: networkManager, imageDecoder: imageDecoder))
//                        .onTapGesture {
//                            viewModel.selectedPerson = person
//                        }
                }
            }
        }
//        .sheet(item: $viewModel.selectedPerson) { selectedPerson in
//            PersonPreviewView(person: selectedPerson)
//        }
    }
}

// MARK: Previews
//struct CatalogView_Previews: PreviewProvider {
//    static var previews: some View {
//        CatalogView(
//    }
//}
