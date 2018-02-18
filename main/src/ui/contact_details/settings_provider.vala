using Gtk;

using Dino.Entities;

namespace Dino.Ui.ContactDetails {

public class SettingsProvider : Plugins.ContactDetailsProvider, Object {
    public string id { get { return "chat_settings"; } }

    private StreamInteractor stream_interactor;

    public SettingsProvider(StreamInteractor stream_interactor) {
        this.stream_interactor = stream_interactor;
    }

    public void populate(Conversation conversation, Plugins.ContactDetails contact_details, Plugins.WidgetType type) {
        if (type != Plugins.WidgetType.GTK) return;
        if (conversation.type_ == Conversation.Type.CHAT) {
            ComboBoxText combobox_typing = get_combobox(Dino.Application.get_default().settings.send_typing);
            combobox_typing.active_id = get_setting_id(conversation.send_typing);
            combobox_typing.changed.connect(() => { conversation.send_typing = get_setting(combobox_typing.active_id); } );
            contact_details.add(_("Settings"), _("Send typing notifications"), "", combobox_typing);

            ComboBoxText combobox_marker = get_combobox(Dino.Application.get_default().settings.send_marker);
            contact_details.add(_("Settings"), _("Send message marker"), "", combobox_marker);
            combobox_marker.active_id = get_setting_id(conversation.send_marker);
            combobox_marker.changed.connect(() => { conversation.send_marker = get_setting(combobox_marker.active_id); } );

            ComboBoxText combobox_notifications = get_combobox(Dino.Application.get_default().settings.notifications);
            contact_details.add(_("Settings"), _("Notifications"), "", combobox_notifications);
            combobox_notifications.active_id = get_notify_setting_id(conversation.notify_setting);
            combobox_notifications.changed.connect(() => { conversation.notify_setting = get_notify_setting(combobox_notifications.active_id); } );


            Box box_sound = new Box(Orientation.HORIZONTAL, 0) { visible=true };
            ComboBoxText combobox_sound = new ComboBoxText() { visible=true };
            FileChooserButton file_sound = new FileChooserButton("Choose custom sound", FileChooserAction.OPEN) { visible=(conversation.sound_setting == Conversation.SoundSetting.CUSTOM) };

            combobox_sound.append("default", get_sound_setting_string(Conversation.SoundSetting.DEFAULT, conversation.get_sound_default_setting(stream_interactor)));
            combobox_sound.append("on", get_sound_setting_string(Conversation.SoundSetting.ON));
            combobox_sound.append("off", get_sound_setting_string(Conversation.SoundSetting.OFF));
            combobox_sound.append("custom", get_sound_setting_string(Conversation.SoundSetting.CUSTOM));
            combobox_sound.active_id = get_sound_setting_id(conversation.sound_setting);
            combobox_sound.changed.connect(() => {
                conversation.sound_setting = get_sound_setting(combobox_sound.active_id);
                file_sound.visible = (conversation.sound_setting == Conversation.SoundSetting.CUSTOM);
            } );

            file_sound.set_filename(conversation.sound_file);
            file_sound.file_set.connect(() => { conversation.sound_file = file_sound.get_filename(); } );

            box_sound.pack_start(file_sound, false, false, 0);
            box_sound.pack_start(combobox_sound, false, false, 5);
            contact_details.add(_("Settings"), _("Sound"), "", box_sound);
        } else if (conversation.type_ == Conversation.Type.GROUPCHAT) {
            ComboBoxText combobox = new ComboBoxText() { visible=true };
            combobox.append("default", get_notify_setting_string(Conversation.NotifySetting.DEFAULT, conversation.get_notification_default_setting(stream_interactor)));
            combobox.append("highlight", get_notify_setting_string(Conversation.NotifySetting.HIGHLIGHT));
            combobox.append("on", get_notify_setting_string(Conversation.NotifySetting.ON));
            combobox.append("off", get_notify_setting_string(Conversation.NotifySetting.OFF));
            contact_details.add(_("Local Settings"), _("Notifications"), "", combobox);
            combobox.active_id = get_notify_setting_id(conversation.notify_setting);
            combobox.changed.connect(() => { conversation.notify_setting = get_notify_setting(combobox.active_id); } );
        }
    }

