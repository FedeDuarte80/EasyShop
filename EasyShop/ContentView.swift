import SwiftUI // Project on GitHub

struct ContentView: View {
    @ObservedObject var theme = gThemeSettings
    @State private var selected = 1
    @StateObject private var itemStatusChanged = ItemStatusChanged()
    private var badgePosition: CGFloat = 2
    private var tabsCount: CGFloat = 3
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
        
        TabView(selection: $selected) {
            
            ShopList().tabItem {
                Text(NSLocalizedString("tab_list", comment: ""))
                Image("shoplist")
            }.tag(0)
            
            SelectedShopView().tabItem {
                Text(NSLocalizedString("tab_cart", comment: ""))
                Image("shopcart")
            }.tag(1)
            
            SettingsViews().tabItem {
                Text(NSLocalizedString("tab_settings", comment: ""))
                Image("shopsettings")
            }.tag(2)
            
        }.accentColor(theme.mainColor)
                ZStack {
                    Circle().foregroundColor(.red)
                }
                .frame(width: 13, height: 13)
                .offset(x: ( ( 2 * self.badgePosition) - 0.94 ) * ( geometry.size.width / ( 2 * self.tabsCount ) ) + 2, y: -29)
                .opacity(Item.onShoppingListCount() != 0 ? 1.0 : 0)
            }
        }.ignoresSafeArea(.keyboard)
    }
}

var rowHeight: CGFloat = 50

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistentContainer.persistentContainer.viewContext)
    }
}
