function renderLastUpdate(date) {
    var diff = ( (new Date()).getTime() - (new Date(date)).getTime() ) / 1000 / 60 / 60;

    if (diff < 1)
        return "recent";

    if (diff < 24)
        return "last day";

    if (diff < 24 * 7)
        return "last week";

    if (diff < 24 * 7 * 28)
        return "last month";

    return "outdated";
}

function fuelKeyToString(key) {
    if (key=="e5")
        return i18n.tr("Petrol E5");

    if (key=="e10")
        return i18n.tr("Petrol E10");

    if (key=="diesel")
        return i18n.tr("Diesel");

    if (key=="super95")
        return i18n.tr("Super 95");

    if (key=="reg")
        return i18n.tr("Regular Gasoline");

    if (key=="mid")
        return i18n.tr("Mid-Grade Gasoline");

    if (key=="pre")
        return i18n.tr("Premium Gasoline");

    return "";
}

function sortKeyToString(key) {
    if (key=="dist")
        return i18n.tr("distance");

    if (key=="price")
        return i18n.tr("price");

    return "";
}
