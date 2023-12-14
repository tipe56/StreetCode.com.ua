//
//  SwiftUIView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 13.12.23.
//

import SwiftUI

struct SwiftUIView: View {
    
    @StateObject var vm = CatalogVM()
    
    var body: some View {
        VStack {
            Button(action: {
                vm.genericGet()
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
    SwiftUIView()
}