    private Conversation.Setting get_setting(string id) {
        switch (id) {
            case "default":
                return Conversation.Setting.DEFAULT;
            case "on":
                return Conversation.Setting.ON;
            case "off":
                return Conversation.Setting.OFF;
        }
        assert_not_reached();
    }

    private Conversation.NotifySetting get_notify_setting(string id) {
        switch (id) {
            case "default":
                return Conversation.NotifySetting.DEFAULT;
            case "on":
                return Conversation.NotifySetting.ON;
            case "off":
                return Conversation.NotifySetting.OFF;
            case "highlight":
                return Conversation.NotifySetting.HIGHLIGHT;
        }
        assert_not_reached();
    }

    private Conversation.SoundSetting get_sound_setting(string id) {
        switch (id) {
            case "default":
                return Conversation.SoundSetting.DEFAULT;
            case "on":
                return Conversation.SoundSetting.ON;
            case "off":
                return Conversation.SoundSetting.OFF;
            case "custom":
                return Conversation.SoundSetting.CUSTOM;
        }
        assert_not_reached();
    }

    private string get_notify_setting_string(Conversation.NotifySetting setting, Conversation.NotifySetting? default_setting = null) {
        switch (setting) {
            case Conversation.NotifySetting.ON:
                return _("On");
            case Conversation.NotifySetting.OFF:
                return _("Off");
            case Conversation.NotifySetting.HIGHLIGHT:
                return _("Only when mentioned");
            case Conversation.NotifySetting.DEFAULT:
                return _("Default: %s").printf(get_notify_setting_string(default_setting));
        }
        assert_not_reached();
    }

    private string get_sound_setting_string(Conversation.SoundSetting setting, Conversation.SoundSetting? default_setting = null) {
        switch (setting) {
            case Conversation.SoundSetting.ON:
                return _("System sound");
            case Conversation.SoundSetting.OFF:
                return _("No sound");
            case Conversation.SoundSetting.CUSTOM:
                return _("Custom sound");
            case Conversation.SoundSetting.DEFAULT:
                return _("Default: %s").printf(get_sound_setting_string(default_setting));
        }
        assert_not_reached();
    }

    private string get_setting_id(Conversation.Setting setting) {
        switch (setting) {
            case Conversation.Setting.DEFAULT:
                return "default";
            case Conversation.Setting.ON:
                return "on";
            case Conversation.Setting.OFF:
                return "off";
        }
        assert_not_reached();
    }

    private string get_notify_setting_id(Conversation.NotifySetting setting) {
        switch (setting) {
            case Conversation.NotifySetting.DEFAULT:
                return "default";
            case Conversation.NotifySetting.ON:
                return "on";
            case Conversation.NotifySetting.OFF:
                return "off";
            case Conversation.NotifySetting.HIGHLIGHT:
                return "highlight";
        }
        assert_not_reached();
    }

    private string get_sound_setting_id(Conversation.SoundSetting setting) {
        switch (setting) {
            case Conversation.SoundSetting.DEFAULT:
                return "default";
            case Conversation.SoundSetting.ON:
                return "on";
            case Conversation.SoundSetting.OFF:
                return "off";
            case Conversation.SoundSetting.CUSTOM:
                return "custom";
        }
        assert_not_reached();
    }

    private ComboBoxText get_combobox(bool default_val) {
        ComboBoxText combobox = new ComboBoxText();
        combobox = new ComboBoxText() { visible=true };
        string default_setting = default_val ? _("On") : _("Off");
        combobox.append("default", _("Default: %s").printf(default_setting) );
        combobox.append("on", _("On"));
        combobox.append("off", _("Off"));
        return combobox;
    }
}

}
