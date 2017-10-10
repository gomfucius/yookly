//
//  SIPushNotificationsController.swift
//  dungeons
//
//  Created by Genki Mine on 11/6/16.
//
//

import Vapor
import VaporAPNS
import Foundation

final class PushNotificationsController
{
    var vaporAPNS: VaporAPNS?
    var vaporAPNSLite: VaporAPNS?
    let drop: Droplet!
    var sandbox: Bool

    init(droplet: Droplet, sandbox: Bool)
    {
        self.drop = droplet
        self.sandbox = sandbox

        // com.summitisland.dungeons
        do {
            if let key = droplet.config["app", "PN_PRIVATE_KEY"]?.string {
                let options = try Options(topic: "com.summitisland.dungeons", teamId: "L5GKNB78UR", keyId: "UFYWQJ6R59", rawPrivKey: key, rawPubKey: "BFAvG1D8L4ECtHUSDZBN3jZncdLnJ7USAeYOMOsF1h3OGOZtjeL792TNCtx6KizDv5CZzkyjUm3MBygwvBIZZyo=")
                vaporAPNS = try VaporAPNS(options: options)
            }
        }
        catch {
            print("error starting VaporAPNS")
        }

        // com.summitisland.dungeonsLite
        do {
            let options = try Options(topic: "com.summitisland.dungeonsLite", teamId: "L5GKNB78UR", keyId: "F3M8W2J3P9", rawPrivKey: "AA6NwMd+T8XmO4NdbW4zOP58+0+KHWzwgi1lpeBGEC7B", rawPubKey: "BGOPpHvc90xqG/2ZSlZPqXnGBAM53dDLNTzFlCOtfX4gj9ClLOTEScpiA21KdULJFoDfOAb6kdn4WM45vg4UE34=")
            vaporAPNSLite = try VaporAPNS(options: options)
        }
        catch {
            print("error starting VaporAPNS")
        }
    }

    func test(withToken deviceToken: String, completion: ((String) -> ()))
    {
        let payload = Payload()
        payload.bodyLocKey = "Test push dayo."
        payload.bodyLocArgs = ["Genkitest"]

        let pushMessage = ApplePushMessage(topic: nil, priority: .immediately, payload: payload, sandbox: true)
        vaporAPNS?.send(pushMessage, to: [deviceToken]) { result in
            let retString: String
            if case let .success(messageId, deviceToken, serviceStatus) = result, case .success = serviceStatus {
                retString = serviceStatus.localizedDescription
                print ("Success! \(messageId) \(deviceToken) \(serviceStatus)")
            }
            else {
                retString = "fail 😭"
                print(result)
            }

//            completion(retString)
        }
    }
}
