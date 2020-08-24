//
//  TTSEngine.swift
//  Chat
//
//  Created by Oleg Marchik on 8/24/20.
//  Copyright © 2020 Oleg Marchik. All rights reserved.
//

import AVFoundation

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

