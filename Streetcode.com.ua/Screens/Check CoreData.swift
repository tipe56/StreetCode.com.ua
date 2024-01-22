//
//  Check CoreData.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 16.01.24.
//

import SwiftUI

struct CheckCoreData: View {
    @ObservedObject var viewModel: CoreDataViewModel
    @State var textFieldText: String = ""
    
    init(container: DIContainerable) {
        self.viewModel = CoreDataViewModel(container: container)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Add Hero", text: $textFieldText)
                    .font(.headline)
                    .foregroundStyle(Color.black)
                    .padding()
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
                Button {
                    if !textFieldText.isEmpty {
                        viewModel.addHero(text: textFieldText)
                        viewModel.fetch()
                        textFieldText = ""
                    }
                } label: {
                    Text("Add hero")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding()
            List {
                ForEach(viewModel.listData) { element in
                    Text(element.title ?? "no element")
                        .onTapGesture {
//                            vm.dataManager.update(element) {
//                                element.title = "baobab"
//                                vm.fetch()
//                            }
                        }
                }
                .onDelete(perform: viewModel.delete)
            }
            .navigationTitle("Testing Core Data")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            viewModel.listData.removeAll()
                            viewModel.convertPersonsToEntities()
                            viewModel.fetch()
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "circle")
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            viewModel.listData.forEach { viewModel.dataManager?.delete(item: $0) }
                            viewModel.fetch()
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.catalogVM.getCatalogVM()
                viewModel.catalogOfPersons = viewModel.catalogVM.catalog
                print("Number of elements in catalog of Persons: \(viewModel.catalogOfPersons.count)")
                viewModel.fetch()
            }
        }
    }
}

//#Preview {
//    CheckCoreData()
//}
