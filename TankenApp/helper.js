.pragma library

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
