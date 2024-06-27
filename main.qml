import QtQuick
import QtQuick.Controls

import QtCore
import org.qgis 1.0
import org.qfield 1.0

import Theme 1.0

Item {
  property var mainWindow: iface.mainWindow()
  property var canvasMenu: iface.findItemByObjectName('canvasMenu')
  property var position: iface.findItemByObjectName('positionSource')
  property var mapCanvas: iface.findItemByObjectName('mapCanvas')

  Component.onCompleted: {
    iface.addItemToCanvasActionsToolbar(amapnavto)
  }


  MenuItem {
    id: amapnavto
    width: parent.width
    text: qsTr("使用高德地图导航至此位置")
    height: 48
    leftPadding: Theme.menuItemLeftPadding
    font: Theme.defaultFont
    icon.source: Theme.getThemeVectorIcon( "ic_compass_arrow_24dp" ) // 如何自定义图标?
    onTriggered: {
      // 将地图坐标转换为 WGS84 坐标
      const wgs_84_point = GeometryUtils.reprojectPointToWgs84(canvasMenu.point, mapCanvas.mapSettings.destinationCrs)
      openAMap(wgs_84_point.y, wgs_84_point.x)
    }
  }



  function openAMap(lat, lon)
  {
    // 参考: https://lbs.amap.com/api/amap-mobile/guide/android/route
    // 注意需要国测加密, 将 dev 设置为 1
    const uri = `amapuri://route/plan/?dlat=${lat}&dlon=${lon}&dname=来自QField的位置&dev=1&t=0`
    Qt.openUrlExternally(uri)
  }


}