import QtQuick 2.7
import QtQuick.Controls 1.4

TextField {
    id: textField
    implicitWidth: Math.max(30, hiddenTextInput.contentWidth + 16)
    horizontalAlignment: TextInput.AlignHCenter

    TextInput {
        id: hiddenTextInput
        visible: false
        text: textField.text
    }
}
