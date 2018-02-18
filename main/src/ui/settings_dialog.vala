using Gtk;

namespace Dino.Ui {

[GtkTemplate (ui = "/im/dino/Dino/settings_dialog.ui")]
class SettingsDialog : Dialog {

    [GtkChild] private CheckButton typing_checkbutton;
    [GtkChild] private CheckButton marker_checkbutton;
    [GtkChild] private CheckButton notification_checkbutton;
    [GtkChild] private CheckButton sound_checkbutton;
    [GtkChild] private CheckButton custom_sound_checkbutton;
    [GtkChild] private FileChooserButton custom_sound_file;
    [GtkChild] private CheckButton emoji_checkbutton;

    Dino.Entities.Settings settings = Dino.Application.get_default().settings;

    public SettingsDialog() {
        Object(use_header_bar : 1);

        typing_checkbutton.active = settings.send_typing;
        marker_checkbutton.active = settings.send_marker;
        notification_checkbutton.active = settings.notifications;
        sound_checkbutton.active = settings.sound;
        custom_sound_checkbutton.active = settings.custom_sound;
        custom_sound_file.set_filename(settings.custom_sound_file);
        emoji_checkbutton.active = settings.convert_utf8_smileys;

        typing_checkbutton.toggled.connect(() => { settings.send_typing = typing_checkbutton.active; } );
        marker_checkbutton.toggled.connect(() => { settings.send_marker = marker_checkbutton.active; } );
        notification_checkbutton.toggled.connect(() => { settings.notifications = notification_checkbutton.active; } );
        sound_checkbutton.toggled.connect(() => { settings.sound = sound_checkbutton.active; } );
        custom_sound_checkbutton.toggled.connect(() => { settings.custom_sound = custom_sound_checkbutton.active; } );
        custom_sound_file.file_set.connect(() => { settings.custom_sound_file = custom_sound_file.get_filename(); } );
        emoji_checkbutton.toggled.connect(() => { settings.convert_utf8_smileys = emoji_checkbutton.active; });
    }
}

}
