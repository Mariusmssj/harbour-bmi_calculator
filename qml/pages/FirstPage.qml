/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0 as Sql

Page {
    id: page

    property real bmi: 0.0
    property real lastBmi: 0.0
    property real scaleBmi: 0.0
    property real feet : 0.0
    property real inch : 0.0
    property real stone : 0.0
    property real pound : 0.0
    property real targetupper : 0.0
    property real targetlower : 0.0

    function fieldNames()
    {
        bmi = 0
        category.text = ""
        range.text = ""
        if(measureType.currentIndex == 0)       // cm/kg
        {
            heightField2.visible = false
            weightField2.visible = false
            heightField.text = ""
            heightField.label = "Enter your height in cm"
            heightField.placeholderText = "Enter your height in cm"
            weightField.text = ""
            weightField.label = "Enter your weight in kg"
            weightField.placeholderText = "Enter your weight in kg"
        }
        else if (measureType.currentIndex == 1) // ft in / lbs
        {
            heightField.text = ""
            heightField.label = "Enter your height in feet"
            heightField.placeholderText = "Enter your height in feet"
            heightField2.text = ""
            heightField2.label = "Enter your height in inches"
            heightField2.placeholderText = "Enter your height in inches"
            weightField.text = ""
            weightField.label = "Enter your weight in pounds"
            weightField.placeholderText = "Enter your weight in pounds"
            heightField2.visible = true
            weightField2.visible = false
        }
        else                                    // ft in / st lbs
        {
            heightField.text = ""
            heightField.label = "Enter your height in feet"
            heightField.placeholderText = "Enter your height in feet"
            heightField2.text = ""
            heightField2.label = "Enter your height in inches"
            heightField2.placeholderText = "Enter your height in inches"
            weightField.text = ""
            weightField.label = "Enter your weight in stone"
            weightField.placeholderText = "Enter your weight in stone"
            weightField2.text =""
            weightField2.label = "Enter your weight in pounds"
            weightField2.placeholderText = "Enter your weight in pounds"
            heightField2.visible = true
            weightField2.visible = true
        }
    }

    function process()
    {
        convert();
        mark.update()
        mark.visible = true
        saveBMI()
        deleteTable()
        saveBMI()
    }

    function calcCategory(cbmi)
    {
        if(cbmi < 18.5)
            category.text = "Underweight"
        if(cbmi >= 18.5 && bmi <= 24.9)
            category.text = "Normal weight"
        if(cbmi >= 25 && bmi <= 29.9)
            category.text = "Overweight"
        if(cbmi > 30)
            category.text = "Obese"
    }

    function convert()
    {
        var cmHeight = 0.0
        var kgWeight = 0.0
        var fixedWeight = weightField.text
        if(fixedWeight.indexOf(",")!== -1)
            fixedWeight = fixedWeight.replace(",",".")

        if(measureType.currentIndex == 0 && fixedWeight !== "" && heightField.text !== "")
        {
            calcBMI(heightField.text, fixedWeight);
            calcUpLow(heightField.text);
        }
        else if(measureType.currentIndex == 1 && fixedWeight !== "" && heightField.text !== "" && heightField2.text !== "")
        {
            feet = heightField.text
            inch = heightField2.text
            pound = fixedWeight

            cmHeight = ((feet * 12) + inch) * 2.54
            kgWeight = pound * 0.453592
            calcBMI(cmHeight, kgWeight);
            calcUpLow(cmHeight);
        }
        else if(measureType.currentIndex == 2 && fixedWeight !== "" && weightField2.text !== "" && heightField.text !== "" && heightField2.text !== "")
        {
            feet = heightField.text
            inch = heightField2.text
            stone = fixedWeight
            pound = weightField2.text

            cmHeight = ((feet * 12) + inch) * 2.54
            kgWeight = ((stone * 14) + pound) * 0.453592
            calcBMI(cmHeight, kgWeight);
            calcUpLow(cmHeight);
        }
        else
        {
            bmi = 0.00
            category.text = ""
        }
    }
    function calcUpLow(height)
    {
        targetupper = 25/1.3*(height/100*height/100*Math.sqrt(height/100.))
        targetlower = 18.5/1.3*(height/100*height/100*Math.sqrt(height/100.))

        if(measureType.currentIndex === 1)
        {
            targetupper = targetupper/0.453592
            targetlower = targetlower/0.453592
            range.text = "Your healthy range is from: " + targetlower.toFixed(0) + " to: " + targetupper.toFixed(0) +" lbs"
        }
        else if(measureType.currentIndex === 2)
        {
            targetupper = (targetupper / 0.453592)*0.071429
            targetlower = (targetlower / 0.453592)*0.071429
            range.text = "Your healthy range is from: " + targetlower.toFixed(1) + " to: " + targetupper.toFixed(1) +" st"
        }
        else
            range.text = "Your healthy range is from: " + targetlower.toFixed(0) + " to: " + targetupper.toFixed(0) +" kgs"
    }

    function calcBMI(cheight, cweight)
    {
        var temp = 0.0
        bmi = 1.3*cweight/(cheight/100*cheight/100*Math.sqrt(cheight/100.))
        calcCategory(bmi)
        temp = bmi
        if(temp < 16)
            temp = 16
        if(temp > 31)
            temp = 31
        scaleBmi = (temp-16)*((page.width-9)-0)/(31-16)
    }

    function getSavedBMI()
    {
        var db = Sql.LocalStorage.openDatabaseSync("UserBMI", "1.0", "Stores last users BMI", 1);

        //create table
        db.transaction(function(tx)
        {
            var query = 'CREATE TABLE IF NOT EXISTS SavedBMI(BMI REAL)';
            tx.executeSql(query);
        });
        return db;
    }

    function cleanDb() {
        var db = Sql.LocalStorage.openDatabaseSync("UserBMI", "1.0", "Stores last users BMI", 1);
        db.transaction(
                    function(tx) {
                        tx.executeSql("DROP TABLE IF EXISTS SavedBMI");}
                    );
    }

    function deleteTable() {
        var db = Sql.LocalStorage.openDatabaseSync("UserBMI", "1.0", "Stores last users BMI", 1);
        db.transaction(
                    function(tx) {
                        tx.executeSql("DELETE FROM SavedBMI");}
                    );
    }

    function saveBMI()
    {
        var db = getSavedBMI();

        db.transaction(function(tx)
        {
            var rs = tx.executeSql("INSERT OR REPLACE INTO SavedBMI VALUES (?)", [bmi]);
            //console.log(rs.rowsAffected)
        });
    }

    function loadBMI()
    {
        var db = getSavedBMI();

        db.transaction(function(tx)
        {
            var rs = tx.executeSql('SELECT * FROM SavedBMI');
            var dbItem = rs.rows.item(0);
            lastBmi = dbItem.BMI
        });
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: "Show BMI Guide"
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
            Label{
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "Your last BMI was: " + lastBmi.toFixed(2)
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingMedium
            Component.onCompleted: loadBMI()
            PageHeader {
                title: "BMI Calculator"
            }

            ComboBox{
                id: measureType
                width: page.width
                label: "Measurement Type: "

                menu: ContextMenu{
                    MenuItem { text: "cm/kg" }
                    MenuItem { text: "ft in/lb"}
                    MenuItem { text: "ft in/st lb"}
                }
                onCurrentIndexChanged: fieldNames()
            }

            TextField {
                id: heightField
                width: page.width
                label: "Enter your height in cm"
                placeholderText: "Enter your height in cm"
                validator: RegExpValidator { regExp: /^[0-9]{1,3}$/ }
                color: errorHighlight? "red" : Theme.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: measureType.currentIndex === 0 ? weightField.focus = true : heightField2.focus = true
            }

            TextField {
                visible: false
                id: heightField2
                width: page.width
                label: "Enter your height in inches"
                placeholderText: "Enter your height in inches"
                validator: RegExpValidator { regExp: /^[0-9]{1,3}$/ }
                color: errorHighlight? "red" : Theme.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked:  weightField.focus = true
            }

            TextField {
                id: weightField
                width: page.width
                label: "Enter your weight in kg"
                placeholderText: "Enter your weight in kg"
                validator: RegExpValidator { regExp: /^(\d{1,3})([\.|,]\d{1,2})?$/}
                color: errorHighlight? "red" : Theme.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: measureType.currentIndex === 0 || measureType.currentIndex === 1 ? "image://theme/icon-m-enter-accept" : "image://theme/icon-m-enter-next"
                EnterKey.onClicked: if(measureType.currentIndex === 0 || measureType.currentIndex === 1)
                                    {
                                        process()
                                        weightField.focus = false
                                    }
                                    else
                                    {
                                        weightField2.focus = true
                                    }
            }

            TextField {
                visible: false
                id: weightField2
                width: page.width
                label: "Enter your weight in lbs"
                placeholderText: "Enter your weight in lbs"
                validator: RegExpValidator { regExp: /^[0-9]{1,3}$/ }
                color: errorHighlight? "red" : Theme.primaryColor
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: { weightField2.focus = false; process()}
            }

            Button{
                id: btncalc
                text: "Calculate BMI"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked:process()
            }

            Label{
                text: "Your BMI: " + bmi.toFixed(2)
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeLarge
                anchors.left: parent.left
                anchors.leftMargin: 30
            }

            Label{
                id: category
                text: ""
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeLarge
                anchors.left: parent.left
                anchors.leftMargin: 30
            }
            Image{
                id: scale
                source: "bmi2.png"

                Image{
                    id: mark
                    visible: false
                    y: -1
                    x: scaleBmi
                    source: "mark.png"
                }
            }
            Label{
                id: range
                text: ""
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                anchors.left: parent.left
                anchors.leftMargin: 30
            }
        }
    }
}


