//
//  ChartBubble.swift
//  Chat
//
//  Created by Oleg Marchik on 8/5/20.
//  Copyright © 2020 Oleg Marchik. All rights reserved.
//

import SwiftUI

typealias ChatLine = ChatMessage
struct ChatMessage: Identifiable {
    var id = UUID()
    let text: String
}

struct BubbleShape: Shape {
    let borderRadius: CGFloat = 5
    let tailSize = CGSize(width: 11, height: 18)
    
    func path(in rect: CGRect) -> Path {
        return Path { (path) in
            path.move(to: .init(x: 0, y: rect.maxY))
            path.addLine(to: .init(x: tailSize.width, y: rect.maxY - tailSize.height))
            path.addLine(to: .init(x: tailSize.width, y: borderRadius))
            path.addArc(center: .init(x: borderRadius + tailSize.width, y: borderRadius), radius: borderRadius, startAngle: .degrees(-180), endAngle: .degrees(-90), clockwise: false)
            path.addLine(to: .init(x: rect.maxX - borderRadius, y: 0))
            path.addArc(center: .init(x: rect.maxX - borderRadius, y: borderRadius), radius: borderRadius, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
            path.addLine(to: .init(x: rect.maxX, y: rect.maxY - borderRadius))
            path.addArc(center: .init(x: rect.maxX - borderRadius, y: rect.maxY - borderRadius), radius: borderRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            path.addLine(to: .init(x: 0, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

struct ChartBubble: View {
    var chatMessage: ChatMessage
    var body: some View {
        Text(chatMessage.text)
            .padding(EdgeInsets(top: 10, leading: 21, bottom: 10, trailing: 10))
            .background(
                BubbleShape()
                    .fill()
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 4, x: 1, y: 1)
            )
    }
}

struct ChartBubble_Previews: PreviewProvider {
    static var previews: some View {
        ChartBubble(chatMessage: .init(text: "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."))
    }
}
