import SwiftUI
import CoreData

struct SelectedItemView: View {

    @ObservedObject var store: Shop
    
    var body: some View {
        VStack {
            List {
                ForEach(store.getItem.filter({ $0.select })) { s in
                    HStack {
                        Text(s.itemName)//.id(UUID())
                            .font(Font.system(size: 20))
                            .padding(.leading, 20)
                        Spacer()
                    }.frame(height: rowHeight)
                }
            }.listStyle(GroupedListStyle())
        }.navigationTitle("Products")
    }
}

struct SelectedItemView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let data = Shop(context: moc)
        data.name = "Carrefour"
        let datum = Item(context: moc)
        datum.name = "Chicken"
        data.addToItem(datum)
        return SelectedItemView(store: data)
    }
}
