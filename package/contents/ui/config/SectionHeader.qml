import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.3

ColumnLayout {
    spacing: 0

    property string text

    Item {
        height: 10
    }

    Label {
        font.pixelSize: theme.defaultFont.pixelSize + 4
        text: parent.text
    }

    Item {
        height: 1
    }
}
