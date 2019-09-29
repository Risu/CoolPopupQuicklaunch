//contact: piotr4@gmail.com
//GPLv3

import QtQuick 2.6
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as Controls1
import QtQuick.Dialogs 1.2

Item
{
    id: settings
    signal configurationChanged
    property int currentEditedColor : 0
    property alias rctItemDefault : rctItemDefault
    property alias rctItemHighlighted : rctItemHighlighted

    function saveConfig() {
        
        if(plasmoid.configuration.maxNested != maxNestedConfig.value ||
            plasmoid.configuration.minMenuWidth != minMenuWidthConfig.value ||
            plasmoid.configuration.foldersFirst != foldersFirstConfig.checked) plasmoid.configuration.forceRefresh = true;

        plasmoid.configuration.maxNested = maxNestedConfig.value;
        plasmoid.configuration.foldersFirst = foldersFirstConfig.checked;
        plasmoid.configuration.minMenuWidth = minMenuWidthConfig.value;

        if(irbArrow.checked) plasmoid.configuration.iconType = 0;
        if(irbCWhite.checked) plasmoid.configuration.iconType = 1;
        if(irbCBlack.checked) plasmoid.configuration.iconType = 2;

        plasmoid.configuration.slimIcon = slimIconConfig.checked;
        
        plasmoid.configuration.itemDefaultColor = rctItemDefault.color;
        plasmoid.configuration.itemHighlightedColor = rctItemHighlighted.color;

    }
    
    ColumnLayout {

        id: layout
        spacing: 20
        x: 5

        GroupBox { //"Quicklaunch Icon:"            
            id : gb1
            Layout.fillWidth: true
            ColumnLayout {

                RowLayout {                 
                    spacing:  30

                    Label {
                        text: "Quicklaunch Icon:"
                    }

                    ColumnLayout {                   
                        RadioButton {
                            id: irbArrow
                            text: "Arrow auto"
                        }
                        RadioButton {
                            id: irbCWhite
                            text: ">> White"
                        }
                        RadioButton {
                            id: irbCBlack
                            text: ">> Black"
                        }
                        Component.onCompleted: {
                            irbArrow.checked = false;
                            irbCWhite.checked = false;
                            irbCBlack.checked = false;
                            if(plasmoid.configuration.iconType == 0) irbArrow.checked = true;
                            if(plasmoid.configuration.iconType == 1) irbCWhite.checked = true;
                            if(plasmoid.configuration.iconType == 2) irbCBlack.checked = true;
                        }

                    }

                }

                CheckBox {
                    id: slimIconConfig
                    text: "Slim icon (requires restart)"
                    //Layout.alignment: Qt.AlignHCenter
                    checked: plasmoid.configuration.slimIcon
                }
            }
            
        }

        GroupBox { //"Display folders:"

            Layout.fillWidth: true
            RowLayout {

                spacing:  30
                Label {
                    text: "Display folders:"
                }

                ColumnLayout {
                    RadioButton {
                        id: rb1
                        text: "On top"
                    }
                    RadioButton {
                        id: foldersFirstConfig
                        text: "On bottom"
                    }
                    Component.onCompleted: {

                                  //  width = gb1.width;
                        if(plasmoid.configuration.foldersFirst)
                        {
                            foldersFirstConfig.checked = true;
                            rb1.checked = false;
                        } else
                        {
                            foldersFirstConfig.checked = false;
                            rb1.checked = true;
                        }
                    }
                }

            }
        }
        
        GroupBox { //"Item text colors:"
            
            title:  "Item text colours:"
            font.underline: true
            Layout.fillWidth: true
            
            ColumnLayout {   
                
                RowLayout { //"Default text colour:"
                    
                        spacing:  20
                        Label {
                            id: lb1
                            text: "Default text colour:"
                        } 
                        
                        MouseArea {
                            width: 70
                            height: lb1.height
                            hoverEnabled: true

                            onClicked: {currentEditedColor = 0; colDialog.color = rctItemDefault.color; colDialog.open() }

                            Rectangle {
                                id: rctItemDefault
                                anchors.fill: parent
                                color: plasmoid.configuration.itemDefaultColor
                                border.width: 2
                                border.color: parent.containsMouse ? theme.highlightColor : "black"
                            }
                        }
                }
                
                RowLayout { //"Highlighted text colour:"
            
                        spacing:  20                    
                        Label {
                            id: lb2
                            text: "Highlighted text colour:"
                        } 
                    
                        MouseArea {
                            width: 70
                            height: lb2.height
                            hoverEnabled: true

                            onClicked: {currentEditedColor = 1; colDialog.color = rctItemHighlighted.color;  colDialog.open() }

                            Rectangle {
                                id: rctItemHighlighted
                                anchors.fill: parent 
                                color: plasmoid.configuration.itemHighlightedColor
                                border.width: 2
                                border.color: parent.containsMouse ? theme.highlightColor : "black"
                            }
                        }    
                }
                
            }
            
        }

        RowLayout { //"Minimum width of the menu item:"

            spacing:  10
            Label {
                text: "Minimum width of the menu item:"
            }

            Controls1.SpinBox {
                id: minMenuWidthConfig
                value: plasmoid.configuration.minMenuWidth
                minimumValue: 50
                maximumValue: 999
                stepSize: 1
                implicitWidth: 80

            }

        }

        RowLayout { //"Maximum number of nested folders:"

            spacing:  10
            Label {
                text: "Maximum number of nested folders:"
            }

            Controls1.SpinBox {
                id: maxNestedConfig
                value: plasmoid.configuration.maxNested
                minimumValue: 1
                maximumValue: 20
                stepSize: 1
                implicitWidth: 60

            }

        }
        
    }
    
    ColorDialog {
		id: colDialog
		visible: false
		modality: Qt.WindowModal
		title: "Choose a colour:"
		showAlphaChannel: false
		color: "white"
        onAccepted: {
            if(currentEditedColor == 0) {
                rctItemDefault.color = colDialog.color;
            }
            if(currentEditedColor == 1) {
                rctItemHighlighted.color = colDialog.color;
            }                
		}
	}
    
}
