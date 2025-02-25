//
//  Contact.swift
//  CustomScrollInteraction
//
//  Created by Xiaofu666 on 2025/2/25.
//

import SwiftUI

struct Contact: Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var email: String
}

let dummyContacts: [Contact] = "Abigail,Bradley,Cassandra,David,Evelyn,Franklin,Grace,Hannah,Ian,Julia,Kathleen,Laura,Michael,Nathan,Olivia,Peter,Queenie,Rachel,Steven,Thomas,Ursula,Victor,William,Xavier,Yvonne,Adam,Brooklyn,Carla,Davida,Emily,Fiona,George,Heidi,Ivy,Jack,Kennedy,Lily,Margaret,Noah,Oscar,Paula,Quentin,Roberta,Samantha,Timothy,Zrsula,Vincent,Zilliam,Zavier,Xvonne,Andrew,Bella,Charlie,Doris,Ethan,Francesca,Grace2,Zannah,Ivan,Judy".components(separatedBy: ",").shuffled().compactMap({ Contact(name: $0, email: "abc@123.com") })

