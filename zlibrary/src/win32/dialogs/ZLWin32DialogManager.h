/*
 * Copyright (C) 2007 Nikolay Pultsin <geometer@mawhrin.net>
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

#ifndef __ZLWIN32DIALOGMANAGER_H__
#define __ZLWIN32DIALOGMANAGER_H__

#include <windows.h>

#include <ZLDialogManager.h>

class ZLWin32ApplicationWindow;

class ZLWin32DialogManager : public ZLDialogManager {

public:
	static void createInstance() { ourInstance = new ZLWin32DialogManager(); }

private:
	ZLWin32DialogManager() : myApplicationWindow(0) {}

public:
	void createApplicationWindow(ZLApplication *application) const;

	shared_ptr<ZLDialog> createDialog(const std::string &title) const;
	shared_ptr<ZLOptionsDialog> createOptionsDialog(const std::string &id, const std::string &title) const;
	void informationBox(const std::string &title, const std::string &message) const;
	void errorBox(const std::string &title, const std::string &message) const;
	int questionBox(const std::string &title, const std::string &message, const std::string &button0, const std::string &button1, const std::string &button2) const;
	bool selectionDialog(const std::string &title, ZLTreeHandler &handler) const;
	void wait(ZLRunnable &runnable, const std::string &message) const;

	//void grabKeyboard(bool grab) { myIsKeyboardGrabbed = grab; }
	//bool isKeyboardGrabbed() const { return myIsKeyboardGrabbed; }

private:
	mutable ZLWin32ApplicationWindow *myApplicationWindow;
};

#endif /* __ZLWIN32DIALOGMANAGER_H__ */