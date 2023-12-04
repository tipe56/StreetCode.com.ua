//
//  StreetcodeRedButton.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 29.11.23.
//

import SwiftUI

struct StreetcodeRedButton: View {
    var title: String
    
    var body: some View {
        Button {
            //
        } label: {
            Text(title)
                .radiusButtonStyle()
        }
    }
}

#Preview {
    StreetcodeRedButton(title: "Learn more")
}
