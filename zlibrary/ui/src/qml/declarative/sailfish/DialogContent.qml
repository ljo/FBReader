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

Column {
    id: root
    property variant content
    property string imageSource: ""

    width: parent.width
    spacing: Theme.paddingMedium

    Component.onCompleted: console.log("DialogContent", content.title, content.items)

    Repeater {
        id: repeater
        model: root.content.items

        Item {
            id: item
            height: child.height
            width: parent.width
            property Item child: createChild(modelData)
            
            function createChild(modelData) {
                if (!child && modelData.imageSource !== undefined)
                    child = imageComponent.createObject(item)
                else if (!child && modelData.visible)
                    child = root.createChild(item, modelData)
                return child;
            }
        }
    }

    property variant __componentCache: ({})

    function createChild(item, object) {
        var componentName;
        switch (object.type) {
        case OptionView.Choice:
            componentName = "DialogChoiceView.qml"
            break;
        case OptionView.Boolean:
            componentName = "DialogBooleanView.qml"
            break;
        case OptionView.Boolean3:
            // TODO
//			componentName = "DialogBoolean3View.qml"
            break;
        case OptionView.Path:
            // treat as string view
//            componentName = "DialogPathView.qml"
            componentName = "DialogStringView.qml"
            break;
        case OptionView.String:
            componentName = "DialogStringView.qml"
            break;
        case OptionView.Password:
            componentName = "DialogStringView.qml"
            break;
        case OptionView.Spin:
            componentName = "DialogSpinView.qml"
            break;
        case OptionView.Combo:
            if (object.editable)
                componentName = "DialogEditableComboView.qml"
            else 
                componentName = "DialogComboView.qml"
            break;
        case OptionView.Color:
            componentName = "DialogColorView.qml"
            break;
        case OptionView.Key:
            // TODO
//			componentName = "DialogKeyView.qml"
            break;
        case OptionView.Order:
            // TODO
//			componentName = "DialogOrderView.qml"
            break;
        case OptionView.Multiline:
            componentName = "DialogMultilineView.qml"
            break;
        case OptionView.Static:
            componentName = "DialogStaticView.qml"
            break;
        default:
            break;
        }
        var child;
        if (componentName !== undefined) {
            var component = __componentCache[componentName];
            if (!component) {
                component = Qt.createComponent(componentName);
                __componentCache[componentName] = component;
            }
            child = component.createObject(item, { handler: object });
            if (child === null) {
                console.log("Error creating object", component, componentName, component.errorString());
            }
        } else {
            console.error("invalid component type: ", object.type)
           }
        return child;
    }

    Component {
        id: imageComponent
        Image {
            id: image
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            source: root.imageSource
            smooth: true
        }
    }
}

