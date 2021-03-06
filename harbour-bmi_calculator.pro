# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-bmi_calculator

CONFIG += sailfishapp

SOURCES += src/harbour-bmi_calculator.cpp

OTHER_FILES += qml/harbour-bmi_calculator.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/SecondPage.qml \
    rpm/harbour-bmi_calculator.spec \
    rpm/harbour-bmi_calculator.yaml \
    harbour-bmi_calculator.desktop

