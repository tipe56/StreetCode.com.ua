//
//  Check CoreData.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 16.01.24.
//

import SwiftUI


class CoreDataViewModel: ObservableObject {
    let dataManager = DataManager(logger: LoggerManager())
    @Published var listData: [CatalogPersonEntity] = []
    
    func delete(indexSet: IndexSet) {
        dataManager.delete(entities: listData, indexSet: indexSet)
        fetch()
    }
    
//    func update(entity: CatalogPersonEntity) {
//        dataManager.update(entity) { _ in
//            <#code#>
//        }
//        fetch()
//    }
    
    let sort = [NSSortDescriptor(key: "id", ascending: true)]
    
    func fetch() {
        listData = dataManager.fetch(CatalogPersonEntity.self, sortdescriptors: sort)
    }
}



struct CheckCoreData: View {
    
    @ObservedObject var vm = CoreDataViewModel()
    @ObservedObject var catalog = CatalogVM(container: DIContainer())
    
    @State var text: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                    TextField("Add Hero", text: $text)
                        .font(.headline)
                        .foregroundStyle(Color.black)
                        .padding()
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    
                    Button {
                        let newHero = CatalogPerson(id: Int.random(in: 0...999),
                                                    title: text,
                                                    url: text,
                                                    alias: text,
                                                    imageID: Int.random(in: 0...999))
                        if !text.isEmpty { vm.dataManager.createItem(newHero) { item in
                            createEntity(newHero)
                        }
                        }
                        vm.listData = vm.dataManager.fetch(CatalogPersonEntity.self)
                        text = ""
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
                ForEach(vm.listData) { element in
                    Text(element.title ?? "no element")
                        .onTapGesture {
                            vm.dataManager.update(element) {
                                element.title = "baobab"
                                vm.fetch()
                            }
//                            vm.dataManager.update(element) { item in
//                                item.title = "Vovan"
//                                vm.fetch()
//                            }
                            
                        }
                }
                .onDelete(perform: vm.delete)
            }
            .navigationTitle("Testing Core Data")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            vm.dataManager.createArray(catalog.catalog) { createEntity($0) }
                            vm.listData = vm.dataManager.fetch(CatalogPersonEntity.self)
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        catalog.getCatalogVM()
                    } label: {
                        Image(systemName: "circle")
                    }
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            vm.listData.forEach { vm.dataManager.delete(item: $0) }
                            vm.listData = vm.dataManager.fetch(CatalogPersonEntity.self)
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .onAppear {
            vm.fetch()
        }
        .task {
            if catalog.catalog.isEmpty {
                catalog.getCatalogVM()
                print("empty catalog")
            }
        }
        
        
    }
    
    
    
    private func createEntity(_ item: CatalogPerson) -> CatalogPersonEntity {
        return CatalogPersonEntity(item: item, context: vm.dataManager.context)
    }
    
    
    var mockData = [CatalogPerson(id: Int.random(in: 0...999),
                                  title: "Роман Рáтушний «Сенека»",
                                  url: "roman-ratushnyi-seneka",
                                  alias: "Активіст, журналіст, доброволець",
                                  imageID: Int.random(in: 0...999)),
                    CatalogPerson(id: Int.random(in: 0...999),
                                  title: "Роман Рáтушний «Сенека»",
                                  url: "roman-ratushnyi-seneka",
                                  alias: "Активіст, журналіст, доброволець",
                                  imageID: Int.random(in: 0...999)),
                    CatalogPerson(id: Int.random(in: 0...999),
                                  title: "Роман Рáтушний «Сенека»",
                                  url: "roman-ratushnyi-seneka",
                                  alias: "Активіст, журналіст, доброволець",
                                  imageID: Int.random(in: 0...999))]
}

#Preview {
    CheckCoreData()
}
