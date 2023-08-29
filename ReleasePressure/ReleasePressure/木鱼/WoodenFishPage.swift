//
//  WoodenFishPage.swift
//  ReleasePressure
//
//  Created by 王琨 on 2023/7/21.
//

import SwiftUI
struct WoodenFishPage : View {
    
    struct Test {
        
    }
    
    var randomInt : Int
    var player = VoicePlayer.init(with: "muyu0_0.wav")
    @State var index = 0
    
    var textList = [
        ["焦虑走","忧愁散","一切烦劳都滚蛋","烦劳-1"],
        ["感觉累","躺下睡","困完一觉无所谓","快乐+1"],
        ["今生苦","修来世","满天神佛帮你治","功德+1"]
    ]
    
    @State var isShowText = false
    @State var offsetY:CGFloat = 0
    @State var count = 0
    
    //点击一下加1 然后开始
    
    var body: some View {
        
        
        ZStack {
            Image("muyu").resizable().offset(x: 0, y: 100).frame(width: 300, height: 300, alignment: .center).onTapGesture {
                player.playaudio()
                //出现一个新的text 然后动画
                count += 1
                offsetY = -100
                isShowText = true
            }
            VStack(spacing: 10) {
                ForEach(0 ..< count,id: \.self) {number in
                    Text("功德+1").foregroundColor(.pink).padding().frame(width: 100, height: 20, alignment: .center).offset(y:offsetY) animation(.easeInOut(duration: 1), value: offsetY)
                }
            }.onAppear {
                count = 0
                isShowText = false
            }
            
            
            
            

        }.frame(maxWidth: .infinity,maxHeight: .infinity).background(Color.black).ignoresSafeArea()

    }
}


struct AnimationText : View {
    
    private let timer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()

    @State var title = "kkk"
    @State var isShow = true
    @State var count = 0
    
    var body: some View {
        VStack {
            Text(title).offset(y: CGFloat(-20 * count)).opacity(count % 3 == 0 ? 0 : 1).foregroundColor(Color.white)
        }.onReceive(timer) { _ in
            withAnimation(.spring()) {
                count += 1
                if count > 3 {
                    count = 0
                }
            }
        }
               

    }
    
}
