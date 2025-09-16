import SwiftUI

struct MainView: View {
    var body: some View {
        Color.red
            .ignoresSafeArea()
    }
}

struct Sidebar: View {
    var body: some View {
        Color.blue
            .ignoresSafeArea()
    }
}

struct ContentView: View {
    var sideBarWidth = UIScreen.main.bounds.size.width * 0.8

    @State private var isSideBarOpened = false
    @State var offset: CGFloat = 0
    @GestureState var gestureOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                MainView()
                    .offset(x: max(self.offset + self.gestureOffset, 0))
                    .animation(.interactiveSpring(
                        response: 0.5,
                        dampingFraction: 0.8,
                        blendDuration: 0),
                               value: gestureOffset
                    )
                    .overlay(
                        GeometryReader { _ in
                            EmptyView()
                        }
                        .background(.black.opacity(0.6))
                        .opacity(getBlurRadius())
                        .animation(.interactiveSpring(
                            response: 0.5,
                            dampingFraction: 0.8,
                            blendDuration: 0),
                                   value: isSideBarOpened)
                        .onTapGesture {
                            withAnimation { isSideBarOpened.toggle() }
                        }
                    )

                Sidebar()
                .frame(width:  sideBarWidth)
                .animation(.interactiveSpring(
                    response: 0.5,
                    dampingFraction: 0.8,
                    blendDuration: 0),
                           value: gestureOffset
                )
                .offset(x: -sideBarWidth)
                .offset(x: max(self.offset + self.gestureOffset, 0))
            }
            .gesture(
                DragGesture()
                    .updating($gestureOffset, body: { value, out, _ in
                        if value.translation.width > 0 && isSideBarOpened {
                            out = value.translation.width * 0.1
                        } else {
                            out = min(value.translation.width, sideBarWidth)
                        }
                    })
                    .onEnded(onEnd(value:))
            )
            .onChange(of: isSideBarOpened) { _, newValue in
                withAnimation {
                    if newValue {
                        offset = sideBarWidth
                    } else {
                        offset = 0
                    }
                }
            }
        }
    }

    func onEnd(value: DragGesture.Value){
        let translation = value.translation.width
        if translation > 0 && translation > (sideBarWidth * 0.6) {
            isSideBarOpened = true
        } else if -translation > (sideBarWidth / 2) {
            isSideBarOpened = false
        } else {
            if offset == 0 || !isSideBarOpened{
                return
            }
            isSideBarOpened = true
        }
    }

    func getBlurRadius() -> CGFloat {
        let progress =  (offset + gestureOffset) / (UIScreen.main.bounds.height * 0.50)
        return progress
    }
}

#Preview {
    ContentView()
}
