//
//  Scenario.swift
//  Chat
//
//  Created by Oleg Marchik on 8/21/20.
//  Copyright © 2020 Oleg Marchik. All rights reserved.
//

import  Foundation

final class Scenario {
    private struct Line: Decodable {
        var line: String
    }
    
    let messages: [ChatMessage]
    
    init() {
        let array = (try? Bundle.main.decode([Line].self, from: "scenario.json")) ?? []
        messages = array.map { ChatMessage(text: $0.line) }
    }
}


private extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) throws -> T? {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else { return nil }
        let data = try Data(contentsOf: url)
        let object = try JSONDecoder().decode(T.self, from: data)
        return object
    }
}
