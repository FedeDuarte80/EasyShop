import SwiftUI
import CoreData

struct ShopList: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Shop.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Shop.order, ascending: true)]
    ) var shops: FetchedResults<Shop>
    @State var name = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        TextField("name of the shop", text: self.$name).modifier(customTextfield())
                        Button(action: { newShop()  }) {
                            Image(systemName: "plus")
                                .imageScale(.large)
                                .frame(width: 40, height: 40)
                        }.disabled(name.isEmpty)
                        .padding()
                    } // HS
                    .frame(width: .infinity, height: 60)
                }
                Section {
                    ForEach(shops, id: \.self) { s in
                        NavigationLink(destination: ItemList(store: s)) {
                            ShopListRow(store: s).id(UUID())
                        }
                    }.onDelete(perform: deleteShop)
                    
                }
            }
            .navigationBarTitle(("Shops"), displayMode: .inline)
        }
    }
    func newShop() {
        withAnimation {
            let addShop = Shop(context: moc)
            addShop.name = self.name
            addShop.order = (shops.last?.order ?? 0) + 1
            addShop.select = false
            PersistentContainer.saveContext()
            self.name = ""
        }
    }
    func deleteShop(at offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                self.moc.delete(self.shops[index])
            }
            PersistentContainer.saveContext()
        }
    }
}

// MARK: - PREVIEWS

struct ShopList_Previews: PreviewProvider {
    static var previews: some View {
       ShopList().environment(\.managedObjectContext, PersistentContainer.persistentContainer.viewContext)
    }
}


