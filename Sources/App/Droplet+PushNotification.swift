import Vapor
import VaporAPNS
import Dispatch

private var _pushNotificationsController: PushNotificationsController!

extension Droplet {
    var pnController: PushNotificationsController {
        return _pushNotificationsController
    }

    func setupRoutesForPushNotifications() throws {
        _pushNotificationsController = PushNotificationsController(droplet: self, sandbox: false)

        get("/test", String.parameter) { [weak self] request in
            let deviceToken = try request.parameters.next(String.self)

            let anotherQueue = DispatchQueue(label: "com.summitisland.dungeons", qos: .utility)
            anotherQueue.async {
                self?.pnController.test(withToken: deviceToken) { string in
                }
            }

            var json = JSON()
            try json.set("hello", deviceToken)
            return json
        }

        get("test-dispatch") { request in
            let group = DispatchGroup()
            group.enter()

            var number = 0

            DispatchQueue.global(qos: .background).async {
                for _ in 0...88888888 {
                    number += 1
                }
                group.leave()
            }

            group.wait()

            let date = Date()
            var json = JSON()
            try json.set("\(date) number1", number)
            return json
        }
    }
}
