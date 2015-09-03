import QtQuick 2.0
import Sailfish.Silica 1.0

ApplicationWindow {
    id: root

    allowedOrientations: Orientation.All

    initialPage: Component { MainPage { } }

    cover: CoverBackground {
    	 CoverPlaceholder {
            text: "FBReader"
            icon.source: "/usr/share/icons/hicolor/86x86/apps/harbour-fbreader.png"
         }
    }


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
            pushWhenPageStackNotBusy("QuestionDialog.qml", { handler: object }, PageStackAction.Immediate)
        }

        // following is a special case of QuestionDialog
        onYesNoDialogRequested: {
            var object
            console.log("onYesNoDialogRequested", object) // object is actually a ZLQmlQuestionDialog
            var args = {
                title: object.title,
                text: object.text,
                acceptText: object.buttons[0],
                rejectText: object.buttons[1]
            }
            var dialog = pageStack.push("YesNoDialog.qml", args)
            dialog.done.connect(function() {
                console.log("result", dialog.result == DialogResult.Accepted ? 0 : 1)
                object.press(dialog.result == DialogResult.Accepted ? 0 : 1) // 0 = yes, 1 = no/cancel
            })
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
