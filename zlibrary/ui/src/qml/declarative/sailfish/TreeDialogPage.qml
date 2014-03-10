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
    property variant rootIndex
    property bool isTreeRoot: true
    property Item contextMenu
    property bool fetchingChildren: false

    VisualDataModel {
        id: visualModel
        model: root.handler
        rootIndex: root.rootIndex ? root.rootIndex : visualModel.rootIndex
        delegate: ListItem {
            id: listItem
            height: Theme.itemSizeLarge

            Row {
                id: row
                spacing: Theme.paddingLarge
                Image {
                    id: icon
                    source: model.iconSource
                    anchors.verticalCenter: parent.verticalCenter
                    sourceSize.width: Theme.iconSizeLarge
                    sourceSize.height: Theme.iconSizeLarge
                }
                Column{
                    anchors.verticalCenter: parent.verticalCenter
                    Label {
                        text: model.title
                        font.pixelSize: Theme.fontSizeLarge
                    }
                    Label {
                        text: model.subtitle
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: Theme.secondaryColor
                    }
                }
            }

            onClicked: {
                console.log("title", model.title,
                            "activatable", model.activatable,
                            "page", model.page)
                if (model.activatable) {
                    if (root.handler.activate(visualModel.modelIndex(index))) {
                        root.handler.finish();
                    }
                } else {
                    var modelIndex = visualModel.modelIndex(index)
                    if (model.page) {
                        var args = {
                            "handler": root.handler,
                            "modelIndex": modelIndex,
                            "imageSource": model.iconSource
                        }
                        pageStack.push("TreeDialogItemPage.qml", args)
                    } else {
                        fetchChildren(modelIndex)
                    }
                }
            }
            onPressAndHold: {
                console.log("Press-and-hold", model.title)
                var modelIndex = visualModel.modelIndex(index)
                var actions = root.handler.actions(modelIndex)
                console.log("item actions:", actions)
                if (actions.length > 0){
                    if (!contextMenu)
                        contextMenu = contextMenuComponent.createObject(root,
                                    {"actions": actions, "modelIndex": modelIndex})
                    contextMenu.show(listItem);
                }
            }
        }

//        Component.onCompleted: {
//            console.log ("visualModel.count", visualModel.count)
//            if (!root.isTreeRoot && visualModel.count < 1 ){ // TODO: !root.isTreeRoot is 1 wierd hack; visualModel.count returns 0 on rootNode. why?
//                fetchChildren()
//            }
//        }
    }

    property variant modelIndexToFetch

    function fetchChildren(modelIndex) {
        fetchingChildren = true
        modelIndexToFetch = modelIndex
        root.handler.fetchChildren(modelIndex)
    }

    Connections {
        target: fetchingChildren ? handler : null
//  currently no progressChanged signal when fetching children, so this is commented out
//        onProgressChanged: {
//            var value, maximumValue
//            console.log("on progress changed", value, maximumValue)
//            if (value >= 0) {
//                if (maximumValue)
//                    busyLabel.text = value + " / " + maximumValue
//                else
//                    busyLabel.text = value
//            }
//        }
        onProgressFinished: {
            var error
            if (!modelIndexToFetch || !fetchingChildren){
                console.log("onProgressFinished but not fetching children???")
                return
            }

            fetchingChildren = false
            if (error === "") {
                var args = {
                    "handler": root.handler,
                    "rootIndex": modelIndexToFetch,
                    "isTreeRoot": false
                }
                modelIndexToFetch = null
                var page = pageStack.push("TreeDialogPage.qml", args)
            } else {
                console.log(error)
            }
        }
    }

    SilicaListView {
        id: listView
        anchors.fill: parent
        header: PageHeader { title: "" /*"Library"*/ }
        model: visualModel
        VerticalScrollDecorator {}
        ViewPlaceholder {
            enabled: listView.count === 0
            text: "Empty"
        }
    }

    Column {
        visible: fetchingChildren
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

    Component {
        id: contextMenuComponent

        ContextMenu {
            id: menu
            property variant actions
            property variant modelIndex
            property bool hasChildren: false

            Repeater {
                model: actions
                MenuItem {
                    text: modelData
                    visible: root.handler.isVisibleAction(modelIndex, index)
                    onClicked: root.handler.run(modelIndex, index)
                }
            }
        }
    }

    Component.onCompleted: {
        if (root.isTreeRoot) {
            handler.onFinished.connect(function() {
                console.log("got tree dialog finished signal. closing tree dialog")
                handler = null // stop onStatusChanged triggering handler.finished() signal
                popPage()
            })
        }
    }

    /*
    * Pop this page and all after
    */
    function popPage() {
        var previousPage = pageStack.previousPage(root)
        pageStack.pop(previousPage, PageStackAction.Immediate)
    }

    onStatusChanged: {
        if (isTreeRoot && status === PageStatus.Inactive && pageStack.depth === 1){
            if (handler)
                handler.finish()
        }
    }
}
