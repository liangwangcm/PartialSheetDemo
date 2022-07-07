import SwiftUI

struct ContentView: View {
  @State var count: Int?
    @State private var showPartialSheet = false
    @State private var showSheet = false

  var body: some View {
    Form {

      Button("Show custom partial sheet") {
        withAnimation {
          self.count = 0
            self.showPartialSheet = true
        }
      }
        
    Button("Show normal sheet") {
      withAnimation {
          self.showSheet = true
      }
    }
    }
    .partialSheet($showPartialSheet, content: {
        VStack {
            Text("This is partial sheet content")
        }
        .frame(width: UIScreen.main.bounds.width, height: 300)
        .background(Color.pink)
    
    })
    .sheet(isPresented: $showSheet, content: {
        ZStack {
            Color.orange
            Text("this is normal sheet")
        }
    })
    .navigationTitle("Demo")
  }
}

private struct PartialSheetModifier<PartialSheetContent>: ViewModifier
where PartialSheetContent: View {
  @Binding var isActive: Bool
    let content: PartialSheetContent
    
    init(isActive: Binding<Bool>, @ViewBuilder content: () -> PartialSheetContent) {
        self._isActive = isActive
        self.content = content()
    }

  func body(content: Content) -> some View {
    content.overlay(
      ZStack(alignment: .bottom) {
        if self.isActive {
          Rectangle()
            .fill(Color.black.opacity(0.4))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onTapGesture {
              withAnimation {
                self.isActive = false
              }
            }
            .zIndex(1)
            .transition(.opacity)

          self.content
            .background(Color.white)
            .frame(maxWidth: .infinity)
            .padding(.bottom)
            .zIndex(2)
            .transition(.move(edge: .bottom))
        }
      }
      .ignoresSafeArea()
    )
  }
}

extension View {


  fileprivate func partialSheet<Content>(
    _ showPartialSheet: Binding<Bool>,
    @ViewBuilder content: @escaping () -> Content
  ) -> some View
  where Content: View {
    self.modifier(
        PartialSheetModifier(isActive: showPartialSheet, content: content)
    )
  }

}

struct CustomComponents_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

