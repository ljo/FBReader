import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: dialog
    property string title
    property string text
    property string acceptText
    property string rejectText
    
    Column {
        anchors.fill: parent
        spacing: Theme.paddingLarge
        
        DialogHeader {
            acceptText: dialog.acceptText
            cancelText: dialog.rejectText
            title: dialog.title
        }
    
        Label {
            anchors {
                margins: Theme.paddingLarge
                left: parent.left
                right:parent.right
            }
            text: dialog.text
            wrapMode: Text.Wrap
        }
    }
    
    Component.onCompleted: console.log(title, text, acceptText, rejectText)
}
