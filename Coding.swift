import Foundation
import Combine

// 이런 형태로 쉽게 사용
extension Notification.Name {
    static let customNotification = Notification.Name("customNotification")
}

final class NotificationTest {
    
  private lazy var bag = Set<AnyCancellable>()

  // Function을 이용한 방식
  func useFunction() {
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(getValue(_:)),
                                             name: .customNotification,
                                             object: nil)
  }
    
  // Combine을 이용한 방식. 추천!!!
  func useCombine() {
    NotificationCenter.default
      .publisher(for: .customNotification)
      .map { $0.object as? String }
      .sink { value in
        print("combine receive", value ?? "")
      }
      .store(in: &bag)
  }

  func send() {
    NotificationCenter.default.post(name: .customNotification, object: "test")
  }

  @objc func getValue(_ notification: Notification){
    let value = notification.object as? String
    print("function receive", value ?? "")
  }
}

let test = NotificationTest()
test.useFunction()
test.useCombine()
test.send()

// Print this debug message.
// function receive test
// combine receive test
