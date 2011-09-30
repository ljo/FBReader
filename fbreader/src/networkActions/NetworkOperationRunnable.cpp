/*
 * Copyright (C) 2008-2010 Geometer Plus <contact@geometerplus.com>
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

#include <ZLDialogManager.h>
#include <ZLProgressDialog.h>
#include <ZLNetworkManager.h>
#include <ZLTimeManager.h>

#include "NetworkOperationRunnable.h"

#include "../network/NetworkItems.h"
#include "../network/NetworkLink.h"
#include "../network/NetworkLinkCollection.h"
#include "../network/authentication/NetworkAuthenticationManager.h"
#include "../networkTree/NetworkNodes.h"

NetworkOperationRunnable::NetworkOperationRunnable(const std::string &uiMessageKey) {
	myDialog =
		ZLDialogManager::Instance().createProgressDialog(ZLResourceKey(uiMessageKey));
}

NetworkOperationRunnable::NetworkOperationRunnable() {
	shared_ptr<NetworkOperationRunnable> holder = this;
	myListenerHolder = holder.staticCast<ZLExecutionData::Listener>();
	myRunnableHolder = holder.staticCast<ZLRunnable>();
}

NetworkOperationRunnable::~NetworkOperationRunnable() {
}

void NetworkOperationRunnable::destroy() {
	ZLTimeManager::deleteLater(myListenerHolder);
	myRunnableHolder.reset();
	myListenerHolder.reset();
}

void NetworkOperationRunnable::showPercent(int ready, int full) {
	(void)ready;
	(void)full;
}

void NetworkOperationRunnable::executeWithUI() {
	myDialog->run(*this);
}

bool NetworkOperationRunnable::hasErrors() const {
	return !myErrorMessage.empty();
}

void NetworkOperationRunnable::showErrorMessage(const std::string &message) {
	ZLDialogManager::Instance().errorBox(
		ZLResourceKey("networkError"),
		message
	);
}

const std::string &NetworkOperationRunnable::errorMessage() const {
	return myErrorMessage;
}

bool NetworkOperationRunnable::tryConnect() {
	if (!ZLNetworkManager::Instance().connect()) {
		showErrorMessage(
			ZLResource::resource("dialog")
				["networkError"]
				["couldntConnectToNetworkMessage"].value()
		);
		return false;
	}
	return true;
}

void NetworkOperationRunnable::showErrorMessage() const {
	if (!myErrorMessage.empty()) {
		showErrorMessage(myErrorMessage);
	}
}

DownloadBookListener::~DownloadBookListener() {
}

DownloadBookRunnable::DownloadBookRunnable(shared_ptr<BookReference> reference, shared_ptr<NetworkAuthenticationManager> authManager) {
	myReference = reference;
	myAuthManager = authManager;
	myListener = 0;
}

DownloadBookRunnable::DownloadBookRunnable(const std::string &url) {
	myReference = new BookReference(url, BookReference::NONE, BookReference::DOWNLOAD_FULL);
	myListener = 0;
}

DownloadBookRunnable::~DownloadBookRunnable() {
}

void DownloadBookRunnable::setListener(DownloadBookListener *listener) {
	myListener = listener;
}

void DownloadBookRunnable::run() {
	NetworkLinkCollection::Instance().downloadBook(
		*myReference, myFileName,
		myAuthManager.isNull() ? ZLNetworkSSLCertificate::NULL_CERTIFICATE : myAuthManager->certificate(),
		myListenerHolder
	);
}

void DownloadBookRunnable::finished(const std::string &error) {
	myErrorMessage = error;
	if (!myListener)
		return;
	myListener->bookDownloaded(this);
	destroy();
}

shared_ptr<BookReference> DownloadBookRunnable::reference() const {
	return myReference;
}

const std::string &DownloadBookRunnable::fileName() const {
	return myFileName;
}


IsAuthorisedRunnable::IsAuthorisedRunnable(NetworkAuthenticationManager &mgr) :
	NetworkOperationRunnable("authenticationCheck"),
	myManager(mgr),
	myResult(B3_UNDEFINED) {
}

void IsAuthorisedRunnable::run() {
	NetworkAuthenticationManager::AuthenticationStatus auth = myManager.isAuthorised(true);
	myErrorMessage = auth.Message;
	myResult = auth.Status;
}

ZLBoolean3 IsAuthorisedRunnable::result() {
	return myResult;
}


AuthoriseRunnable::AuthoriseRunnable(NetworkAuthenticationManager &mgr, const std::string &password) : 
	NetworkOperationRunnable("authentication"), 
	myManager(mgr), 
	myPassword(password) {
}

AuthoriseRunnable::AuthoriseRunnable(NetworkAuthenticationManager &mgr, const std::string &password, shared_ptr<ZLExecutionData::Listener> listener)
    : myManager(mgr), 
      myPassword(password),
      myListener(listener) {
	ZLTimeManager::addAutoRemovableTask(myRunnableHolder);
}

void AuthoriseRunnable::run() {
	if (myListener.isNull())
		myErrorMessage = myManager.authorise(myPassword);
	else
		myManager.authorise(myPassword, myListenerHolder);
}

void AuthoriseRunnable::finished(const std::string &error) {
	myErrorMessage = error;
	myListener->finished(myErrorMessage);
	destroy();
}


InitializeAuthenticationManagerRunnable::InitializeAuthenticationManagerRunnable(NetworkAuthenticationManager &mgr) : 
	NetworkOperationRunnable("initializeAuthenticationManager"), 
	myManager(mgr) {
}

void InitializeAuthenticationManagerRunnable::run() {
	myErrorMessage = myManager.initialize();
}


LogOutRunnable::LogOutRunnable(NetworkAuthenticationManager &mgr) :
	NetworkOperationRunnable("signOut"), 
	myManager(mgr) {
}

LogOutRunnable::LogOutRunnable(NetworkAuthenticationManager &mgr, shared_ptr<ZLExecutionData::Listener> listener) :
	myManager(mgr), myListener(listener) {
	ZLTimeManager::addAutoRemovableTask(myRunnableHolder);
}

void LogOutRunnable::run() {
	if (myManager.isAuthorised(false).Status != B3_FALSE) {
		myManager.logOut(myListenerHolder);
	} else if (myListener) {
		myListener->finished(std::string());
		destroy();
	}
}

void LogOutRunnable::finished(const std::string &error) {
	myListener->finished(error);
	destroy();
}

PurchaseBookRunnable::PurchaseBookRunnable(NetworkAuthenticationManager &mgr, const NetworkBookItem &book) : 
	NetworkOperationRunnable("purchaseBook"), 
	myManager(mgr), 
	myBook(book) {
}

void PurchaseBookRunnable::run() {
	myErrorMessage = myManager.purchaseBook(myBook);
}

PasswordRecoveryRunnable::PasswordRecoveryRunnable(NetworkAuthenticationManager &mgr, const std::string &email) : 
	NetworkOperationRunnable("passwordRecovery"), 
	myManager(mgr), 
	myEMail(email) {
}

void PasswordRecoveryRunnable::run() {
	myErrorMessage = myManager.recoverPassword(myEMail);
}

RegisterUserRunnable::RegisterUserRunnable(NetworkAuthenticationManager &mgr, const std::string &login, const std::string &password, const std::string &email) : 
	NetworkOperationRunnable("registerUser"), 
	myManager(mgr), 
	myLogin(login), 
	myPassword(password), 
	myEMail(email) {
}

void RegisterUserRunnable::run() {
	myErrorMessage = myManager.registerUser(myLogin, myPassword, myEMail);
}


SearchRunnable::SearchRunnable() : NetworkOperationRunnable("downloadBookList") {
}


SimpleSearchRunnable::SimpleSearchRunnable(const std::string &pattern) : myPattern(pattern) {
}

void SimpleSearchRunnable::run() {
	mySearchResult = NetworkLinkCollection::Instance().simpleSearch(myPattern);
	myErrorMessage = NetworkLinkCollection::Instance().errorMessage();
}


AdvancedSearchRunnable::AdvancedSearchRunnable(const std::string &titleAndSeries, const std::string &author, const std::string &category, const std::string &description) : myTitleAndSeries(titleAndSeries), myAuthor(author), myCategory(category), myDescription(description) {
}

void AdvancedSearchRunnable::run() {
	mySearchResult = NetworkLinkCollection::Instance().advancedSearch(myTitleAndSeries, myAuthor, myCategory, myDescription);
	myErrorMessage = NetworkLinkCollection::Instance().errorMessage();
}


LoadSubCatalogRunnable::LoadSubCatalogRunnable(NetworkCatalogNode *node) : myNode(node) {
	myNode->item().loadChildren(myChildren, myListenerHolder);
}

void LoadSubCatalogRunnable::finished(const std::string &error) {
	myErrorMessage = error;
	myNode->onChildrenReceived(this);
	destroy();
}

void LoadSubCatalogRunnable::run() {
//	myErrorMessage = myItem.loadChildren(myChildren);
}
