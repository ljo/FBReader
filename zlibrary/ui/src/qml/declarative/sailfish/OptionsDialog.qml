import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    property variant handler

    SilicaListView {
        anchors.fill: parent
        header: PageHeader {
            title: handler.title
        }
        model: handler.sections

        delegate: BackgroundItem {
            Label {
                x: Theme.paddingLarge
                text: modelData.title
                anchors.verticalCenter: parent.verticalCenter
            }
            onClicked: pageStack.push(optionsPage, {handler: modelData})
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Inactive && pageStack.depth === 1)
            handler.accept()
    }

    Component{
        id: optionsPage
        Page {
            property variant handler

            SilicaFlickable {
                anchors.fill: parent
                contentHeight: column.height

                Column{
                    id: column
                    width: parent.width

                    PageHeader {
                        id: header
                        title: handler.title
                    }
                    Column{
                        width: parent.width
                        DialogContent {
                            content: handler
                        }
                    }

//                    DialogContent {
////                        x: Theme.paddingLarge
//                        content: handler
//                    }
                }
                VerticalScrollDecorator {}
            }
        }
    }
}
