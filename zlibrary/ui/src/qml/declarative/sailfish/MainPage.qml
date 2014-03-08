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
                   toolbar.hide()
                   objectHolder.handlePress(mouse.x, mouse.y)
               }
               onReleased: objectHolder.handleRelease(mouse.x, mouse.y)
               // TODO enable text selection?
//               onPositionChanged: {
//                   if (pressed)
//                       objectHolder.handleMovePressed(mouse.x, mouse.y)
//                   else
//                       objectHolder.handleMove(mouse.x, mouse.y)
//               }
           }
        }

        PullDownMenu {
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
    }


    Connections {
        target: applicationInfo
//        onMainMenuRequested: {
            // TODO how can we show flickable menu without acutally flicking?
//                flickable.scrollToBottom() // does not work
//                flickable.scrollToTop()
//        }
//        onActionsChanged: {
//            var actions
//            console.log("actionsChanged", actions)
//            for (var i in applicationInfo.actions) {
//                var action = applicationInfo.actions[i]
//                if (action.enabled && action.visible){
//                    toolbar.show()
//                    return
//                }
//            }
//            toolbar.hide()
//        }
    }


    DockedPanel {
        id: toolbar
//            width: root.isPortrait ? parent.width : Theme.itemSizeExtraLarge + Theme.paddingLarge
//            height: root.isPortrait ? Theme.itemSizeExtraLarge + Theme.paddingLarge : parent.height
//            dock: root.isPortrait ? Dock.Top : Dock.Left
        width: parent.width
        height: Theme.itemSizeExtraLarge
        dock: Dock.Bottom
        open: false
        Flow {
            anchors.centerIn: parent
            Repeater {
                id: repeater
                model: applicationInfo.actions
                IconButton {
                    icon.source: "image://theme/icon-m-" + modelData.platformIconId
                    visible: modelData.visible
                    enabled: modelData.enabled
                    onClicked: modelData.activate()
                    
                    onEnabledChanged: {
                        // show toolbar on item enabled changed. (eg as a result of 'Find' action)
//                        console.log("enabled changed", enabled)
                        if (enabled){
                            toolbar.show()
                        }
                    }
    
                    onVisibleChanged: {
//                        console.log("visible changed", visible)
//                        if (visible){
//                            toolbar.show()
//                        }
                    }
                }
            }
        }
        
        Component.onCompleted: {
            toolbar.hide()
        }
    }
    // use mousearea to show toolbar or not? mouse area hides progress bar unclickable
//    MouseArea {
//        id: toolbarArea
//        anchors.bottom: parent.bottom
//        width: parent.width
//        height: toolbarArea.height
//        enabled: !toolbar.open
//        onClicked: toolbar.show()
//    }
}
