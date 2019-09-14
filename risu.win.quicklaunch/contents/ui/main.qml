//contact: piotr4@gmail.com
//GPLv3

import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQml 2.3
import QtQuick.Dialogs 1.2
import Qt.labs.folderlistmodel 2.0
import QtQuick.Window 2.0

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras

import org.kde.plasma.private.kicker 0.1 as Kicker
import org.kde.kio 1.0 as Kio

Item {
    id: root

    readonly property int maxNested: plasmoid.configuration.maxNested
    readonly property bool foldersFirst: plasmoid.configuration.foldersFirst
    readonly property int menuWidth: plasmoid.configuration.minMenuWidth
    property string quicklaunchFolder: plasmoid.configuration.quicklaunchFolder
    property bool forceRefresh: false
    property alias popup: popup

    Plasmoid.icon: {
        source: "arrow-up"
    }

    Kicker.RootModel {
        id: rootModel
        autoPopulate: false
        favoritesModel: Kicker.FavoritesModel {
            id: favoritesModel
        }
    }

    Kio.KRun {
        id: kRun
    }

    PlasmaCore.Dialog {
        id: popup
        type: PlasmaCore.Dialog.PopupMenu
        backgroundHints: "NoBackground"
        flags: Qt.WindowStaysOnTopHint
        //flags:  Qt.FramelessWindowHint
        hideOnWindowDeactivate: true
        location: plasmoid.location
        visualParent: plasmoid
        color: "transparent"
        mainItem: Rectangle {
            id: screenbuffer
            width: Screen.desktopAvailableWidth
            height: Screen.desktopAvailableHeight
            color: "transparent"
            property var popupComponent : Qt.createComponent("popup.qml")
            property var modelComponent : Qt.createComponent("folderModel.qml")
            property var folderModel : screenbuffer.modelComponent.createObject(screenbuffer.popupComponent, {"folder": quicklaunchFolder})
            property var contextMenu 
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: {
                        if(screenbuffer.contextMenu != null) screenbuffer.contextMenu.dismiss();
                        root.popup.visible = false
                }
            }
        }
    }

    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation
    Plasmoid.compactRepresentation: PlasmaCore.IconItem {
            source: Plasmoid.icon

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton 
                onClicked: {
                    if (mouse.button === Qt.LeftButton) {
                        if(quicklaunchFolder == "") {
                            folderDialog.open()
                        } else
                        {
                            if(!root.popup.visible)
                            {
                                if(forceRefresh) {
                                    if(screenbuffer.contextMenu != null) screenbuffer.contextMenu.dismiss();
                                    if(screenbuffer.contextMenu != null) screenbuffer.contextMenu.destroy();
                                    for (var i = (favoritesModel.count-1); i >= 0; i--) favoritesModel.removeFavorite(i);
                                    screenbuffer.contextMenu = null;
                                    forceRefresh = false;
                                }
                                root.popup.visible = true;
                                if(screenbuffer.contextMenu  == null) screenbuffer.contextMenu = screenbuffer.popupComponent.createObject(screenbuffer, {"folderModel": screenbuffer.folderModel})
                                screenbuffer.contextMenu.popup()
                            } else
                            {
                                if(screenbuffer.contextMenu != null) screenbuffer.contextMenu.dismiss();
                                root.popup.visible = false;
                            }
                        }
                    }

                }
            }
    }

    FileDialog {
        id: folderDialog
        title: "Please choose the main folder for quicklaunch shortcuts"
        folder: shortcuts.documents
        selectFolder: true
        //sidebarVisible: false
        onAccepted: {
            quicklaunchFolder = folderDialog.fileUrl;
            plasmoid.configuration.quicklaunchFolder = folderDialog.fileUrl;
            screenbuffer.folderModel.folder = folderDialog.fileUrl;
            forceRefresh = true;
        }
        onRejected: {
        }
        //Component.onCompleted: 
    }

    function action_refresh() {
         if(screenbuffer.contextMenu != null) screenbuffer.contextMenu.dismiss();
         forceRefresh = true;
    }
    
    function action_changeFolder() {
         if(screenbuffer.contextMenu != null) screenbuffer.contextMenu.dismiss();
         folderDialog.open();
    }

    Component.onCompleted: {
        plasmoid.setAction("refresh", "Rebuild Quicklaunch", "view-refresh");
        plasmoid.setAction("changeFolder", "Change Root Folder", "folder-add");
        plasmoid.setActionSeparator("extra")
    }
    Plasmoid.toolTipSubText: {
        "Don't forget to check for the new updated version."
    }
}
