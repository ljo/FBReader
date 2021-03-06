#include <QtGui/QApplication>
#include <QtGui/QDesktopWidget>
#include <QtGui/QLayout>
#include <QtGui/QPushButton>
#include <QtGui/QResizeEvent>
#include <QtGui/QScrollArea>
#include <QtGui/QAction>

#include <ZLDialogManager.h>

#include "ZLQtOptionsDialog.h"
#include "ZLQtDialogContent.h"
#include "ZLQtUtil.h"
#include "ScrollerManager.h"

#include "../menu/MenuDelegate.h"
#include "../menu/DrillDownMenu.h"
#include "../menu/ActionButtons.h"

TabMenuWidget::TabMenuWidget(QWidget* parent): QWidget(parent) {
	QVBoxLayout *layout = new QVBoxLayout(this);
	myStackedWidget = new QStackedWidget;
	myMenuWidget = new QListWidget;
        myMenuWidget->setItemDelegate(new SeparatorDelegate);
	layout->addWidget(myMenuWidget);
        layout->addWidget(myStackedWidget);
	setStatus(MENU);
        connect(myMenuWidget, SIGNAL(clicked(QModelIndex)), this, SLOT(menuItemClicked(QModelIndex)), Qt::QueuedConnection);

        ScrollerManager::setScroll(myMenuWidget);
}

void TabMenuWidget::addItem(QWidget *widget, const QString &label) {
        //myMenuWidget->addItem(label);
        myMenuWidget->addItem( new NiceSizeListWidgetItem(label) );
	myStackedWidget->addWidget(widget);
}

TabMenuWidget::ShowStatus TabMenuWidget::getStatus() const {
	return myMenuWidget->isVisible() ? MENU : TAB;
}

void TabMenuWidget::setStatus(ShowStatus status) {
	if (status == MENU) {
                myStackedWidget->hide();
		myMenuWidget->show();
#ifdef __SYMBIAN__
		// for phones with keyboard (activating for single-click):
		myMenuWidget->setEditFocus(true);
#endif
	} else if (status == TAB) {
                myMenuWidget->hide();
                myStackedWidget->show();
                myStackedWidget->setFocus();
	}
}

void TabMenuWidget::menuItemClicked(const QModelIndex &index) {
	myStackedWidget->setCurrentIndex(index.row());
	setStatus(TAB);
}

ZLQtOptionsDialog::ZLQtOptionsDialog(const ZLResource &resource, shared_ptr<ZLRunnable> applyAction, QWidget* parent) : QDialog(parent), ZLOptionsDialog(resource, applyAction) {
		setWindowTitle(::qtString(caption()));
		QVBoxLayout *layout = new QVBoxLayout(this);

		myTabMenuWidget = new TabMenuWidget(this);
		layout->addWidget(myTabMenuWidget);

                const std::string& back = ZLDialogManager::Instance().buttonName(ZLResourceKey("back"));
                QAction* backAction = new QAction(QString::fromStdString(back),this);
		backAction->setSoftKeyRole( QAction::NegativeSoftKey);
		addAction( backAction );
		connect(backAction, SIGNAL(triggered()), this, SLOT(back()));

#ifndef 	__SYMBIAN__
                QPushButton* backButton = new ButtonAction(backAction);
		layout->addWidget(backButton);
#endif
}

void ZLQtOptionsDialog::back() {
	if (myTabMenuWidget->getStatus() == TabMenuWidget::MENU) {
		QDialog::accept();
		return;
	}
	myTabMenuWidget->setStatus(TabMenuWidget::MENU);
}

ZLDialogContent &ZLQtOptionsDialog::createTab(const ZLResourceKey &key) {
        ZLQtDialogContent *tab = new ZLQtDialogContent(tabResource(key));
	myTabMenuWidget->addItem(tab->widget(), ::qtString(tab->displayName()));
	myTabs.push_back(tab);
	return *tab;
}

const std::string &ZLQtOptionsDialog::selectedTabKey() const {
	return myEmptyString;
}

void ZLQtOptionsDialog::selectTab(const ZLResourceKey &key) {
	Q_UNUSED(key);
}

bool ZLQtOptionsDialog::run() {
		setFullScreenWithSoftButtons();
		bool code = ZLOptionsDialog::run();
		return code;
}

void ZLQtOptionsDialog::setFullScreenWithSoftButtons() {
#ifdef __SYMBIAN__
	setWindowFlags(windowFlags() | Qt::WindowSoftkeysVisibleHint);
        setWindowState(Qt::WindowFullScreen);
#else
        setFixedSize(400,300);
#endif
}

bool ZLQtOptionsDialog::runInternal() {
	for (std::vector<shared_ptr<ZLDialogContent> >::iterator it = myTabs.begin(); it != myTabs.end(); ++it) {
		((ZLQtDialogContent&)**it).close();
	}
	return exec() == QDialog::Accepted;
}



