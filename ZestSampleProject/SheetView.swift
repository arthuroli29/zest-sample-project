//
//  SheetView.swift
//  ZestSampleProject
//
//  Created by Alexander Moller on 10/16/25.
//

import SwiftUI

struct SheetView: View {
    var body: some View {
        VStack {
            Spacer().frame(height: 20)
            Text("Hello world")
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SheetView()
}
