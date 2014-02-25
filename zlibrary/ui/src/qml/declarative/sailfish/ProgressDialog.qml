import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
	id: root
    property variant handler
	state: "closed"
    anchors.fill: parent
    visible: opacity !== 0

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
	
	function open() {
		root.state = "";
	}
	
	function close() {
		root.state = "closed";
	}
	
	states: [
        State {
            name: ""
            PropertyChanges {
				target: root
                opacity: 1
			}
        },
        State {
            name: "closed"
            PropertyChanges {
				target: root
				opacity: 0
			}
        }
    ]

    transitions: [
        Transition {
            from: ""
			to: "closed"
			reversible: true
            FadeAnimation {
                target: root
                property: opacity
            }
        }
    ]
		
	// eat mouse events
	MouseArea {
		id: mouseEventEater
		anchors.fill: parent
		enabled: parent.visible
	}
	
    Component.onCompleted: {
        root.handler.finished.connect(root.close);
	}
}
