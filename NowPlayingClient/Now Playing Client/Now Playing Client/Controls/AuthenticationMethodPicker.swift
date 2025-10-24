//
//  AuthenticationMethodPicker.swift
//  Now Playing Client
//
//  Created by Marc Steele on 24/10/2025.
//

import SwiftUI

struct AuthenticationMethodPicker: View {
    @Binding var selected: String?
    
    var body: some View {
        Picker("Authentication Method", selection: $selected) {
            Text("-- Select a Method --").tag(nil as String?)
            ForEach(authenticationGroupings, id:\.name) { authenticationGrouping in
                Text(authenticationGrouping.name).tag(authenticationGrouping.name)
            }
        }
    }
}

struct AuthenticationMethodPicker_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationMethodPicker(selected: .constant(nil))
    }
}
