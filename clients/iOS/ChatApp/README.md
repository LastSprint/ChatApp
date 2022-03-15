# iOS Swift Chat App (Storyboard)

Contains implementation if iOS client written in  Swift with Storyboard layout (no SwiftUI)

Implementations is done via [this GitHub Project](https://github.com/users/LastSprint/projects/1)

## Design docs

This part of docs contains design desigions about whole application.

### Application Design

Applicaiton should be designed by Flux/Redux pattern. UI layer have to dispatch actionas and something have to dispatch some actions on the UI layer.

The idea is to distinguish different application layers by message bus.

It means that communicatio inside the layer could be built in any way, but communicatrion between layers have to be built on top of message bus. By this way we can decouple application parts and update/change them independently. Of course we can do it wihtout message buses. But i wont to use bus (: (who said that I have to be wise?)



