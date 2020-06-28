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


    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .green

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

struct RouteHeader_Previews: PreviewProvider {
    static var previews: some View {
//        RouteHeader()
//        Text("helo")
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
