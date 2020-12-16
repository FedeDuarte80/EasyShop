import SwiftUI

struct SettingsTheme: View {
    @ObservedObject var theme = ThemeSettings()
    let themes: [Theme] = themeData
    @State private var isThemeChanged: Bool = false
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("App Theme")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 35) {
                            ForEach(themes, id: \.id) { item in
                                Button(action: {
                                    gThemeSettings.themeSettings = item.id
                                    UserDefaults.standard.set(self.theme.themeSettings, forKey: "Theme")
                                    self.isThemeChanged.toggle()
                                }) {
                                    VStack {
// MARK: - Card
                                        VStack {
                                            Spacer()
                                            Divider()
                                                .frame(width: 50, height: 3)
                                                .background(item.mainColor)
                                            Image(systemName: "tray.and.arrow.down.fill")
                                                .foregroundColor(item.mainColor)
                                                .font(.system(size: 35, weight: .regular))
                                            Spacer().frame(height: 45)
                                            Divider().background(Color.gray)
// MARK: - Tabbar
                                            HStack(spacing: 20) {
                                                Rectangle()
                                                    .frame(width: 10, height: 10)
                                                    .foregroundColor(item.mainColor)
                                                Rectangle()
                                                    .frame(width: 10, height: 10)
                                                    .foregroundColor(Color.gray)
                                                Rectangle()
                                                    .frame(width: 10, height: 10)
                                                    .foregroundColor(Color.gray)
                                            }.padding(.bottom, 12)
                                        }
                                        .frame(width: 110, height: 180)
                                        .mask(RoundedRectangle(cornerRadius: 12))
                                        .overlay(RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray))
// MARK: - Label
                                        Text(item.themeName)
                                            .font(.headline)
                                            .font(Font.system(size: 20, design: .serif))
                                    } // VS
                                }.accentColor(Color.primary)
                            }.padding(.horizontal, 5)
                        }
                    }
// MARK: - Alert
                    .alert(isPresented: $isThemeChanged) {
                        Alert(
                            title: Text("DONE!"),
                            message: Text("\(themes[self.theme.themeSettings].themeName) is ON!!!"),
                            dismissButton: .default(Text("Ok"))
                    )}
                }
            }
        }
    }
}

// MARK: - PREVIEW
struct SettingsTheme_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SettingsTheme()
                .padding()
                .previewLayout(.sizeThatFits)
            
            SettingsTheme()
                .padding()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
