import QtQuick 2.0
import Sailfish.Silica 1.0
import org.fbreader 0.14

Page {
    id: root


    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        BookView {
           id: bookView
           anchors.fill: parent
           holder: objectHolder
           Component.onCompleted: {
               objectHolder.bookView = bookView
           }

           MouseArea {
               anchors.fill: parent
               onPressed: {
                   objectHolder.handlePress(mouse.x, mouse.y)
               }
               onReleased: objectHolder.handleRelease(mouse.x, mouse.y)
               // TODO enable text selection
//               onPositionChanged: {
//                   if (pressed)
//                       objectHolder.handleMovePressed(mouse.x, mouse.y)
//                   else
//                       objectHolder.handleMove(mouse.x, mouse.y)
//               }
           }
        }

        PushUpMenu {
            id: mainMenu
            onActiveChanged: {
                if ( active ){
                    applicationInfo.menuBar.recheckItems()
                }
            }
            Repeater {
                model: applicationInfo.menuBar !== null ? applicationInfo.menuBar.items : null
                MenuItem {
                    parent: mainMenu
                    text: modelData
                    enabled: applicationInfo.menuBar.enabledItems.indexOf(modelData) !== -1
                    visible: applicationInfo.menuBar.visibleItems.indexOf(modelData) !== -1
                    onClicked: applicationInfo.menuBar.activate(index)
                }
            }
        }

        Connections {
            target: applicationInfo
            onMainMenuRequested: {
                // TODO how can we show flickable menu without acutally flicking?
//                flickable.scrollToBottom() // does not work
//                flickable.scrollToTop()
            }
        }
    }
}
