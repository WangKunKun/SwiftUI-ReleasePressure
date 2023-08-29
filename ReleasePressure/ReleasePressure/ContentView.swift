//
//  ContentView.swift
//  ReleasePressure
//
//  Created by 王琨 on 2023/7/21.
//

import SwiftUI

struct AnimatableCustomFontModifier: AnimatableModifier {
    var name: String
    var size: CGFloat

    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.custom(name, size: size))
    }
}

// 为了使其更易于使用，我建议将其包装在 `View` 扩展中，如下所示：
extension View {
    func animatableFont(name: String, size: CGFloat) -> some View {
        self.modifier(AnimatableCustomFontModifier(name: name, size: size))
    }
}

struct ContentView: View {
    
    
    var animation = Animation.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 1)
    
    @State var fontSize:CGFloat = 30
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Make in India").bold()
                Divider()
                
//                WoodenFishPage.init(randomInt: Int.random(in: 0...12))
//                MagicShapePage()
                NavigationLink(destination:WoodenFishPage.init(randomInt: Int.random(in: 0...12)) ) {
                    Text("压力释放").animatableFont(name: "Georgia", size: fontSize).onAppear {
                        withAnimation(animation) {
                            self.fontSize = 50
                        }
                    }
                }
                
            }
            .padding()
        }.navigationTitle("释放吧，压力！")
    }
    
    

    
    func randomRelase() {
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
