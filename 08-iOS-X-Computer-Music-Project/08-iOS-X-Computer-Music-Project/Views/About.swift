//
//  AboutView.swift
//  07
//
//  Created by Gwangyu Lee on 8/20/25.
//

import SwiftUI

struct About: View {
    var body: some View {
        
        List {
            Text("About")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("""
                        이 앱은 동국대학교 영상대학원 MARTE Lab에서 진행된 2025 Swift Sound - Creative Coding for Computer Musicians 프로젝트를 통해 개발된 애플리케이션입니다. 김연호, 김태준, 손서율, ???, ???, ???이 참여하여 완성했습니다.
                        모든 사운드는 FM 합성(Frequency Modulation Synthesis)을 기반으로 구현되었습니다. 터치 인터랙션과 아이폰 센서(자이로, 나침반 등)를 활용하여 사용자가 손끝의 움직임이나 기기의 기울임만으로도 사운드를 조작하고 새로운 음악적 경험을 탐구할 수 있습니다.
                        또한 본 프로젝트는 연구와 학습의 공유를 중요하게 여기며, 스터디 과정과 앱의 소스코드 전체를 오픈소스로 공개하였습니다. 누구나 아래 깃허브 링크를 통해 접근할 수 있으며, 이를 기반으로 자유롭게 학습하고 확장해 나갈 수 있습니다.
                        """)
            //            .font(.headline)
            
            Link("GitHub 🔗",
                 destination: URL(string: "https://github.com/gwangyu-lee/2025-Swift-Sound-Creative-Coding-for-Computer-Musicians")!
            )
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            // MARK: Test
            VStack(alignment: .leading) {
                Text("테스트 - 이관규")
                    .bold()
                Text("""
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    
    기술설명 : Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    
    """)
                
                Link("Website 🔗",
                     destination: URL(string: "https://www.gwangyulee.com")!
                )
                .font(.headline)
            }
            
            // MARK: 김연호
            VStack(alignment: .leading) {
                Text("매미 - 김연호")
                    .bold()
                Text("""
     시끄러운 FM 합성 사운드에는 역시 매미가 딱! 여러분도 한번 만들어 보세요. 드디어 여름이 지나가서 살 것 같은데, '여름 감성 ~ ' 어쩌구 하는 친구들의 귀에 FM 매미의 사운드로 참교육을 해봐요! 
    
     The noisy FM synthesis sound just suits the cicada perfectly! You should try making one too. Summer's finally over and I feel like I can live again, so let's properly school those friends who talk about 'Summer Vibes' with a dose of FM Cicada sound!
    """)
            }
            
            // MARK: 김태준
            VStack(alignment: .leading) {
                Text("Annoying kid - 김태준")
                    .bold()
                Text("""
    아이의 짜증을 표현하였습니다.
    어른들도 때론 아이처럼 짜증내고 싶죠...
    맘껏 짜증내시길
    
    기술설명 : 나침반 센서를 이용하여 FM의 음색을 조절하고, Y축의 기울임으로 음량을 조절하고, X축의 기울임으로 주파수(220~880Hz)를 조절합니다.
    """)
            }
            
            // MARK: 손서율
            VStack(alignment: .leading) {
                Text("Tissue - 손서율")
                    .bold()
                Text("""
    힘들 땐 웃는 자가 일류라죠.
    슬플 땐 휴지를 뽑아 눈물을 닦고...
    남은 휴지로 간식도 싸드세요. 다용도입니다. :)
    """)
            }
            
            Text("NAME \n Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
            
            Text("NAME \n Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
            
            Text("NAME \n Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
            
            Text("NAME \n Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
            
            
        }
        //            .listStyle(.inset)
        .padding(0)
        
    }
}

#Preview {
    About()
}
