import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page
    
    Column {
        anchors.fill: parent
        
        PageHeader {
            title: handler.title
        }
    
        Text {
            width: parent.width
            text: handler.text
            wrapMode: Text.Wrap
        }
        
        Repeater {
            model: handler.buttons
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: modelData
                onClicked: handler.press(index)
            }
        }
    }
    
    Connections {
        target: handler
        onFinished: pageStack.pop()
    }
}
