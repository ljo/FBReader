/*
 * Copyright (C) 2004-2010 Geometer Plus <contact@geometerplus.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

#include <algorithm>

#if !QT5
    #include <QApplication>
    #include <QtOpenGL/QGLWidget>
    #include <QtDeclarative/QDeclarativeContext>
    #include <QtDeclarative/QDeclarativeEngine>
    #include <QStyleOptionGraphicsItem>
#else
    #include <QGuiApplication>
    #include <QQmlContext>
    #include <QQmlEngine>
#endif
#if SAILFISH
    #include <sailfishapp/sailfishapp.h>
#endif
#include <QPainter>
#include <QPixmap>
#include <QElapsedTimer>
#include <QDebug>
// #include <QLayout>
// #include <QScrollBar>
// #include <QMouseEvent>
// #include <QTapGesture>

// #include "ZLQmlSwipeGestureRecognizer.h"
#include "../dialogs/ZLQmlDialogManager.h"
#include "../util/ZLQtKeyUtil.h"
#include "../application/ZLQmlApplicationWindow.h"
#include "ZLQmlTreeImageProvider.h"
#include "ZLQmlNetworkAccessFactory.h"

#include <ZLibrary.h>
#include <ZLLanguageUtil.h>

#include "ZLQmlViewWidget.h"
#include "ZLQmlPaintContext.h"

// class MyQScrollBar : public QScrollBar {

// public:
	// MyQScrollBar(Qt::Orientation orientation, QWidget *parent) : QScrollBar(orientation, parent) {
	// }

// private:
	// void mouseMoveEvent(QMouseEvent *event) {
		// if (orientation() == Qt::Vertical) {
			// const int y = event->y();
			// if ((y <= 0) || (y >= height())) {
				// return;
			// }
		// } else {
			// const int x = event->x();
			// if ((x <= 0) || (x >= width())) {
				// return;
			// }
		// }
		// QScrollBar::mouseMoveEvent(event);
	// }
// };

void ZLQmlViewObject::repaint()	{
	if (myContent)
		QMetaObject::invokeMethod(myContent, "repaint", Qt::QueuedConnection);
}

void ZLQmlViewObject::setScrollbarEnabled(ZLView::Direction direction, bool enabled) {
//	qDebug() << Q_FUNC_INFO << direction << enabled;
	if (direction == ZLView::VERTICAL)
		myVerticalInfo->setEnabled(enabled);
	else
		myHorizontalInfo->setEnabled(enabled);
//	if (direction == ZLView::VERTICAL) {
//		myRightScrollBar->setShown(enabled && myShowScrollBarAtRight);
//		myLeftScrollBar->setShown(enabled && !myShowScrollBarAtRight);
//	} else {
//		myBottomScrollBar->setShown(enabled && myShowScrollBarAtBottom);
//		myTopScrollBar->setShown(enabled && !myShowScrollBarAtBottom);
//	}
}

void ZLQmlViewObject::setScrollbarPlacement(ZLView::Direction direction, bool standard) {
//	if ((rotation() == ZLView::DEGREES90) || (rotation() == ZLView::DEGREES270)) {
//		if (ZLLanguageUtil::isRTLLanguage(ZLibrary::Language())) {
//			standard = !standard;
//		}
//	}
//	if (direction == ZLView::VERTICAL) {
//		if (standard != myShowScrollBarAtRight) {
//			myShowScrollBarAtRight = standard;
//			QScrollBar *old = standard ? myLeftScrollBar : myRightScrollBar;
//			QScrollBar *current = standard ? myRightScrollBar : myLeftScrollBar;
//			if (old->isVisible()) {
//				old->hide();
//				current->show();
//			}
//		}
//	} else {
//		if (standard != myShowScrollBarAtBottom) {
//			myShowScrollBarAtBottom = standard;
//			QScrollBar *old = standard ? myTopScrollBar : myBottomScrollBar;
//			QScrollBar *current = standard ? myBottomScrollBar : myTopScrollBar;
//			if (old->isVisible()) {
//				old->hide();
//				current->show();
//			}
//		}
//	}
}

void ZLQmlViewObject::setScrollbarParameters(ZLView::Direction direction, size_t full, size_t from, size_t to) {
//	qDebug() << Q_FUNC_INFO << direction << full << from << to;
	if (direction == ZLView::VERTICAL)
		myVerticalInfo->setParameters(full, from, to);
	else
		myHorizontalInfo->setParameters(full, from, to);
//	if (direction == ZLView::VERTICAL) {
//		myContent->setHeight(full + from - to);
//	} else {
//		myContent->setWidth(full + from - to);
//	}
//	QScrollBar *bar =
//		(direction == ZLView::VERTICAL) ?
//			(myShowScrollBarAtRight ? myRightScrollBar : myLeftScrollBar) :
//			(myShowScrollBarAtBottom ? myBottomScrollBar : myTopScrollBar);
//	bar->setMinimum(0);
//	bar->setMaximum(full + from - to);
//	bar->setValue(from);
//	bar->setPageStep(to - from);
}

void ZLQmlViewObject::onVerticalSliderMoved(int value) {
//	QScrollBar *bar =
//		myShowScrollBarAtRight ? myRightScrollBar : myLeftScrollBar;
//	int maxValue = bar->maximum();
//	int pageStep = bar->pageStep();
//	value = std::max(std::min(value, maxValue), 0);
//	onScrollbarMoved(
//		ZLView::VERTICAL,
//		maxValue + pageStep,
//		value,
//		value + pageStep
//	);
}

void ZLQmlViewObject::onHorizontalSliderMoved(int value) {
//	QScrollBar *bar =
//		myShowScrollBarAtBottom ? myBottomScrollBar : myTopScrollBar;
//	int maxValue = bar->maximum();
//	int pageStep = bar->pageStep();
//	value = std::max(std::min(value, maxValue), 0);
//	onScrollbarMoved(
//		ZLView::HORIZONTAL,
//		maxValue + pageStep,
//		value,
//		value + pageStep
//	);
}

void ZLQmlViewObject::onVerticalSliderClicked(int value) {
//	switch (value) {
//		case QScrollBar::SliderSingleStepAdd:
//			onScrollbarStep(ZLView::VERTICAL, 1);
//			break;
//		case QScrollBar::SliderSingleStepSub:
//			onScrollbarStep(ZLView::VERTICAL, -1);
//			break;
//		case QScrollBar::SliderPageStepAdd:
//			onScrollbarPageStep(ZLView::VERTICAL, 1);
//			break;
//		case QScrollBar::SliderPageStepSub:
//			onScrollbarPageStep(ZLView::VERTICAL, -1);
//			break;
//	}
}

void ZLQmlViewObject::onHorizontalSliderClicked(int value) {
//	switch (value) {
//		case QScrollBar::SliderSingleStepAdd:
//			onScrollbarStep(ZLView::HORIZONTAL, 1);
//			break;
//		case QScrollBar::SliderSingleStepSub:
//			onScrollbarStep(ZLView::HORIZONTAL, -1);
//			break;
//		case QScrollBar::SliderPageStepAdd:
//			onScrollbarPageStep(ZLView::HORIZONTAL, 1);
//			break;
//		case QScrollBar::SliderPageStepSub:
//			onScrollbarPageStep(ZLView::HORIZONTAL, -1);
//			break;
//	}
}

#if QT5
QWindow *ZLQmlViewObject::widget() {
#else
QWidget *ZLQmlViewObject::widget() {
#endif
	return myWidget;
}
#if QT5
QQuickItem *ZLQmlViewObject::bookView() const {
#else
QDeclarativeItem *ZLQmlViewObject::bookView() const {
#endif
	return myContent;
}
#if QT5
void ZLQmlViewObject::setBookView(QQuickItem *bookView) {
#else
void ZLQmlViewObject::setBookView(QDeclarativeItem *bookView) {
#endif
	if (myContent == bookView)
		return;
	myContent = qobject_cast<ZLQmlBookContent*>(bookView);
	emit bookViewChanged(myContent);
}

QObject *ZLQmlViewObject::verticalScrollBar() const {
	return myVerticalInfo;
}

QObject *ZLQmlViewObject::horizontalScrollBar() const {
	return myHorizontalInfo;
}

void ZLQmlViewObject::handlePress(int x, int y) {
	view()->onStylusPress(x, y);
}

void ZLQmlViewObject::handleRelease(int x, int y) {
	view()->onStylusRelease(x, y);
}

void ZLQmlViewObject::handleMove(int x, int y) {
	view()->onStylusMove(x, y);
}

void ZLQmlViewObject::handleMovePressed(int x, int y) {
	view()->onStylusMovePressed(x, y);
}

void ZLQmlViewObject::handleFingerTap(int x, int y) {
	view()->onFingerTap(x, y);
}

void ZLQmlViewObject::handleScrollBarMoved(int full, int from, int to) {
	if (from < 0) {
		to -= from;
		from = 0;
	}
//	qDebug() << Q_FUNC_INFO << full << from << to;
	onScrollbarMoved(ZLView::VERTICAL, full, from, to);
//	repaint();
}

void ZLQmlViewObject::handleScrollBarStep(int steps) {
	onScrollbarStep(ZLView::VERTICAL, steps);
}

void ZLQmlViewObject::handleScrollBarPageStep(int steps) {
	onScrollbarPageStep(ZLView::VERTICAL, steps);
}

// QScrollBar *ZLQmlViewObject::addScrollBar(QGridLayout *layout, Qt::Orientation orientation, int x, int y) {
//	QScrollBar *scrollBar = new MyQScrollBar(orientation, myFrame);
//	layout->addWidget(scrollBar, x, y);
//	scrollBar->hide();
//	if (orientation == Qt::Vertical) {
//		connect(scrollBar, SIGNAL(sliderMoved(int)), this, SLOT(onVerticalSliderMoved(int)));
//		connect(scrollBar, SIGNAL(actionTriggered(int)), this, SLOT(onVerticalSliderClicked(int)));
//	} else {
//		connect(scrollBar, SIGNAL(sliderMoved(int)), this, SLOT(onHorizontalSliderMoved(int)));
//		connect(scrollBar, SIGNAL(actionTriggered(int)), this, SLOT(onHorizontalSliderClicked(int)));
//	}
//	return scrollBar;
	// return 0;
// }

ZLQmlViewObject::ZLQmlViewObject(ZLApplication *application)
    : ZLViewWidget((ZLView::Angle)application->AngleStateOption.value()), myApplication(application) {
	myContent = 0;
	myVerticalInfo = new ZLQmlScrollBarInfo(this);
	myHorizontalInfo = new ZLQmlScrollBarInfo(this);
#if SAILFISH
	myWidget = SailfishApp::createView();
#elif QT5
    myWidget = new QQuickView;
#else
    myWidget = new QDeclarativeView;
#endif
    myWidget->engine()->setNetworkAccessManagerFactory(new ZLQmlNetworkAccessFactory);
	myWidget->engine()->addImageProvider(QLatin1String("tree"), new ZLQmlTreeImageProvider);
#if MEEGO_EDITION
	QFont font;
	font.setFamily(QLatin1String("Nokia Pure"));
	font.setPointSize(24);
	qApp->setFont(font);
#endif
#if !QT5
	myWidget->setOptimizationFlags(QGraphicsView::DontSavePainterState);
    myWidget->setViewport(new QGLWidget(this));
#endif
	
    myWidget->rootContext()->setContextProperty(QLatin1String("objectHolder"), this);
	myWidget->rootContext()->setContextProperty(QLatin1String("applicationInfo"),
	                                  static_cast<ZLQmlApplicationWindow*>(&ZLApplicationWindow::Instance()));
    myWidget->rootContext()->setContextProperty(QLatin1String("dialogManager"),
                                      static_cast<ZLQmlDialogManager*>(&ZLDialogManager::Instance()));

	myWidget->setSource(QUrl::fromLocalFile(QString::fromStdString(ZLibrary::ZLibraryDirectory())
	                              + "/declarative/Main.qml"));
    
    myWidget->installEventFilter(new MyEventFilterObject);
}

bool MyEventFilterObject::eventFilter(QObject *object, QEvent *event){
    if (event->type() == QEvent::KeyPress) {
        QKeyEvent *kevent = static_cast<QKeyEvent*>(event);
        qDebug() << Q_FUNC_INFO << kevent->text();
        ZLApplicationWindow::Instance().application().doActionByKey(ZLQtKeyUtil::keyName(kevent));
    }
    return false;
}


void ZLQmlViewObject::trackStylus(bool track) {
//	qDebug("%s %s", Q_FUNC_INFO, track ? "true" : "false");
#if QT5
    // TODO 
#else
    myWidget->setMouseTracking(track);
#endif
}

 ZLQmlScrollBarInfo::ZLQmlScrollBarInfo(QObject *parent) : myEnabled(false) {
	myHeight = myTop = myBottom = 0;
}

ZLQmlScrollBarInfo::~ZLQmlScrollBarInfo() {
}

void ZLQmlScrollBarInfo::setEnabled(bool enabled) {
	if (enabled == myEnabled)
		return;
	myEnabled = enabled;
	emit enabledChanged(myEnabled);
}

void ZLQmlScrollBarInfo::setParameters(int full, int from, int to) {
	if (full != myHeight) {
		myHeight = full;
		emit heightChanged(myHeight);
	}
	if (from != myTop) {
		myTop = from;
		emit topChanged(myTop);
	}
	if (to != myBottom) {
		myBottom = to;
		emit bottomChanged(myBottom);
	}
}

bool ZLQmlScrollBarInfo::enabled() const {
	return myEnabled;
}

int ZLQmlScrollBarInfo::height() const {
	return myHeight;
}

int ZLQmlScrollBarInfo::top() const {
	return myTop;
}

int ZLQmlScrollBarInfo::bottom() const {
	return myBottom;
}

// #if QT5
// ZLQmlViewWidget::ZLQmlViewWidget(QWindow *parent, ZLQmlViewObject &holder) :
    // QQuickView(parent), myHolder(holder) {
// #else
// ZLQmlViewWidget::ZLQmlViewWidget(QWidget *parent, ZLQmlViewObject &holder) :
    // QDeclarativeView(parent), myHolder(holder) {
// #endif
	// //setBackgroundMode(NoBackground);
	// engine()->setNetworkAccessManagerFactory(new ZLQmlNetworkAccessFactory);
	// engine()->addImageProvider(QLatin1String("tree"), new ZLQmlTreeImageProvider);
	// QFont font;
// #if !QT5
	// font.setFamily(QLatin1String("Nokia Pure"));
	// font.setPointSize(24);
    // qApp->setFont(font);
// #else
	// font.setFamily(QLatin1String("Droid Sans"));
	// font.setPointSize(26);
    // QGuiApplication::setFont(font);
// #endif

// #if !QT5
	// setOptimizationFlags(QGraphicsView::DontSavePainterState);
    // setViewport(new QGLWidget(this));
// #endif
	
    // rootContext()->setContextProperty(QLatin1String("objectHolder"), &holder);

	// rootContext()->setContextProperty(QLatin1String("applicationInfo"),
	                                  // static_cast<ZLQmlApplicationWindow*>(&ZLApplicationWindow::Instance()));
    // rootContext()->setContextProperty(QLatin1String("dialogManager"),
                                      // static_cast<ZLQmlDialogManager*>(&ZLDialogManager::Instance()));

	// setSource(QUrl::fromLocalFile(QString::fromStdString(ZLibrary::ZLibraryDirectory())
	                              // + "/declarative/Main.qml"));
// }

// void ZLQmlViewWidget::keyPressEvent(QKeyEvent *event) {
	// ZLApplicationWindow::Instance().application().doActionByKey(ZLQtKeyUtil::keyName(event));
// #if QT5
    // return QQuickView::keyPressEvent(event);
// #else
	// return QDeclarativeView::keyPressEvent(event);
// #endif
// }

#if QT5
ZLQmlBookContent::ZLQmlBookContent(QQuickItem *parent) : QQuickPaintedItem(parent), myHolder(0) {
#else
ZLQmlBookContent::ZLQmlBookContent(QDeclarativeItem *parent) : QDeclarativeItem(parent), myHolder(0) {
#endif
#if QT5
    setFlag(ItemHasContents, true);
#else
	setFlag(ItemHasNoContents, false);
#endif
	myVisibleHeight = 400;
//	connect(this, SIGNAL(widthChanged()), this, SLOT(repaint()), Qt::QueuedConnection);
	connect(this, SIGNAL(heightChanged()), this, SLOT(repaint()), Qt::QueuedConnection);
}

ZLQmlBookContent::~ZLQmlBookContent() {
}

bool ZLQmlBookContent::eventFilter(QObject *obj, QEvent *event) {
//	if (event->type() == QEvent::Gesture) {;
//		QGestureEvent *gestureEvent = static_cast<QGestureEvent*>(event);
//		qDebug() << Q_FUNC_INFO << obj << gestureEvent->gestures();
//	}
#if QT5
    return QQuickItem::eventFilter(obj, event);
#else
	return QDeclarativeItem::eventFilter(obj, event);
#endif
}

ZLQmlViewObject *ZLQmlBookContent::objectHolder() const {
	return myHolder;
}

void ZLQmlBookContent::setObjectHolder(QObject *objectHolder) {
	if (objectHolder == myHolder)
		return;
	myHolder = qobject_cast<ZLQmlViewObject*>(objectHolder);
	emit objectHolderChanged(myHolder);
}

int ZLQmlBookContent::visibleHeight() const {
	return myVisibleHeight;
}

void ZLQmlBookContent::setVisibleHeight(int visibleHeight) {
	if (myVisibleHeight == visibleHeight)
		return;
	myVisibleHeight = visibleHeight;
	emit visibleHeightChanged(myVisibleHeight);
}

void ZLQmlBookContent::repaint() {
	if (!myHolder) {
		qDebug("%s: Can't find objectHolder", Q_FUNC_INFO);
		return;
	}
	if (myHolder->view().isNull())
		return;
	// Mey be there is way of optimization?
	if (myPixmap.width() != width() || myPixmap.height() < height()) {
		qDebug() << "Change size from" << myPixmap.size() << "to" << QSize(width(), height());
		myPixmap = QPixmap(width(), height());
	}
	ZLQmlPaintContext &context = static_cast<ZLQmlPaintContext&>(myHolder->view()->context());
	QPainter painter(&myPixmap);
	context.beginPaint(width(), height(), &painter);
	myHolder->view()->paint();
	context.endPaint();
	update();
}

#if QT5
void ZLQmlBookContent::paint(QPainter *painter) {
#else
void ZLQmlBookContent::paint(QPainter *painter, const QStyleOptionGraphicsItem *, QWidget *) {
#endif
    if (!myHolder) {
        qDebug("%s: Can't find objectHolder", Q_FUNC_INFO);
        return;
    }
    painter->drawPixmap(0, 0, myPixmap);
}

#if ! QT5
bool ZLQmlBookContent::sceneEvent(QEvent *event) {
//	if (event->type() == QEvent::Gesture && isVisibleTo(0)) {
//		QGestureEvent *gestureEvent = static_cast<QGestureEvent*>(event);
//		qDebug() << Q_FUNC_INFO << gestureEvent->gestures();
//		gestureEvent->ignore();
//		if (QGesture *gesture = gestureEvent->gesture(Qt::TapGesture)) {
////			gestureEvent->accept(Qt::TapGesture);
//			emit tap(gesture);
//		}
//		if (QGesture *gesture = gestureEvent->gesture(Qt::SwipeGesture)) {
////			gestureEvent->accept(Qt::SwipeGesture);
//			if (gesture->state() == Qt::GestureFinished)
//				emit swipe(gesture);
//		}
//	}

    return QDeclarativeItem::sceneEvent(event);
}
#endif

//void ZLQmlBookContent::mousePressEvent(QGraphicsSceneMouseEvent *event) {
//	if (!myHolder)
//		return;
////	qDebug("%s (%d, %d)", Q_FUNC_INFO, int(event->pos().x()), int(event->pos().y()));
////	myMousePos = event->pos();
//	myHolder->view()->onStylusMove(event->pos().x(), event->pos().y());
//	myHolder->view()->onStylusPress(event->pos().x(), event->pos().y());
//}

//void ZLQmlBookContent::mouseReleaseEvent(QGraphicsSceneMouseEvent *event) {
//	if (!myHolder)
//		return;
////	qDebug("%s (%d, %d)", Q_FUNC_INFO, int(event->pos().x()), int(event->pos().y()));
//	if (event->buttons() & Qt::LeftButton)
//		myHolder->view()->onStylusMovePressed(event->pos().x(), event->pos().y());
//	else
//		myHolder->view()->onStylusMove(event->pos().x(), event->pos().y());
//}

//void ZLQmlBookContent::mouseMoveEvent(QGraphicsSceneMouseEvent *event) {
//	if (!myHolder)
//		return;
////	qDebug("%s (%d, %d)", Q_FUNC_INFO, int(event->pos().x()), int(event->pos().y()));
//	myHolder->view()->onStylusRelease(event->pos().x(), event->pos().y());
//}
