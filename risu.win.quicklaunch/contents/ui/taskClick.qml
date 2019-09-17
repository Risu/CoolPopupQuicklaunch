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
    y: (plasmoid.location == PlasmaCore.Types.BottomEdge) ? Screen.desktopAvailableHeight : 0
    color: "transparent"
    
    Rectangle {
        width: Screen.desktopAvailableWidth
        height: plasmoid.height
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
