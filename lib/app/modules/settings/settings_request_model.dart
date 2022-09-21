// To parse this JSON data, do
//
//     final settingsResponse = settingsResponseFromJson(jsonString);

import 'package:hito_app/app/modules/settings/settings_model.dart';
import 'dart:convert';


SettingsResponse settingsResponseFromJson(String str) => SettingsResponse.fromJson(json.decode(str));

String settingsResponseToJson(SettingsResponse data) => json.encode(data.toJson());

class SettingsResponse {
    SettingsResponse({
        required this.ok,
        required this.msg,
        required this.parametro,
    });

    bool ok;
    String msg;
    Settings parametro;

    factory SettingsResponse.fromJson(Map<String, dynamic> json) => SettingsResponse(
        ok: json["ok"],
        msg: json["msg"],
        parametro: Settings.fromJson(json["parametro"]),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "parametro": parametro.toJson(),
    };
}
