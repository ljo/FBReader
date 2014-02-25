import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
	id: root
    property variant handler
    anchors.fill: parent
    opacity: 0
    visible: opacity > 0

    Behavior on opacity {
        FadeAnimation {}
    }

	Label {
		id: label
		anchors { horizontalCenter: parent.horizontalCenter; bottom: dummySpace.top }
		horizontalAlignment: Text.AlignHCenter
		wrapMode: Text.Wrap
		width: parent.width
        text: root.handler.text
	}
    BusyIndicator {
		id: indicator
		anchors.centerIn: parent
        size: BusyIndicatorSize.Large
		running: root.visible
	}
	Item {
		id: dummySpace
		anchors { bottom: indicator.top }
		height: ((parent.height - indicator.height) / 2.0 - label.height) / 2.0
	}
	
    function show() {
        root.opacity = 1
	}
	
    function hide() {
        root.opacity = 0
	}

    TouchBlocker {
        anchors.fill: parent
    }

    Connections {
        target: handler
        onFinished: {
            hide()
        }
    }
}
