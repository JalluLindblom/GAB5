event_inherited();

var prev_text = text;

text = "GAME: " + GM_version + "\nCONFIG: " + Configs.configuration_version + "\nSERVER: " + API.base_url;
if (instance_exists(Trial) && Trial.level.name != undefined) {
    text += "\n" + Trial.level.name;
}

if (text != prev_text) {
    dud_show_text("update");
    scrib = scribble(text)
        .starting_format(FontJosefinSans, COLOR.white)
        .transform(0.65, 0.65, 0)
        .align(fa_left, fa_bottom);
}