//
//  ChartView.swift
//  Chat
//
//  Created by Oleg Marchik on 8/18/20.
//  Copyright © 2020 Oleg Marchik. All rights reserved.
//

import SwiftUI

struct ChartView: View {
    @State var inputLines: [ChatLine]
    @State var lines = [ChatLine]()
    @State var animateLine: ChatLine?
    @State var lastBubbleOpacity: Double = 0
    let ttsEngine = TTSEngine()
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                ForEach(self.lines, id: \.id) { line in
                    ChartBubble(chatMessage: line)
                        .frame(maxWidth: metrics.size.width * 0.75, alignment: .bottomLeading)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 30, trailing: 0))
                        .animation(.easeInOut(duration: 1.0))
                        .transition(AnyTransition.opacity.combined(with: .slide))
                }
                
            }.frame(alignment: .bottomLeading)
        }.onAppear {
                self.proccessNextLine()
        }
    }
    
    private func proccessNextLine() {
        guard !inputLines.isEmpty else { return }
        let line = inputLines.removeFirst()
        lines.append(line)
        
        self.ttsEngine.speak(text: line.text) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.proccessNextLine()
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(inputLines: [.init(text: "Ut enim ad minim veniam"),
        .init(text: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.")])
    }
}
