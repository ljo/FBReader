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

Page {
    id: root
    property variant handler
    property variant modelIndex
    property variant imageSource
    property bool hasProgress: false

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            width: parent.width

            PageHeader {
//                title: dialogContent.content.title // TODO: a title instead of '??????'
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

                Column {
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
                                recheckActions()
                            }
                            visible: root.handler.isVisibleAction(root.modelIndex, index)
                        }
                    }
                    
                    Component.onCompleted: {
                    }
                    
                    function recheckActions(){
                        repeater.model = root.handler.actions(root.modelIndex)
                    }
                }
            }
            
            ProgressBar {
                id: progressBar
                width: parent.width
                label: indeterminate ? "" : value + " / " + maximumValue
                maximumValue: -1
                indeterminate: maximumValue === -1
//                valueText: indeterminate ? "" : value + "/" + maximumValue
                visible: false
            }
        }
    }

    Connections {
        target: handler
        onProgressChanged: {
            var value, maximumValue
            console.log("on progress changed", value, maximumValue)
            progressBar.value = value
            progressBar.maximumValue = maximumValue
            progressBar.visible = true
        }
        onProgressFinished: {
            var error
            progressBar.visible = false
            if (error === "") {
            } else {
                console.log(error)
            }
            
            buttons.recheckActions()
        }
    }

    Component.onCompleted: {
        console.log("TreeDialogItemPage",
                   "title", handler.title,
                   "content.title", dialogContent.content.title,
                   "imageSource", imageSource)
    }
}
