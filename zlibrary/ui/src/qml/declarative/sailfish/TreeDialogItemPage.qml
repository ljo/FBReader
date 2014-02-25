/*
 * Copyright (C) 2004-2011 Geometer Plus <contact@geometerplus.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

import QtQuick 2.0
import Sailfish.Silica 1.0
import org.fbreader 0.14

//Dialog {
Page {
    id: root
    property variant handler
    property variant modelIndex
    property variant imageSource
    property bool hasProgress: false

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height

        Column{
            id: contentColumn
            width: parent.width

    //        DialogHeader {
    //            id: dialogHeader
    //            acceptText: ""
    //            title: dialogContent.content.title
    //        }

            PageHeader {
                title: dialogContent.content.title
            }

            Column {
                spacing: Theme.paddingMedium
                anchors {
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                    left: parent.left
                    right: parent.right
                }

                Image {
                    id: image
                    source: imageSource
        //            sourceSize.width: parent.width / 2
                    width: parent.width / 2
                    fillMode: Image.PreserveAspectFit
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                DialogContent {
                    id: dialogContent
                    content: root.handler.createPageContent(root.modelIndex)
                }

                Column{
                    id: buttons
                    width: parent.width
                    Repeater {
                        id: repeater
                        model: root.handler.actions(root.modelIndex)
                        Button {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: modelData
                            onClicked: {
                                root.handler.run(root.modelIndex, index)
                            }
                            visible: root.handler.isVisibleAction(root.modelIndex, index)
                        }
                    }
                    Component.onCompleted: {
        //                dialogHeader.acceptText = repeater.itemAt(0).text
                    }
                }
            }
        }

        Column {
            visible: hasProgress
            anchors.centerIn: parent
            spacing: Theme.paddingLarge
            BusyIndicator {
                id: busyIndicator
                running: visible
                anchors.horizontalCenter: parent.horizontalCenter
                size: BusyIndicatorSize.Large
            }
            Label {
                id: busyLabel
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
            }
        }
    }

    Connections {
        target: handler
        onProgressChanged: {
            var value, maximumValue
            console.log("on progress changed", value, maximumValue)
            if (value >= 0) {
                if (maximumValue)
                    busyLabel.text = value + " / " + maximumValue
                else
                    busyLabel.text = value
            }
            hasProgress = true
        }
        onProgressFinished: {
            var error
            if (!hasProgress){
                console.log("onProgressFinished but not hasProgress???")
                return
            }

            hasProgress = false
            if (error === "") {
            } else {
                console.log(error)
            }
        }
    }

    Component.onCompleted: {
        console.log("TreeDialogItemPage",
                   "title", handler.title,
                   "content.title", dialogContent.content.title,
                   "imageSource", imageSource)
    }
}
