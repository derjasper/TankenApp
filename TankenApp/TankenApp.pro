TEMPLATE = aux
TARGET = TankenApp

RESOURCES += TankenApp.qrc

QML_FILES += $$files(*.js,true) \
            $$files(*.qml,true)

CONF_FILES +=  TankenApp.apparmor \
               TankenApp.png \
               marker_arrow.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               TankenApp.desktop

#specify where the qml/js files are installed to
qml_files.path = /TankenApp
qml_files.files += *.js *.qml # $${QML_FILES}

#workaround
qml1_files.path = /TankenApp/api
qml1_files.files += api/*.js

#specify where the config files are installed to
config_files.path = /TankenApp
config_files.files += $${CONF_FILES}

#install the desktop file, a translated version is
#automatically created in the build directory
desktop_file.path = /TankenApp
desktop_file.files = $$OUT_PWD/TankenApp.desktop
desktop_file.CONFIG += no_check_exist

INSTALLS+=config_files qml_files qml1_files desktop_file


QT += location

DISTFILES += \
    TankenSettings.qml \
    api/apiindex.js \
    api/geoportalgasolineras.js
