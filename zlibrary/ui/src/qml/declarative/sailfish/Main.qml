import QtQuick 2.0
import Sailfish.Silica 1.0

ApplicationWindow {
    id: root
    
    initialPage: MainPage {
		id: mainPage
	}
    
    Connections {
		target: dialogManager

		onDialogRequested: {
			var component = Qt.createComponent("SimpleDialog.qml");
			root.openDialog(component.createObject(mainPage, { handler: object }));
		}
		
		onOptionsDialogRequested: {
			var component = Qt.createComponent("OptionsDialog.qml");
			root.pageStack.push(component, { handler: object, rootWindow: root, component: component });
		}
		
        onFileDialogRequested: {
			var component = Qt.createComponent("OpenFileDialog.qml");
			root.openDialog(component.createObject(mainPage, { handler: object }));
		}
		
        onTreeDialogRequested: {
			console.log("bla-bla", object)
			var component = Qt.createComponent("TreeDialogPage.qml");
			root.pageStack.push(component, { handler: object, rootWindow: root, component: component });
		}
		
		onProgressDialogRequested: {
			root.openDialog(progressDialog.createObject(root.pageStack.parent.parent, { handler: object }));
		}

		onQuestionDialogRequested: {
			var component = Qt.createComponent("QuestionDialog.qml");
			root.openDialog(component.createObject(root.pageStack.parent.parent, { handler: object }));
		}
		
		onInformationBoxRequested: {
			// var title, message, button
			var args = { "titleText": title, "message": message, "acceptButtonText": button };
			root.openDialog(queryDialog.createObject(mainPage, args));
		}
		onErrorBoxRequested: {
			// var title, message, button
			var args = { "titleText": title, "message": message, "acceptButtonText": button };
			root.openDialog(queryDialog.createObject(mainPage, args));
		}
	}
    function openDialog(dialog) {
        if (dialog.open !== undefined)
            dialog.open();
        if (dialog.statusChanged !== undefined) {
            dialog.statusChanged.connect(
                function() {
                    if (dialog.status == DialogStatus.Closed) {
                        dialog.destroy();
                        // hook for toolbar activity
                        if (root.pageStack.currentPage == mainPage)
                            mainPage.state = ""
                    }
            });
        }
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
