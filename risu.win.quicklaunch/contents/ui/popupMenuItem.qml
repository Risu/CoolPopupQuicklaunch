//contact: piotr4@gmail.com
//GPLv3

import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQml 2.3
import org.kde.plasma.core 2.0 as PlasmaCore

MenuItem {
    
    id: menuItem
    property string filepath
    property var mIndex : -1
    property alias source  : menuItemIcon.source
    leftPadding: 45
    
    contentItem: Text {
            text: menuItem.text
            color: menuItem.highlighted ? "blue" : "#000000"          
        }

    PlasmaCore.IconItem {
        id: menuItemIcon
        width: 32
        height: 32
        x: 5
        source : "unkonwn"
    }
    
    arrow: Item { }
    
    background: MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onPressed:{
                 if (mouse.button === Qt.LeftButton) {
                     var found = false;
                     for (var i = 0; i < favoritesModel.count; i++) {
                         var modelIndex = favoritesModel.index(i, 0);
                         var favoriteId = favoritesModel.data(modelIndex, Qt.UserRole + 3);
                         if (favoriteId == filepath) {
                             found = true;
                             favoritesModel.trigger(i, "", 0);
                             break;
                         }
                     }
                     if(!found) kRun.openUrl(filepath);
                     menuItem.menu.dismiss();
                     root.popup.visible=false;
                 }
            }
        }
        
}



