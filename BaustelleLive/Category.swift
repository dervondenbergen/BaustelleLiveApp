//
//  Category.swift
//  BaustelleLive
//
//  Created by Felix De Montis on 26.08.21.
//

import SwiftUI
import DynamicColor

struct CategoryModifier: ViewModifier {
    var color: Color
    var background: Color
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        let darkerBackground = Color(DynamicColor(background).darkened())
        
        return content
            .padding(.horizontal, 5)
            .padding(.vertical, 3)
            .font(Font.system(size: 14, weight: .semibold))
            .textCase(.uppercase)
            .foregroundColor(color)
            .background(LinearGradient(
                            gradient: Gradient(colors: [darkerBackground, background]),
                            startPoint: .topLeading,
                            endPoint: .bottom
            ))
            .cornerRadius(cornerRadius)
    }
}

extension View {
    func category(
        color: Color = .white,
        background: Color = .gray,
        cornerRadius: CGFloat = 4
    ) -> some View {
        modifier(CategoryModifier(
                    color: color,
                    background: background,
                    cornerRadius: cornerRadius
        ))
    }
}

@available(iOS 14.0, *)
struct ModifierLibrary: LibraryContentProvider {
  @LibraryContentBuilder
  func modifiers(base: Text) -> [LibraryItem] {
    LibraryItem(base.category(), category: .effect)
  }
}

struct Category_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 10) {
            Text("Hello, World!")
                .category()
            
            Text("Alarm, World!")
                .category(background: .red)
            
            Text("Yellow, World!")
                .category(color: .yellow)
            
            Text("Party !!")
                .category(color: .pink, background: .blue)
            
            Text("Custom Color")
                .category(background: Color(hexString: "bada55"))
            
            Text("oiiio")
                .category(cornerRadius: 10)
        }
        .padding(10)
        .previewLayout(.sizeThatFits)
    }
}
