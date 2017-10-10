import Vapor
import VaporAPNS

private var _pushNotificationsController: PushNotificationsController!

extension Droplet {
    var pnController: PushNotificationsController {
        return _pushNotificationsController
    }

    func setupRoutesForPushNotifications() throws {
        _pushNotificationsController = PushNotificationsController(droplet: self, sandbox: false)

        get("/test", String.parameter) { [weak self] request in
            let deviceToken = try request.parameters.next(String.self)

            self?.pnController.test(withToken: deviceToken) { string in

            }

            var json = JSON()
            try json.set("hello", deviceToken)
            return json
        }
    }
}
