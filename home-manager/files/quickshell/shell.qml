import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.UPower as UPower
import Quickshell.Services.Mpris as Mpris
import Quickshell.Services.SystemTray as Tray

PanelWindow {
    id: bar

    anchors.left: true
    anchors.right: true
    anchors.top: true

    exclusionMode: PanelWindow.ExclusionMode.Auto
    exclusiveZone: height
    aboveWindows: true

    readonly property color steelBase: "#1b1f24"
    readonly property color steelHighlight: "#2c323a"
    readonly property color steelAccent: "#3c444f"
    readonly property color textStrong: "#e3e8f0"
    readonly property color textFaded: "#9aa1ab"
    readonly property color accentColor: "#5c8a9e"

    height: 44
    margins.top: 6
    margins.left: 20
    margins.right: 20

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 12
        color: bar.steelBase
        border.color: bar.steelAccent
        border.width: 1

        layer.enabled: false
    }

    RowLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: 12
        spacing: 16

        // Left segment: branding and quick status.
        RowLayout {
            id: leftSegment
            spacing: 8
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

            Rectangle {
                width: 16
                height: 16
                radius: 4
                border.color: bar.steelHighlight
                border.width: 1
                color: bar.accentColor
            }

            Column {
                spacing: -2
                Text {
                    text: "SteelBar"
                    color: bar.textStrong
                    font.bold: true
                    font.pointSize: 11
                }
                Text {
                    text: Qt.formatDateTime(new Date(), "dddd")
                    color: bar.textFaded
                    font.pointSize: 8
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        // Center segment: now playing.
        RowLayout {
            id: mediaSegment
            spacing: 8
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

            property var players: Mpris.Mpris.players.values
            property var activePlayer: {
                for (const player of players) {
                    if (player.playbackState === Mpris.MprisPlaybackState.Playing) {
                        return player
                    }
                }
                return players.length > 0 ? players[0] : null
            }

            Behavior on activePlayer {
                SequentialAnimation {
                    PropertyAnimation { duration: 120 }
                }
            }

            Text {
                text: mediaSegment.activePlayer ? mediaSegment.activePlayer.identity : "No player"
                color: bar.textFaded
                font.pointSize: 10
                font.bold: true
            }

            Text {
                visible: mediaSegment.activePlayer && mediaSegment.activePlayer.trackTitle.length > 0
                text: mediaSegment.activePlayer ? "-" : ""
                color: bar.textFaded
                font.pointSize: 9
            }

            Text {
                text: mediaSegment.activePlayer && mediaSegment.activePlayer.trackTitle.length > 0
                      ? mediaSegment.activePlayer.trackTitle
                      : ""
                color: bar.textStrong
                font.pointSize: 10
                elide: Text.ElideRight
                Layout.preferredWidth: 220
            }
        }

        Item {
            Layout.fillWidth: true
        }

        // Right segment: battery, tray, clock.
        RowLayout {
            id: rightSegment
            spacing: 12
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

            // Battery widget
            RowLayout {
                id: batteryWidget
                property var battery: UPower.UPower.displayDevice
                spacing: 6

                Rectangle {
                    id: batteryBody
                    width: 20
                    height: 10
                    radius: 2
                    border.color: bar.steelHighlight
                    border.width: 1
                    color: {
                        if (!batteryWidget.battery || !batteryWidget.battery.ready)
                            return bar.steelHighlight
                        return batteryWidget.battery.percentage <= 20 ? "#a85151" : bar.steelHighlight
                    }

                    Rectangle {
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                        }
                        width: parent.width * Math.min(1, Math.max(0, batteryWidget.battery ? batteryWidget.battery.percentage / 100 : 0))
                        radius: 2
                        color: batteryWidget.battery && batteryWidget.battery.percentage <= 20 ? "#d96f6f" : bar.accentColor
                    }
                }

                Rectangle {
                    width: 2
                    height: 4
                    radius: 1
                    color: bar.steelHighlight
                    anchors.verticalCenter: batteryBody.verticalCenter
                }

                Text {
                    text: batteryWidget.battery && batteryWidget.battery.ready
                          ? Math.round(batteryWidget.battery.percentage) + "%"
                          : "..."
                    color: bar.textStrong
                    font.pointSize: 10
                }
            }

            // System tray icons
            RowLayout {
                id: trayRow
                spacing: 6

                Repeater {
                    model: Tray.SystemTray.items

                    delegate: Item {
                        required property var modelData
                        width: 18
                        height: 18

                        Image {
                            anchors.fill: parent
                            source: modelData.icon
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                if (mouse.button === Qt.LeftButton) {
                                    modelData.activate()
                                } else if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                                    modelData.display(bar, mouse.x, mouse.y)
                                }
                            }
                        }
                    }
                }
            }

            // Clock
            Text {
                id: clockDisplay
                property date now: new Date()
                color: bar.textStrong
                font.bold: true
                font.pointSize: 11
                text: Qt.formatDateTime(now, "HH:mm")

                Timer {
                    interval: 1000
                    repeat: true
                    running: true
                    onTriggered: clockDisplay.now = new Date()
                }
            }
        }
    }
}
