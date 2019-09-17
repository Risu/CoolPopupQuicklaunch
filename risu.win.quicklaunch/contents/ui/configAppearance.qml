//contact: piotr4@gmail.com
//GPLv3

import QtQuick 2.6
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4 as Controls1

Item
{
    id: settings
    signal configurationChanged

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

    
}
