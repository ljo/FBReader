import QtQuick 2.0
import Sailfish.Silica 1.0

ApplicationWindow {
    id: root

    initialPage: Component { MainPage { } }
    
    Connections {
        target: dialogManager

        onDialogRequested: {
            console.log("onDialogRequested", object)
            var dialog = pageStack.push("SimpleDialog.qml", {handler : object})
        }
		
        onOptionsDialogRequested: {
            console.log("onOptionsDialogRequested", object)
            var page = pageStack.push("OptionsDialog.qml", { handler: object })
        }
		
        onFileDialogRequested: {
            console.log("onFileDialogRequested", object)
            var component = Qt.createComponent("OpenFileDialog.qml");
            root.openDialog(component.createObject(mainPage, { handler: object }));
        }
		
        onTreeDialogRequested: {
            console.log("onTreeDialogRequested", object)
            var page = pageStack.push("TreeDialogPage.qml", { handler: object });
        }
		
        onProgressDialogRequested: {
            console.log("onProgressDialogRequested", object)
//            var component = Qt.createComponent("ProgressDialog.qml");
//            root.openDialog(component.createObject(root, { handler: object }));
        }

        onQuestionDialogRequested: {
            console.log("onQuestionDialogRequested", object)
            //var component = Qt.createComponent("QuestionDialog.qml");
            root.openDialog(questionDialog.createObject(root, { handler: object }));
        }
		
        onInformationBoxRequested: {
            console.log("onInformationBoxRequested", object)
            // var title, message, button
            var args = { "titleText": title, "message": message, "acceptButtonText": button };
            root.openDialog(queryDialog.createObject(mainPage, args));
        }
        onErrorBoxRequested: {
            console.log("onErrorBoxRequested", object)
            // var title, message, button
            var args = { "titleText": title, "message": message, "acceptButtonText": button };
            root.openDialog(queryDialog.createObject(mainPage, args));
        }
    }


    function openDialog(dialog) {
        if (dialog.open !== undefined)
            dialog.open();
        if (dialog.statusChanged !== undefined) {
            dialog.statusChanged.connect(function() {
                if (dialog.status === DialogStatus.Closed) {
                    dialog.destroy();
                }
            });
        }
    }
}
