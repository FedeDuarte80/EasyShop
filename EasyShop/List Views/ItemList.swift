import SwiftUI
import CoreData

struct ItemList: View {
    @Environment(\.presentationMode) var present
    @ObservedObject var store: Shop
    @ObservedObject var theme = gThemeSettings
    @State var name = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Section {
                HStack(spacing: 0) {
// MARK: - HEADER
                    Button(action: { newItem() }) {
                        Image(systemName: "plus")
                            .modifier(customButton())
                            .opacity(name.isEmpty ? 0.4 : 1.0)
                            .background(Color("ColorWhiteBlack"))
                    }.disabled(name.isEmpty)
                    TextField("new product here...", text: $name)
                        .modifier(customTextfield())
                    Text("\(store.getItem.count)").padding(15)
                }.modifier(customHStack())
            } // SE
            Section {
// MARK: - LIST
                List {
                    ForEach(store.getItem) { s in ItemListRow(item: s) }
                    .onDelete(perform: deleteItem)
                    .onMove(perform: doMove)
                }.listStyle(GroupedListStyle())
// MARK: - Footer
            }
            Section {
                Rectangle()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 1, idealHeight: 1, maxHeight: 1)
                HStack {
                    Button(action: { deselectAll() }) {
                        Text("Deselect All").padding(.leading)
                    }.disabled((store.getItem.filter({ $0.status == kNotOnList }).count != 0) == true)
                    Spacer()
                    Button(action: { selectAll() }) {
                        Text("Select All").padding(.trailing)
                    }.disabled((store.getItem.filter({ $0.status == kOnListNotTaken }).count != 0) == true)
                }.padding(6)
            }
        }
        .navigationTitle("\(store.shopName)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
// MARK: - TOOLBAR
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { present.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left").font(.system(size: 16, weight: .regular))
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .onAppear { print("ItemList appears") }
        .onDisappear { print("ItemList disappers") }
    }
// MARK: - FUNCTIONS
    func newItem() {
        Item.addNewItem(named: name, to: store)
        self.name = ""
        print("New Item created")
    }
    func deleteItem(at offsets: IndexSet) {
        let items = store.getItem
        for index in offsets {
            Item.delete(items[index])
        }
        PersistentContainer.saveContext()
        print("Item deleted")
    }
    private func doMove(from indexes: IndexSet, to destinationIndex: Int) {
        let sourceIndex = indexes.first!
// let’s say for the moment we’ll only move the first item
// print out what we’re going to do in terms of what gets moved by index
        print("move from \(sourceIndex) to \(destinationIndex)")
// nothing to do if indices are the same.  this can happen: the user begins
// to drag, but then sort of drops it where she started.
        guard sourceIndex != destinationIndex else {
            return
                
        }
    }
    func selectAll() { // Test
        print("selectAll function executed")
        for item in store.getItem {
            if item.status == kNotOnList {
                item.status = kOnListNotTaken
            }
        }
    }
    func deselectAll() { // Test
        print("deselectAll function executed")
        for item in store.getItem {
            if item.status == kOnListNotTaken {
                item.status = kNotOnList
            }
        }
    }
}

// MARK: - ITEM ROW

struct ItemListRow: View {
    @ObservedObject var item: Item
    @ObservedObject var theme = gThemeSettings
    
    var body: some View {
        Button(action: {
            self.item.toggleSelected()
            print("item added to List not taken")
        }) {
            HStack {
                Text(item.itemName).modifier(customItemText())
                Spacer()
                Image(systemName: item.status != kOnListNotTaken ? "circle" : "checkmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(theme.mainColor)
            }.frame(height: rowHeight)
        }.onReceive(self.item.objectWillChange) { PersistentContainer.saveContext()
        }
    }
}

// MARK: - PREVIEWS

struct ItemList_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let data = Shop(context: moc)
        data.name = "K-Mart"
        let datum = Item(context: moc)
        datum.name = "Eggs"
        data.addToItem(datum)
        return ItemList(store: data) 
            .environment(\.managedObjectContext, PersistentContainer.persistentContainer.viewContext)
    }
}

struct ItemListRow_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let datum = Item(context: moc)
        datum.name = "Chicken"
        return Group {
            ItemListRow(item: datum)
                .padding()
                .previewLayout(.sizeThatFits)
            ItemListRow(item: datum)
                .preferredColorScheme(.dark)
                .padding()
                .previewLayout(.sizeThatFits)
        }
    }
}



