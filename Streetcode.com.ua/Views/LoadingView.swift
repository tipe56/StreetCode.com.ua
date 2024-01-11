//
//  LoadingView.swift
//  Streetcode.com.ua
//
//  Created by Siarhei Ramaniuk on 27.12.23.
//

import SwiftUI
import Combine

struct LoadingView: View {
    private let images: [UIImage]
    private let timer: Timer.TimerPublisher

    @State private var index = 0



    init(gifName: String) {
      guard let bundleURL = Bundle.main.url(forResource: gifName, withExtension: "gif"),
            let data = try? Data(contentsOf: bundleURL),
            let source = CGImageSourceCreateWithData(data as CFData, nil) else {
          self.images = []
          self.timer = Timer.publish(every: 0,
                                     on: .main,
                                     in: .common)//.autoconnect()

          return
      }

      let frameCount = CGImageSourceGetCount(source)
      var frames: [UIImage] = []
      var gifDuration = 0.0

      for i in 0..<frameCount {
          guard let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }

          if let properties = CGImageSourceCopyPropertiesAtIndex(source, i, nil),
             let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
             let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) {
              gifDuration += frameDuration.doubleValue
          }

          let frameImage = UIImage(cgImage: cgImage)
          frames.append(frameImage)
      }

      self.images = frames
      self.timer = Timer.publish(every: gifDuration / Double(frames.count),
                                 on: .main,
                                 in: .common)//.autoconnect()
      let test = self.timer.connect()
      test.cancel()
    }

    var body: some View {
      Image(uiImage: images[index])
        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
        .onReceive(timer) { _ in
          let next = index + 1
          index = next < images.count ? next : 0
        }
    }
}

#Preview {
  LoadingView(gifName: "Logo-animation_40")
}

