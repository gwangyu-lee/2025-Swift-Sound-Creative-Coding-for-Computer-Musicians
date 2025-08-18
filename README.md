# 2025-Swift-Sound-Creative-Coding-for-Computer-Musicians

MARTE Lab, Graduate School of Digital Image & Contents, Dongguk University, Seoul    


```swift

import SwiftUI

struct ContentView: View {
    
    // 아이폰 width 가져오기
    let screenWidth = UIScreen.main.bounds.width
    let offsetWidth: CGFloat = 100
    
    let myScreenWidth = UIScreen.main.bounds.width - 100 // offset
    
    var body: some View {
        
        // 여기서부터 세로로 쌓기
        VStack {
            
            // Title
            Text("Swift Sound 100")
                .font(.title)
                .fontWeight(.bold)
            
            // 여기서부터 그룹박스안에 집어넣기
            GroupBox{
                HStack {
                    Text("Position")
                    Spacer()
                    Text("Top")
                }
                
                HStack {
                    Text("Position")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Top")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(width: screenWidth - offsetWidth)
            } // 그룹박스 끝나로 컬러 설정
            .foregroundStyle(.red) // text
            .backgroundStyle(.blue.opacity(0.2)) // fill color
            
            Link("Swift Study GitHub",
                  destination: URL(string: "https://github.com/gwangyu-lee/2025-Swift-Sound-Creative-Coding-for-Computer-Musicians")!)
            .foregroundStyle(.red)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

```
## Useful Links
<a href="https://developer.apple.com/design/human-interface-guidelines/" target="_blank">Apple Design Guidelines</a>   
<a href="https://developer.apple.com/sf-symbols/" target="_blank">SF Symbols</a>   

## Books
Apple Inc., *The Swift Programming Language(Swift 5.7)*, 2014    
KxCoding, *Hello, Swift*, 2019
