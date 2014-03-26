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


Page {
    id: page
    Column {
        id: column
        width: page.width
        spacing: Theme.paddingMedium
        PageHeader {
            id: header
            title: "BMI Guide"
        }

        Label{
            id: bmi
            anchors.top: header.bottom
            anchors.topMargin: 20
            font.bold: true
            text: "What is BMI?"
            color: Theme.secondaryHighlightColor
            anchors.left: parent.left
            anchors.leftMargin: 20
        }

        Text{
            id: description
            anchors.top: bmi.bottom
            anchors.topMargin: 20
            width: parent.width - 10
            color: Theme.primaryColor
            wrapMode: Text.WordWrap
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pixelSize: Theme.fontSizeSmall
            text: "BMI stands for Body Mass Index which is a formula which relates Body Weight to Height. This enables people to determine whether they are at a weight which is healthy for them. This application uses the updated University of Oxford BMI formula developed by Nick Trefethen"
        }

        Label{
            id: meaning
            anchors.top: description.bottom
            anchors.topMargin: 50
            font.bold: true
            text: "What Your BMI Calculation Means:"
            color: Theme.secondaryHighlightColor
            anchors.left: parent.left
            anchors.leftMargin: 20
        }

        Text{
            id: description2
            anchors.top: meaning.bottom
            anchors.topMargin: 20
            width: parent.width - 10
            color: Theme.primaryColor
            anchors.left: parent.left
            anchors.leftMargin: 10
            font.pixelSize: Theme.fontSizeSmall
            text: " Under 18.5* 	Underweight
 18.5* -    25 	Normal Weight
 25      -    30       Overweight
 30      -    40       Obese
 Over       40 	Severely obese"
        }
    }
}





