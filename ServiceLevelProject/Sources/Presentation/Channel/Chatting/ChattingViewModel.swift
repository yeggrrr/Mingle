//
//  ChattingViewModel.swift
//  ServiceLevelProject
//
//  Created by YJ on 11/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ChattingViewModel: ViewModelBindable {
    typealias Chatting = ChannelChatHistoryModel
    let disposeBag = DisposeBag()
    let editInfo = PublishSubject<SelectedChannelData>()
    var roodID: String?
    var chattings: [Chatting] = []
    
    struct Input {
        let viewDidLoadTrigger = PublishSubject<Void>()
        let chattingRoomInfo = PublishSubject<SelectedChannelData>()
    }
    
    struct Output {
        let channelName: BehaviorSubject<String>
        let inValidChannelMessage: PublishSubject<(String, String, String)>
        let chattingOutput: PublishSubject<[Chatting]>
    }
    
    func transform(input: Input) -> Output {
        let inValidChannelMessage = PublishSubject<(String, String, String)>()
        let channelName = BehaviorSubject(value: "")
        let chattingOutput = PublishSubject<[Chatting]>()
        let socketTrigger = PublishSubject<Void>()
        
        editInfo
            .bind(with: self) { owner, editInfo in
                channelName.onNext(editInfo.name)
            }
            .disposed(by: disposeBag)
        
        input.chattingRoomInfo
            .flatMap { [weak self] roomInfo in
                self?.roodID = roomInfo.channelID
                channelName.onNext(roomInfo.name)
                return APIManager.shared.callRequest(api: ChannelRouter.fetchChannelChatHistory(cursorDate: Date.currentDate(), workspaceID: UserDefaultManager.workspaceID ?? "", ChannelID: roomInfo.channelID), type: [ChannelChatHistoryModel].self)
            }
            .bind(with: self) { owner, value in
                switch value {
                case .success(let success):
                    print(">>> Success!")
                    owner.chattings = success
                    chattingOutput.onNext(owner.chattings)
                    socketTrigger.onNext(())
                case .failure(let failure):
                    print(">>> Failed!!: \(failure.errorCode)")
                    inValidChannelMessage.onNext(("존재하지 않는 채널", "이미 삭제된 채널입니다! 홈 화면으로 이동합니다.", "확인"))
                }
            }
            .disposed(by: disposeBag)
        
        socketTrigger
            .withLatestFrom(input.chattingRoomInfo)
            .bind(with: self) { owner, roomInfo in
                WebSocketManager.shared.router = .channel(id: roomInfo.channelID)
                WebSocketManager.shared.connect()
            }
            .disposed(by: disposeBag)
        
        WebSocketManager.shared.channelOutput
            .bind(with: self) { owner, chatting in
                owner.chattings.append(chatting)
                chattingOutput.onNext(owner.chattings)
            }
            .disposed(by: disposeBag)
        
        return Output(
            channelName: channelName, 
            inValidChannelMessage: inValidChannelMessage,
            chattingOutput: chattingOutput
        )
    }
    
    deinit {
        WebSocketManager.shared.disconnect()
    }
}

extension Date {
    static func currentDate() -> String {
        if let timeZone = TimeZone(identifier: "Asia/Seoul") {
            let formatter = ISO8601DateFormatter()
            formatter.timeZone = timeZone
            let date = formatter.string(from: Date())
            return date
        } else {
            print("currentDate() 메서드 정보 받아올 수 없음")
        }
        
        return " "
    }
}
