import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: messageDialog
    property string message
    property string acceptText
    property string title

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            width: parent.width

            DialogHeader {
                acceptText: messageDialog.acceptText
            }

            Column {
                spacing: Theme.paddingMedium
                anchors {
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                    left: parent.left
                    right: parent.right
                }
                Label {
                    width: parent.width
                    text: messageDialog.title
                    wrapMode: Text.Wrap
                    font.pixelSize: Theme.fontSizeLarge
                    color: Theme.primaryColor
                }
                Label {
                    width: parent.width
                    text: messageDialog.message
                    wrapMode: Text.Wrap
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.secondaryColor
                }
            }
        }
    }
}
