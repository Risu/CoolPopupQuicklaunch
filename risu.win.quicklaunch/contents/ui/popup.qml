//contact: piotr4@gmail.com
//GPLv3

import QtQuick 2.6
import QtQuick.Controls 2.3 //Qt 5.10
import Qt.labs.folderlistmodel 2.0
import QtQml 2.3

Menu {
    
    id: contextMenu
    title: ""
    width: menuWidth
    cascade: true
    overlap: 0

    property string filepath
    property FolderListModel folderModel
    property int nesting : 0;
    property var itemComponent : Qt.createComponent("popupMenuItem.qml");

    Rectangle {
        id: framebuffer
    }
    
    TextMetrics {
        id: textMetrics
        font.family: contextMenu.font.family
        text: ""
    }
    
    Instantiator {
        id: instantiator
        model: folderModel
        
        onObjectAdded: {
                var asMenu = object.file_is_dir;
                if(asMenu)
                {
                    contextMenu.nesting++;
                    if(contextMenu.nesting > maxNested) { asMenu = false;   contextMenu.nesting--;}
                }
                if (asMenu) {
                    var popupComponent = Qt.createComponent("popup.qml")
                    var modelComponent = Qt.createComponent("folderModel.qml")

                    var innerfolderModel = modelComponent.createObject(
                                contextMenu, {
                                    "folder": "file://" + object.file_path
                                })
                    textMetrics.text = object.file_name;
                    var mWidth = 65 + textMetrics.advanceWidth;
                    if(mWidth > width) width = mWidth;
                    var innerMenu = popupComponent.createObject(contextMenu, {
                                                                    "title": object.file_name,
                                                                    "folderModel": innerfolderModel,
                                                                    "nesting": contextMenu.nesting,
                                                                    "filepath" : object.file_path
                                                                })
                    contextMenu.insertMenu(index, innerMenu)           
                    contextMenu.nesting--;
                    modelComponent.destroy()
                    popupComponent.destroy()

                } else {
                    var menu_icon = "unknown";
                    //TODO handle lack extension case
                    favoritesModel.addFavorite(object.file_path, 0);
                    var modelIndex = favoritesModel.index(0,0);
                    if (favoritesModel.data(modelIndex, Qt.UserRole + 3) == object.file_path) menu_icon = favoritesModel.data(modelIndex, Qt.DecorationRole);
                    var sName = object.file_name.split(".")[0];
                    textMetrics.text = sName;
                    var mWidth = 65 + textMetrics.advanceWidth;
                    if(mWidth > width) width = mWidth;
                    var menuItem = itemComponent.createObject(framebuffer, {
                                                                    "text": sName,
                                                                "filepath": object.file_path,
                                                                "source" : menu_icon,
                                                                "mIndex" : modelIndex
                                                            }
                                                        )

                    if(foldersFirst) contextMenu.insertItem(0, menuItem); else contextMenu.addItem(menuItem);

                }
        }
        
        onObjectRemoved: {
            if(object.file_is_dir)
            {
                 for(var i = (contextMenu.count-1); i >= 0; i--){
                     if(contextMenu.menuAt(i) != null){
                           if(contextMenu.menuAt(i).filepath == object.file_path){
                                var iTM = contextMenu.takeMenu(i);
                                iTM.destroy();
                                contextMenu.width = menuWidth;
                                break;
                           }
                      }
                 }
            } else
            {
                for(var i = (contextMenu.count-1); i >= 0; i--){
                    if(contextMenu.itemAt(i) != null){
                        if(contextMenu.itemAt(i).filepath == object.file_path){
                            var iTI = contextMenu.takeItem(i);
                            iTI.destroy();
                            contextMenu.width = menuWidth;
                            break;
                        }
                    }
                }
            }

        }
        
        delegate: Item {
            property string file_name: fileName
            property string file_path: filePath
            property bool file_is_dir: fileIsDir
        }
    }
    
    //onAboutToShow: console.log("onAboutToShow")
    //onOpened: console.log("opened");
    
    Component.onDestruction: {
        if(itemComponent!= null) itemComponent.destroy();
    }
    
}
