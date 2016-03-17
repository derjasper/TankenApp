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

    if (api == "nrel") {
        /* TODO
BD 	Biodiesel (B20 and above)
CNG 	Compressed Natural Gas
E85 	Ethanol (E85)
ELEC 	Electric
HY 	Hydrogen
LNG 	Liquefied Natural Gas
LPG 	Liquefied Petroleum Gas (Propane)
*/
    }

    return "";
}

function sortKeyToString(key) {
    if (key=="dist")
        return i18n.tr("distance");

    if (key=="price")
        return i18n.tr("price");

    return "";
}
