import QtQuick 2.0
import Sailfish.Silica 1.0
import org.fbreader 0.14

Page {
    id: treeDialog
    property variant handler

    TreeDialogPage {
        handler: handler
    }

    Connections{
        target: handler
        onFinished: {
            console.log("tree dialog finished")
            pageStack.pop(treeDialog)
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Inactive){
            if (handler != null)
                handler.finish()
        }
    }
}
