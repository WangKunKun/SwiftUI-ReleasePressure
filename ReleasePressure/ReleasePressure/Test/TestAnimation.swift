//------------------------------------------------------------------------
// Author: The SwiftUI Lab
// Post: Advanced SwiftUI Animations - Part 4
// Link: https://swiftui-lab.com/swiftui-animations-part4 (TimelineView)
//
import SwiftUI

struct CyclicTimelineSchedule: TimelineSchedule {
    let timeOffsets: [TimeInterval]
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> Entries {
        Entries(last: startDate, offsets: timeOffsets)
    }
    
    struct Entries: Sequence, IteratorProtocol {
        var last: Date
        let offsets: [TimeInterval]
        
        var idx: Int = -1
        
        mutating func next() -> Date? {
            idx = (idx + 1) % offsets.count
            
            last = last.addingTimeInterval(offsets[idx])
            
            return last
        }
    }
}

extension TimelineSchedule where Self == CyclicTimelineSchedule {
    static func cyclic(timeOffsets: [TimeInterval]) -> CyclicTimelineSchedule {
            .init(timeOffsets: timeOffsets)
    }
}

enum KeyFrameAnimation {
    case none
    case linear
    case easeOut
    case easeIn
}

struct KeyFrame {
    let offset: TimeInterval
    let rotation: Double
    let yScale: Double
    let y: CGFloat
    let animationKind: KeyFrameAnimation
    
    var animation: Animation? {
        switch animationKind {
        case .none: return nil
        case .linear: return .linear(duration: offset)
        case .easeIn: return .easeIn(duration: offset)
        case .easeOut: return .easeOut(duration: offset)
        }
    }
}

let keyframes = [
    // Initial state, will be used once. Its offset is useless and will be ignored
    KeyFrame(offset: 0.0, rotation: 0, yScale: 1.0, y: 0, animationKind: .none),

    // Animation keyframes
    KeyFrame(offset: 0.2, rotation:   0, yScale: 0.5, y:  20, animationKind: .linear),
    KeyFrame(offset: 0.4, rotation:   0, yScale: 1.0, y: -20, animationKind: .linear),
    KeyFrame(offset: 0.5, rotation: 360, yScale: 1.0, y: -80, animationKind: .easeOut),
    KeyFrame(offset: 0.4, rotation: 360, yScale: 1.0, y: -20, animationKind: .easeIn),
    KeyFrame(offset: 0.2, rotation: 360, yScale: 0.5, y:  20, animationKind: .easeOut),
    KeyFrame(offset: 0.4, rotation: 360, yScale: 1.0, y: -20, animationKind: .linear),
    KeyFrame(offset: 0.5, rotation:   0, yScale: 1.0, y: -80, animationKind: .easeOut),
    KeyFrame(offset: 0.4, rotation:   0, yScale: 1.0, y: -20, animationKind: .easeIn),
]

struct ManyEmojis: View {
    @State var emojiCount = 0
    let dates: [Date] = [.now.addingTimeInterval(0.3), .now.addingTimeInterval(0.6), .now.addingTimeInterval(0.9)]
    
    var body: some View {
        TimelineView(.explicit(dates)) { timeline in
            HStack(spacing: 80) {
                if emojiCount > 0 {
                    JumpingEmoji(emoji: "😃")
                }
                
                if emojiCount > 1 {
                    
                    JumpingEmoji(emoji: "😎")
                    
                }
                
                if emojiCount > 2 {
                    JumpingEmoji(emoji: "😉")
                }
                
                Spacer()
            }
            .onChange(of: timeline.date) { (date: Date) in
                emojiCount += 1
            }
            .frame(width: 400)
        }
    }
}

struct JumpingEmoji: View {
    let emoji: String
    
    // Use all offset, minus the first
    let offsets = Array(keyframes.map { $0.offset }.dropFirst())
    
    var body: some View {
        TimelineView(.cyclic(timeOffsets: offsets)) { timeline in
            HappyEmoji(emoji: emoji, date: timeline.date)
        }
    }
}

struct HappyEmoji: View {
    let emoji: String
    // current keyframe number
    @State var idx: Int = 0

    // timeline update
    let date: Date
    
    var body: some View {
        Text(emoji)
            .font(.largeTitle)
            .scaleEffect(4.0)
            .modifier(Effects(keyframe: keyframes[idx]))
            .animation(keyframes[idx].animation, value: idx)
            .onChange(of: date) { _ in advanceKeyFrame() }
            .onAppear { advanceKeyFrame()}
    }
    
    func advanceKeyFrame() {
        // advance to next keyframe
        idx = (idx + 1) % keyframes.count
        
        // skip first frame for animation, which we
        // only used as the initial state.
        if idx == 0 { idx = 1 }
    }
    
    struct Effects: ViewModifier {
        let keyframe: KeyFrame
        
        func body(content: Content) -> some View {
            content
                .scaleEffect(CGSize(width: 1.0, height: keyframe.yScale))
                .rotationEffect(Angle(degrees: keyframe.rotation))
                .offset(y: keyframe.y)
        }
    }
}

