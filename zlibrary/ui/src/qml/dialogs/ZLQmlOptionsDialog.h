/*
 * Copyright (C) 2004-2011 Geometer Plus <contact@geometerplus.com>
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

#ifndef __ZLQTOPTIONSDIALOG_H__
#define __ZLQTOPTIONSDIALOG_H__

// #include <QWidget>
// #include <QTabWidget>
// #include <QDialog>
#include <QObject>
#include "../../../../core/src/dialogs/ZLOptionsDialog.h"


class ZLQmlOptionsDialog : public QObject, public ZLOptionsDialog {
	Q_OBJECT
	Q_PROPERTY(QList<QObject*> sections READ sections NOTIFY sectionsChanged)
	Q_PROPERTY(QString okButtonText READ applyButtonText CONSTANT)
	Q_PROPERTY(QString applyButtonText READ applyButtonText CONSTANT)
	Q_PROPERTY(QString cancelButtonText READ cancelButtonText CONSTANT)
	Q_PROPERTY(QString title READ title CONSTANT)
public:
	ZLQmlOptionsDialog(const ZLResource &resource, shared_ptr<ZLRunnable> applyAction, bool showApplyButton);
	~ZLQmlOptionsDialog();
	ZLDialogContent &createTab(const ZLResourceKey &key);

protected:
	QList<QObject *> sections() const;
	const std::string &selectedTabKey() const;
	void selectTab(const ZLResourceKey &key);
	bool runInternal();
	
	QString okButtonText() const;
	QString applyButtonText() const;
	QString cancelButtonText() const;
	QString title() const;
	
	Q_INVOKABLE void accept();
	Q_INVOKABLE void reject();

Q_SIGNALS:
	void sectionsChanged(const QList<QObject*> &sections);
	void finished();

private:
	QList<QWeakPointer<QObject> > mySections;
	QString myOkButtonText;
	QString myApplyButtonText;
	QString myCancelButtonText;
	QString myTitle;
	std::string myEmptyString;
	bool myShowApplyButton;
	bool myResult;
};

#endif /* __ZLQTOPTIONSDIALOG_H__ */
