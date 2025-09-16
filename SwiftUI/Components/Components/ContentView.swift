import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            NavigationLink {
                ImageView()
            } label: {
                Text("Title")
            }
            Spacer()
        }
    }
}

struct ImageView: View {
    var body: some View {
        NavigationLink {
            TodoView()
        } label: {
            Image(uiImage: .add)
        }

    }
}

struct TodoView: View {
    var body: some View {
        TabView {
            AView()
                .tabItem {
                    Image(systemName: "1.square.fill")
                    Text("First")
                }
            BView()
              .tabItem {
                Image(systemName: "2.square.fill")
                Text("Second")
              }
            CView()
                .tabItem {
                Image(systemName: "3.square.fill")
                Text("Third")
              }
            DView()
                .tabItem {
                    Image(systemName: "4.square.fill")
                    Text("Third")
                }
        }
    }
}

struct AView: View {

    let items = ["Item 1", "Item 2", "Item 3"]
 
    var body: some View {
        List(items, id: \.self) { item in
            Text(item)
        }
    }
}

struct BView: View {
    let colors = ["Red", "Green", "Blue"]
    @State private var selectedColor = "Red"

    var body: some View {
        VStack {
            Picker("Select a color", selection: $selectedColor) {
                ForEach(colors, id: \.self) {
                    Text($0)
                }
            }
            Text("You selected: \(selectedColor)")
        }
        .padding()
    }
}

struct CView: View {
    
    @State private var isPresented = false
    
    var body: some View {
        VStack {
            Toggle(isOn: $isPresented) {
                Text("Toggle")
            }

            if isPresented {
                Text("ON")
            } else {
                Text("Off")
            }
        }
    }
}

struct DView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            DatePicker(
                "Select a date",
                selection: $selectedDate,
                in: Date()...,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            
            Text("Selected date: \(selectedDate)")
        }
    }
}

#Preview {
    ContentView()
}
