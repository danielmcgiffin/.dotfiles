import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Mpris as Mpris
import Quickshell.Services.SystemTray as Tray
import Quickshell.Services.UPower as UPower
import Quickshell.Hyprland as Hyprland

PanelWindow {
    id: bar

    anchors.left: true
    anchors.right: true
    anchors.top: true

    color: "transparent"
    exclusionMode: PanelWindow.ExclusionMode.Auto
    aboveWindows: true

    readonly property color panelBase: "#11151a"
    readonly property color panelBorder: "#2a313a"
    readonly property color chipColor: "#1c242c"
    readonly property color chipBorder: "#333c45"
    readonly property color textPrimary: "#e5ecf4"
    readonly property color textMuted: "#8f9aa7"
    readonly property color accent: "#4a93b5"
    readonly property string glyphFont: "CaskaydiaMono Nerd Font"
    readonly property int chipPadding: 8
    readonly property int panelRadius: 12

    height: 36
    margins.left: 16
    margins.right: 16
    margins.top: 10
    exclusiveZone: height + margins.top

    readonly property var hyprland: Hyprland.Hyprland

    Rectangle {
        anchors.fill: parent
        radius: panelRadius
        color: panelBase
        border.color: panelBorder
        border.width: 1
    }

    function workspaceIcon(workspaceId, focused) {
        if (focused) return "\ufb7b"; // 󱓻
        const glyphs = { 1: "1", 2: "2", 3: "3", 4: "4", 5: "5", 6: "6", 7: "7", 8: "8", 9: "9" };
        return glyphs[workspaceId] ?? "\ue941";
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 12

        // Left block: glyph + workspaces
        RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

            Rectangle {
                color: chipColor
                radius: 8
                border.color: chipBorder
                border.width: 1
                implicitHeight: bar.height - bar.chipPadding
                implicitWidth: glyphText.implicitWidth + bar.chipPadding * 2
                Layout.alignment: Qt.AlignVCenter

                Text {
                    id: glyphText
                    anchors.centerIn: parent
                    text: "\ue900"
                    color: accent
                    font.pixelSize: 15
                    font.family: glyphFont
                }
            }

            Rectangle {
                color: chipColor
                radius: 8
                border.color: chipBorder
                border.width: 1
                implicitHeight: bar.height - bar.chipPadding
                implicitWidth: workspaceRow.implicitWidth + bar.chipPadding * 2
                Layout.alignment: Qt.AlignVCenter

                RowLayout {
                    id: workspaceRow
                    anchors.fill: parent
                    anchors.margins: bar.chipPadding
                    spacing: 6

                    Repeater {
                        model: bar.hyprland.workspaces.values

                        delegate: MouseArea {
                            required property var modelData
                            implicitWidth: workspaceLabel.implicitWidth
                            implicitHeight: workspaceLabel.implicitHeight
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: modelData.activate()

                            Text {
                                id: workspaceLabel
                                text: workspaceIcon(modelData.id, modelData.focused)
                                font.family: glyphFont
                                font.pixelSize: 12
                                font.bold: modelData.focused
                                color: modelData.focused ? textPrimary : textMuted
                                opacity: modelData.active ? 1.0 : 0.55
                            }
                        }
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Center block: media + clock
        RowLayout {
            spacing: 10
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

            Rectangle {
                color: chipColor
                radius: 8
                border.color: chipBorder
                border.width: 1
                implicitHeight: bar.height - bar.chipPadding
                implicitWidth: mediaRow.implicitWidth + bar.chipPadding * 2
                Layout.alignment: Qt.AlignVCenter

                RowLayout {
                    id: mediaRow
                    anchors.fill: parent
                    anchors.margins: bar.chipPadding
                    spacing: 6

                    property var players: Mpris.Mpris.players.values
                    property var activePlayer: {
                        for (const player of players) {
                            if (player.playbackState === Mpris.MprisPlaybackState.Playing) return player;
                        }
                        return players.length > 0 ? players[0] : null;
                    }

                    Text {
                        text: parent.activePlayer ? parent.activePlayer.identity : "No player"
                        color: textMuted
                        font.pixelSize: 10
                        font.bold: true
                        font.family: glyphFont
                    }

                    Text {
                        text: parent.activePlayer && parent.activePlayer.trackTitle.length > 0
                              ? parent.activePlayer.trackTitle
                              : ""
                        visible: parent.activePlayer && parent.activePlayer.trackTitle.length > 0
                        color: textPrimary
                        font.pixelSize: 10
                        elide: Text.ElideRight
                        Layout.preferredWidth: 220
                    }
                }
            }

            Rectangle {
                color: chipColor
                radius: 8
                border.color: chipBorder
                border.width: 1
                implicitHeight: bar.height - bar.chipPadding
                implicitWidth: clockText.implicitWidth + bar.chipPadding * 2
                Layout.alignment: Qt.AlignVCenter

                Text {
                    id: clockText
                    anchors.centerIn: parent
                    property date now: new Date()
                    text: Qt.formatDateTime(now, "ddd HH:mm")
                    color: textPrimary
                    font.pixelSize: 11
                    font.bold: true
                    font.family: glyphFont

                    Timer {
                        interval: 1000
                        repeat: true
                        running: true
                        onTriggered: clockText.now = new Date()
                    }
                }
            }
        }

        Item { Layout.fillWidth: true }

        // Right block: battery + tray
        RowLayout {
            spacing: 8
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

            Rectangle {
                color: chipColor
                radius: 8
                border.color: chipBorder
                border.width: 1
                implicitHeight: bar.height - bar.chipPadding
                implicitWidth: batteryRow.implicitWidth + bar.chipPadding * 2
                Layout.alignment: Qt.AlignVCenter

                RowLayout {
                    id: batteryRow
                    anchors.fill: parent
                    anchors.margins: bar.chipPadding
                    spacing: 6

                    property var battery: UPower.UPower.displayDevice

                    Rectangle {
                        id: batteryBody
                        width: 22
                        height: 10
                        radius: 3
                        border.color: chipBorder
                        border.width: 1
                        color: !batteryRow.battery || !batteryRow.battery.ready
                               ? chipBorder
                               : batteryRow.battery.percentage <= 20 ? "#b35a5a" : accent

                        Rectangle {
                            anchors {
                                left: parent.left
                                top: parent.top
                                bottom: parent.bottom
                                margins: 1
                            }
                            width: parent.width * Math.min(
                                       1,
                                       Math.max(0, batteryRow.battery ? batteryRow.battery.percentage / 100 : 0)
                                   ) - 2
                            radius: 2
                            color: batteryRow.battery && batteryRow.battery.percentage <= 20 ? "#d27272" : "#d6f6ff"
                            visible: batteryRow.battery && batteryRow.battery.ready
                        }
                    }

                    Rectangle {
                        width: 3
                        height: 4
                        radius: 1
                        border.color: chipBorder
                        border.width: 1
                        color: Qt.darker(chipColor, 1.3)
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        text: batteryRow.battery && batteryRow.battery.ready
                              ? Math.round(batteryRow.battery.percentage) + "%"
                              : "…"
                        color: textPrimary
                        font.pixelSize: 10
                        font.family: glyphFont
                    }
                }
            }

            Rectangle {
                color: chipColor
                radius: 8
                border.color: chipBorder
                border.width: 1
                implicitHeight: bar.height - bar.chipPadding
                implicitWidth: trayRow.implicitWidth + bar.chipPadding * 2
                Layout.alignment: Qt.AlignVCenter

                RowLayout {
                    id: trayRow
                    anchors.fill: parent
                    anchors.margins: bar.chipPadding
                    spacing: 8

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
            }
        }
    }
}
