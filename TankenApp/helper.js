function renderLastUpdate(date) {
    var diff = ( (new Date()).getTime() - (new Date(date)).getTime() ) / 1000 / 60 / 60;

    if (diff < 1)
        return i18n.tr("recent");

    if (diff < 24)
        return i18n.tr("last day");

    if (diff < 24 * 7)
        return i18n.tr("last week");

    if (diff < 24 * 7 * 28)
        return i18n.tr("last month");

    return i18n.tr("outdated");
}

function fuelKeyToString(api,fuel) {
    if (api == "tankerkoenig") {
        if (fuel=="e5") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Benzin E5 (Fuel E5)");
        }

        if (fuel=="e10") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Benzin E10 (Fuel E5)");
        }

        if (fuel=="diesel") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Diesel");
        }
    }

    if (api == "spritpreisrechner") {
        if (fuel=="diesel") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Diesel");
        }

        if (fuel=="super95") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Super 95 (Fuel 95)");
        }
    }

    if (api == "mygasfeed") {
        if (fuel=="diesel") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Diesel");
        }

        if (fuel=="reg"){
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Regular Gasoline");
        }

        if (fuel=="mid"){
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Mid-Grade Gasoline");
        }

        if (fuel=="pre"){
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Premium Gasoline");
        }
    }

    if (api == "geoportalgasolineras") {
        if (fuel=="gpr") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Gasolina 95 Protección (Unleaded 95)");
        }

        if (fuel=="g98") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Gasolina  98 (Fuel 98)");
        }

        if (fuel=="goa") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Gasoleo A (Diesel)");
        }

        if (fuel=="ngo") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Nuevo Gasoleo A (Diesel+)");
        }

        if (fuel=="bio") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Biodiésel (Biodiesel)");
        }

        if (fuel=="bie") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Bioetanol (Bioethanol)");
        }

        if (fuel=="gnc") {
            // TRANSLATORS: include original name and append translation in brackets if different
            return i18n.tr("Gas Natural Comprimido (Compressed natural gas)");
        }
    }

    if (api == "carburanti") {
      if (fuel == "1-x") {
        return i18n.tr("Benzina");
      }

      if (fuel == "1-0") {
        return i18n.tr("Benzina (Servito)");
      }

      if (fuel == "1-1") {
        return i18n.tr("Benzina (Self)");
      }

      if (fuel == "2-x") {
        return i18n.tr("Gasolio");
      }

      if (fuel == "2-1") {
        return i18n.tr("Gasolio (Self)");
      }

      if (fuel == "2-0") {
        return i18n.tr("Gasolio (Servito)");
      }

      if (fuel == "3-x") {
        return i18n.tr("Metano");
      }

      if (fuel == "4-x" || fuel == '4-0') {
        return i18n.tr("GPL");
      }

      if (fuel == "6-1"){
        return i18n.tr("Hi-Q Diesel (Self)");
      }

      if (fuel == "6-0") {
        return i18n.tr("Hi-Q Diesel (Servito)");
      }

      if (fuel == "6-x") {
        return i18n.tr("Hi-Q Diesel");
      }

      if (fuel == '10-0'){
        return i18n.tr("Gasolio Premium (Servito)");
      }

      if (fuel == "10-1") {
        return i18n.tr("Gasolio Premium (Self)");
      }

      if (fuel == '14-0') {
        return i18n.tr("Excelium Diesel (Servito)");
      }

      if ( fuel == '14-1') {
        return i18n.tr("Excelium Diesel (Self)");
      }

      if ( fuel == "20-0") {
        return i18n.tr("Blue Diesel (Servito)");
      }

      if ( fuel == "20-1") {
        return i18n.tr("Blue Diesel (Self)");
      }

      if (fuel == '28-0') {
        return i18n.tr("HiQ Perform+ (Servito)");
      }

      if (fuel == "28-1") {
        return i18n.tr("HiQ Perform+ (Self)");
      }
    }

    return "";
}

function sortKeyToString(key) {
    if (key=="dist")
        return i18n.tr("By Distance");

    if (key=="price")
        return i18n.tr("By Price");

    return "";
}
