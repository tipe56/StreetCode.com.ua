//
//  CatalogView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 13.12.23.
//

// swiftlint:disable all

import SwiftUI

struct CatalogView<VM>: View where VM: CatalogViewModeble {
    
    @ObservedObject var vm: VM
    
    init(viewModel: VM) {
        vm = viewModel
    }
    
    var body: some View {
        VStack {
            Button(action: {
                Task {
                    await vm.getCatalogVM()
                }
                
                print(vm.catalog.count)
            }, label: {
                Text("Button")
            })
            List {
                ForEach(vm.catalog) { person in
                    Text(person.title)
                }
            }
        }
    }
}

#Preview {
    CatalogView<CatalogVM>(viewModel: CatalogVM(networkManager: WebAPIManager()))
}
