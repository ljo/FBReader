import QtQuick 2.0
import Sailfish.Silica 1.0


TextSwitch {
    id: textSwitch
    property variant handler
    text: handler.name
    enabled: handler.enabled
    visible: handler.visible
    checked: handler.checked
    onCheckedChanged: handler.checked = checked
}
