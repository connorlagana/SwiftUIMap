//
//  RouteHeader.swift
//  SwiftUIMap
//
//  Created by Connor Lagana on 6/28/20.
//  Copyright © 2020 Connor Lagana. All rights reserved.
//

import SwiftUI

//struct RouteHeader: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}

class RouteHeader: UICollectionReusableView {
    
    var nameLabel: UILabel = UILabel(text: "Name", font: .systemFont(ofSize: 16), textColor: .black)
    let distanceLabel: UILabel = UILabel(text: "Distance", font: .systemFont(ofSize: 16), textColor: .black)
    let estimatedTimeLabel: UILabel = UILabel(text: "Time", font: .systemFont(ofSize: 16), textColor: .black)


    override init(frame: CGRect) {
        super.init(frame: frame)

//        backgroundColor = .green
        
        hstack(stack(nameLabel,
                     distanceLabel,
                     estimatedTimeLabel,
                     spacing: 8),
               alignment: .center
        ).withMargins(.allSides(16))
        
        nameLabel.attributedText = generateAttributedString(title: "Route", description: "US 101S")
        distanceLabel.attributedText = generateAttributedString(title: "Distance", description: "69mi")
    }
    
    public func generateAttributedString(title: String, description: String) -> NSAttributedString {
        
        let attStr = NSMutableAttributedString(string: title + ": ", attributes: [.font: UIFont.systemFont(ofSize: 16)])
        
        attStr.append(.init(string: description, attributes: [.font: UIFont.systemFont(ofSize: 16)]))
        
        return attStr
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

struct RouteHeader_Previews: PreviewProvider {
    static var previews: some View {
//        RouteHeader()
//        Text("helo woprld")
        Container()
    }
    
    
    struct Container: UIViewRepresentable {
        
        func makeUIView(context: Context) -> some UIView {
            RouteHeader()
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
        
    }
}
