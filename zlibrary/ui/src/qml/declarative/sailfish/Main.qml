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
            progressDialog.handler = object
            progressDialog.show()
        }

        onQuestionDialogRequested: {
            console.log("onQuestionDialogRequested", object)
            //var component = Qt.createComponent("QuestionDialog.qml");
            root.openDialog(questionDialog.createObject(root, { handler: object }));
        }

        onInformationBoxRequested: {
            var title, message, button
            console.log("onInformationBoxRequested", title, message, button)
            var args = { "title": title, "message": message, "acceptText": button }
            pushWhenPageStackNotBusy("MessageDialog.qml", args, PageStackAction.Immediate)
        }
        onErrorBoxRequested: {
            var title, message, button
            console.log("onErrorBoxRequested", title, message, button)
            var args = { "title": title, "message": message, "acceptText": button }
            pushWhenPageStackNotBusy("MessageDialog.qml", args, PageStackAction.Immediate)
        }
    }

    ProgressDialog {
         id: progressDialog
    }

    function pushWhenPageStackNotBusy(page, args, operationType){
        if (pageStack.busy) {
            pageStack.busyChanged.connect(whenNotBusy)
        } else {
            pageStack.push(page, args, operationType)
        }

        function whenNotBusy(){
            if (!pageStack.busy){
                var page = pageStack.push(page, args, operationType)
                if (page !== null) // push success
                    pageStack.busyChanged.disconnect(whenNotBusy)
            } else {
                console.log("pagestack busy!")
            }
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
