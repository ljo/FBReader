import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
	id: root
    property variant handler
	width: parent.width
    height: slider.height
	visible: handler.visible
    enabled: handler.enabled

    Slider {
        id: slider
        label: handler.name
        minimumValue: handler.minimumValue
        maximumValue: handler.maximumValue
        onValueChanged: handler.value = value
        stepSize: handler.stepSize
        value: handler.value
//        height: Theme.itemSizeMedium
        width: parent.width
        valueText: value
    }
	
	Connections {
		target: root.handler
        onValueChanged: slider.value = root.handler.value
	}
}
