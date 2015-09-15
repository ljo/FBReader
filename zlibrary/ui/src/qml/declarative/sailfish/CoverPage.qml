import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    Image {
        anchors.centerIn: parent
        /*         text: "FBReader" */
        /* visible: applicationInfo.bookTitle.length > 50 ? false : true */
        visible: true
        source: "CoverPage.png"
        opacity: 0.2
    }

    Label {
        id: titleLabel
        anchors {
            top: parent.top
            topMargin: Theme.paddingLarge
            left: parent.left
            leftMargin: Theme.paddingLarge
            right: parent.right
            rightMargin: Theme.paddingLarge
        }
        truncationMode: TruncationMode.Fade
        font.pixelSize: Theme.fontSizeSmall
        wrapMode: Text.WordWrap
        text: applicationInfo.bookTitle.substring(18)
    }

    CoverActionList {
        id: coverAction
        enabled: false

        CoverAction {
            iconSource: applicationInfo.bookTitleChanged ? "image://theme/icon-cover-previous-song" : ""
            onTriggered: {
                applicationInfo.openPreviousBook()
            }
        }
    }
}
