import QtQuick 2.0
import Sailfish.Silica 1.0

// TODO implement dropdown context menu to select predefined options
TextField {
    property variant handler
    id: textField
    width: parent.width
    label: handler.name
    placeholderText: label
    enabled: handler.enabled
    visible: handler.visible
    text: handler.currentText
    onTextChanged: handler.currentText = text
}
