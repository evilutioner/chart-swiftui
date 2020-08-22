//
//  ChartView.swift
//  Chat
//
//  Created by Oleg Marchik on 8/18/20.
//  Copyright © 2020 Oleg Marchik. All rights reserved.
//

import SwiftUI

import AVFoundation

struct AnimatableModifierDouble: AnimatableModifier {

    var targetValue: Double

    var animatableData: Double {
        didSet {
            checkIfFinished()
        }
    }

    private let completion: () -> ()

    init(bindedValue: Double, completion: @escaping () -> ()) {
        self.completion = completion

        self.animatableData = bindedValue
        targetValue = bindedValue
    }

    func checkIfFinished() -> () {
        if animatableData == targetValue {
            DispatchQueue.main.async {
                self.completion()
            }
        }
    }

    func body(content: Content) -> some View {
        content.animation(nil)
    }
}

struct ChartView: View {
    @State var inputLines: [ChatLine]
    @State var lines = [ChatLine]()
    @State var animateLine: ChatLine?
    @State var lastBubbleOpacity: Double = 0
    let ttsEngine = TTSEngine()
    
    private func applyChartFrame<V: View>(view: V, metrics: GeometryProxy) -> some View {
        return view
            .frame(maxWidth: metrics.size.width * 0.75, alignment: .bottomLeading)
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 30, trailing: 0))
    }
    
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
                
//                withAnimation(Animation.easeOut(duration: 1).delay(1)) {
//                    self.proccessNextLine()
//                }
                
            }.frame(alignment: .bottomLeading)
        }.background(Color(hex: "FDFDFE"))
            .onAppear {
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
        ChartView(inputLines: [.init(text: "kdflkfldk dfkjfkdj  flkjd jf kdjfk f jj fkjdfkjdkj fkjdkfj kdjf k"),
        .init(text: "dkslkdlskj")])
    }
}


final class TTSEngine: NSObject {
    private let speechSynthesizer = AVSpeechSynthesizer()
    private let voice = AVSpeechSynthesisVoice(language: "English")
    private var completion: (() -> Void)?
    
    override init() {
        super.init()
        self.speechSynthesizer.delegate = self
    }
    
    func speak(text: String, completion: (() -> Void)?) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        self.completion = completion
        speechSynthesizer.speak(utterance)
    }
}
extension TTSEngine: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        completion?()
        completion = nil
    }
}
