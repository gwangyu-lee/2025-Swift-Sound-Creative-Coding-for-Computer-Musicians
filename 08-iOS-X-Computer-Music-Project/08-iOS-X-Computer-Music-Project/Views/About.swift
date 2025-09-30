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
    
    기술설명: 휴지를 뽑을 때 드래그 거리가 길어질수록 캐리어 주파수가 400Hz에서 800Hz로 상승하며 소리가 점점 높아지고, 동시에 modulation index가 1.0에서 2.0으로 증가하면서 배음 구조가 복잡해져 긴장감 있는 음색으로 변합니다. 손을 뗄 때는 뽑은 총 길이가 주파수를, 최고 속도가 modulation index를 결정하여 짧고 느리게 뽑으면 부드럽고 낮은 소리가, 길고 빠르게 뽑으면 날카롭고 복잡한 배음의 소리가 발생합니다. FM ratio는 3.0~3.5로 고정하여 음색 계열의 일관성을 유지하며, 이를 통해 사용자는 제스처의 미세한 강도 차이를 명확한 청각 피드백으로 인지할 수 있습니다.
    
    Those who smile through hardship are truly first-rate. When sadness strikes, pull a tissue to wipe your tears...
    
    And wrap your snacks with the leftover tissue. It's multipurpose. :)
    
    Technical Description: When pulling the tissue, the carrier frequency rises from 400Hz to 800Hz as the drag distance increases, creating a progressively higher pitch, while the modulation index simultaneously increases from 1.0 to 2.0, enriching the harmonic structure and producing a more tense timbre. Upon release, the total pull length determines the frequency, and the peak velocity determines the modulation index—short, slow pulls generate soft, low-pitched sounds, while long, fast pulls produce sharp sounds with complex harmonics. The FM ratio is fixed at 3.0-3.5 to maintain timbral consistency across the sound family, enabling users to perceive subtle differences in gesture intensity through distinct auditory feedback.
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
