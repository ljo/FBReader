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

Dialog {
    id: root
    property variant handler
    canAccept: handler.acceptButtons.length > 0

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: contentColumn.height

        Column{
            id: contentColumn
            width: parent.width

            DialogHeader {
                acceptText: handler.acceptButtons[0]
//                cancelText: handler.rejectButtons[0]
            }
            PageHeader {
                title: handler.title
            }

            Column {
                anchors {
                    leftMargin: Theme.paddingLarge
                    rightMargin: Theme.paddingLarge
                    left: parent.left
                    right: parent.right
                }

                DialogContent {
                    content: handler.content
                }

    //            // T.O.D.O buttons on sailfish?..
    //            Repeater {
    //                model: handler.buttonNames
    //                visible: count > 1
    //                Button {
    //                    text: modelData
    //                    onClicked: handler.acceptButtons.indexOf(text) !== -1 ? accept() : reject()
    //                    anchors.horizontalCenter: parent.horizontalCenterCenter
    //                }
    //            }
            }
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Inactive){
            if (result === DialogResult.Accepted)
                handler.accept()
            else if (result === DialogResult.Rejected)
                handler.reject()
            else
                handler.reject()
        }
    }

//    Component.onCompleted: console.log("SimpleDialog.qml", handler, handler.title)
}
