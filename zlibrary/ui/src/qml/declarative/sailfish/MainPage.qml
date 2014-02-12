import QtQuick 2.0
import Sailfish.Silica 1.0
import org.fbreader 0.14

Page {
    id: root
    
    BookView {
		id: bookView
		width: parent.width
		height: parent.height // + root.pageStack.toolBar.height
		holder: objectHolder
		Component.onCompleted: objectHolder.bookView = bookView
		MouseArea {
			anchors.fill: parent
			onPressed: objectHolder.handlePress(mouse.x, mouse.y)
			onReleased: objectHolder.handleRelease(mouse.x, mouse.y)
			onPositionChanged: {
				if (pressed)
					objectHolder.handleMovePressed(mouse.x, mouse.y)
				else
					objectHolder.handleMove(mouse.x, mouse.y)
			}
		}
	}
    
    Connections {
		target: applicationInfo
		onMainMenuRequested: mainMenu.open()
	}
    
    Component {
		id: progressDialog
		ProgressDialog {
		}
	}
	
	Component {
		id: queryDialog
		Dialog {
		}
	}
}
