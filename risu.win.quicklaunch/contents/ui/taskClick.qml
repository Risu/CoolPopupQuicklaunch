//contact: piotr4@gmail.com
//GPLv3

import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.0
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

PlasmaCore.Dialog {
    
    id: taskClick
    visible: false
    type: PlasmaCore.Dialog.Dock
    flags: Qt.WindowStaysOnTopHint
    backgroundHints: "NoBackground"
    x: (plasmoid.location == PlasmaCore.Types.RightEdge) ? (Screen.desktopAvailableWidth + plasmoid.width) : 0
    y: (plasmoid.location == PlasmaCore.Types.BottomEdge) ? Screen.desktopAvailableHeight : 0
    color: "transparent"
    
    Rectangle {
        width: {
            if(plasmoid.location == PlasmaCore.Types.LeftEdge || plasmoid.location == PlasmaCore.Types.RightEdge) return (plasmoid.width + 5);
            return Screen.desktopAvailableWidth;
        }
        height: {
            if(plasmoid.location == PlasmaCore.Types.LeftEdge || plasmoid.location == PlasmaCore.Types.RightEdge) return Screen.desktopAvailableHeight;
            return (plasmoid.height + 5);
        }
        color: "transparent"
        
        MouseArea {
            anchors.fill: parent
            visible: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton 
            onClicked: {
                taskClick.visible = false;
                root.popup.width = 0;
                root.popup.height = 0;
            }
            
        }
        
    }

    
}
