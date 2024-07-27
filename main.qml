import QtQuick
import QtQuick.Controls

import org.qgis 1.0
import org.qfield 1.0

import Theme 1.0

Item {
  property var canvasMenu: iface.findItemByObjectName('canvasMenu')
  property var mapCanvas: iface.findItemByObjectName('mapCanvas')

  Component.onCompleted: {
    iface.addItemToCanvasActionsToolbar(amapnavto)
  }


  MenuItem {
    id: amapnavto
    width: parent.width
    height: 48
    leftPadding: Theme.menuItemLeftPadding

    QfToolButton {
      id: amapicon
      iconSource: 'icon.svg'
    }
    Text {
      id: amaptext
      anchors.verticalCenter: parent.verticalCenter
      leftPadding: Theme.menuItemLeftPadding + 36
      text: qsTr("使用高德地图导航至此位置")
      font: Theme.defaultFont
      color: Theme.mainTextColor
    }

    onTriggered: {
      if (Qt.platform.os === 'android')
      { // 将地图坐标转换为 WGS84 坐标
        const wgs_84_point = GeometryUtils.reprojectPointToWgs84(canvasMenu.point, mapCanvas.mapSettings.destinationCrs)
        openAMap(wgs_84_point.y, wgs_84_point.x)
      } else {
      iface.mainWindow().displayToast(`不支持${Qt.platform.os}平台的导航`)
    }
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