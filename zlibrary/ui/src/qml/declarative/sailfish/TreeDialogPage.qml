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
    property Item contextMenu
	
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
                    if (model.page) {
                        var args = {
                            "handler": root.handler,
                            "modelIndex": visualModel.modelIndex(index),
                            "imageSource": model.iconSource
                        }
                        var page = pageStack.push("TreeDialogItemPage.qml", args)
                    } else {
                        var args = {
                            "handler": root.handler,
                            "rootIndex": visualModel.modelIndex(index)
                        }
                        var page = pageStack.push("TreeDialogPage.qml", args)
                    }
                }
            }
            onPressAndHold: {
                console.log("Press-and-hold", model.title)
                var modelIndex = visualModel.modelIndex(index)
                var actions = root.handler.actions(modelIndex)
                console.log("actions:", actions)
                if (actions){
                    if (!contextMenu)
                        contextMenu = contextMenuComponent.createObject(root,
                                    {"actions": actions, "modelIndex": modelIndex})
                    contextMenu.show(listItem);
                }
            }
        }
    }
	
    SilicaListView {
        id: listView
        anchors.fill: parent
        header: PageHeader { title: "" /*"Library"*/ }
        model: visualModel
        VerticalScrollDecorator {}
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
                    //visible: root.handler.isVisibleAction(modelIndex, index)
                    onClicked: root.handler.run(modelIndex, index)
                }
            }
        }
    }

    Connections {
        target: handler
        onProgressChanged: {
            console.log("on progress changed")
        }
    }
}
