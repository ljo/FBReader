
import QtQuick 2.0
import Sailfish.Silica 1.0

ComboBox {
    property variant handler
    id: combobox
    width: parent.width
    enabled: handler.enabled
    visible: handler.visible
    label: handler.name
    menu: ContextMenu {
        Repeater {
            model: handler.values
            MenuItem {
                text: modelData
            }
        }
    }
    currentIndex: handler.currentIndex
    onCurrentIndexChanged: {
        handler.currentIndex = currentIndex
    }
}
