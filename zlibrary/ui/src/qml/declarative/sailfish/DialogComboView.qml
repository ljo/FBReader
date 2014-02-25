
import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
	id: root
    property variant handler
	width: parent.width
    height: combobox.height
	visible: handler.visible
	enabled: handler.enabled

    ComboBox {
        id: combobox
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
}
