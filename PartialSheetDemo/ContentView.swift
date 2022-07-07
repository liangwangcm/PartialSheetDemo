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

            VStack(spacing: 0) {
                TopHandleBar()
                self.content
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
            }
            .padding(.bottom)
            .zIndex(2)
            .transition(.move(edge: .bottom))
        }
      }
      .ignoresSafeArea()
    )
  }
}

fileprivate struct TopHandleBar: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: CGFloat(5.0) / 2.0)
                .frame(width: 40, height: 5)
                .foregroundColor(.secondary)
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10, corners: [.topLeft, .topRight])
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

fileprivate extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

fileprivate struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


struct CustomComponents_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

