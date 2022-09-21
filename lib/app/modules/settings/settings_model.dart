
import 'package:hito_app/app/data/models/paises_model.dart';

class Settings {
    Settings({
        required this.precioLocal,
        required this.plusMercosur,
        required this.plusNoMercosur,
        required this.plusFinde,
        required this.descMenores,
        required this.descMayores,
        required this.paises,
        required this.uid,
    });

    int precioLocal;
    int plusMercosur;
    int plusNoMercosur;
    int plusFinde;
    int descMenores;
    int descMayores;
    Paises paises;
    String uid;

    factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        precioLocal: json["precioLocal"],
        plusMercosur: json["plusMercosur"],
        plusNoMercosur: json["plusNoMercosur"],
        plusFinde: json["plusFinde"],
        descMenores: json["descMenores"],
        descMayores: json["descMayores"],
        paises: Paises.fromJson(json["paises"]),
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "precioLocal": precioLocal,
        "plusMercosur": plusMercosur,
        "plusNoMercosur": plusNoMercosur,
        "plusFinde": plusFinde,
        "descMenores": descMenores,
        "descMayores": descMayores,
        "paises": paises.toJson(),
        "uid": uid,
    };
}
