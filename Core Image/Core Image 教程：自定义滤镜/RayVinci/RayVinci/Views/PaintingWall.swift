/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct PaintingWall: View {
    @State private var selectedPainting: Painting?
    let paintings: [Painting]
    let columns = [GridItem()]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                ForEach(0..<paintings.count) { index in
                    ZStack {
                        Button(
                            action: {
                                selectedPainting = paintings[index]
                                var effect = ProcessEffect.builtIn
                                if let painting = selectedPainting {
                                    switch index {
                                    case 0:
                                        // 应用内置滤镜
                                        effect = .builtIn
                                    case 1:
                                        // 应用颜色滤镜
                                        effect = .colorKernel
                                    case 2:
                                        // 应用变形滤镜
                                        effect = .warpKernel
                                    case 3:
                                        // 应用内置的混合滤镜
                                        effect = .blendKernel
                                    default:
                                        effect = .builtIn
                                    }
                                    // 通过在 ImageProcessor 上调用 process(painting:, effect:) 来应用滤镜
                                    ImageProcessor.shared.process(painting: painting, effect: effect)
                                }
                            },
                            label: {
                                Image(paintings[index].image)
                                    .resizable()
                                    .scaledToFit()
                                    .overlay(OverlayContent(title: paintings[index].name), alignment: .bottom)
                            })
                    }
                }
            }
        }
        .sheet(item: $selectedPainting) { item in
            DetailView(painting: item)
        }
    }
}

struct OverlayContent: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.regular)
            .frame(maxWidth: .infinity)
            .foregroundColor(Color.black)
            .background(Color.white)
            .opacity(0.7)
    }
}

struct DetailView: View {
    var imageProcessor = ImageProcessor.shared
    let painting: Painting

    var body: some View {
        ScrollView {
            VStack {
                Image(painting.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(OverlayContent(title: "Input"), alignment: .bottom)
                Image(uiImage: imageProcessor.output)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(OverlayContent(title: "Output"), alignment: .bottom)
            }
        }
        .padding()
    }
}

struct PaintingWall_Previews: PreviewProvider {
    static var previews: some View {
        let paintings = Gallery().paintings
        PaintingWall(paintings: paintings)
    }
}
