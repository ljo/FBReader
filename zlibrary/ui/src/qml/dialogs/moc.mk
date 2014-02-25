SRCMOC = ZLQmlDialogManager.moc.cpp ZLQmlOpenFileDialog.moc.cpp ZLQmlQuestionDialog.moc.cpp ZLQmlDialogContent.moc.cpp ZLQmlOptionsDialog.moc.cpp ZLQmlOptionView.moc.cpp ZLQmlTree.moc.cpp ZLQmlDialog.moc.cpp ZLQmlProgressDialog.moc.cpp
ifneq "$(TARGET_ARCH)" "sailfish" # TODO: enable on sailfish
    SRCMOC += ZLQmlFileSystemModel.moc.cpp
endif