//
//  ProgressImageView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 18.01.24.
//

import SwiftUI

struct ProgressImageView: View {
    struct ViewModel {
        var image: Image?
        var offsetY: CGFloat = 0
    }
    
    var viewModel: ViewModel?
    
    var body: some View {
        if let image = viewModel?.image,
           let offset = viewModel?.offsetY {
            image.resizable().offset(y: offset)
        } else {
            ProgressView()
        }
    }
}

#Preview {
    ProgressImageView(viewModel: ProgressImageView.ViewModel(image: nil, offsetY: 0))
}
