//
//  CatalogView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 13.12.23.
//

// swiftlint:disable all

import SwiftUI

struct CatalogView<VM>: View where VM: CatalogViewModelProtocol {
    
    @ObservedObject var viewmodel: VM
    
    init(viewModel: VM) {
        viewmodel = viewModel
    }
    
    var body: some View {
        VStack {
            Button(action: {
                viewmodel.getCatalogVM()
            }, label: {
                Text("Button")
            })
            List {
                ForEach(viewmodel.catalog) { person in
                    Text(person.title)
                }
            }
        }
    }
}

#Preview {
    CatalogView<CatalogVM>(viewModel: CatalogVM(networkManager: WebAPIManager()))
}
