# Activitat 3 — Formulari B (Flutter Form Builder)

**Autor:** Jan Tchamitchian Garrido

Projecte basat en l’estructura de `ia03_04a_form`, adaptat al funcionament del vídeo `VideoB.mp4`.

## Funcionament

- Capçalera amb el nom **Jan Tchamitchian Garrido**, sense «Salesians Sarrià».
- Tres passos visuals: **Personal**, **Contact**, **Upload**.
- A **Personal**, el botó **CONTINUE** passa a Contact.
- A **Contact**, s’introdueixen email, adreça i telèfon amb `FormBuilderTextField`.
- El botó **CONTINUE** valida les dades i mostra un `AlertDialog` amb el resultat.
- **Upload** permet consultar de nou les dades enviades i tornar al formulari.
- **CANCEL** torna al pas anterior.

## Execució

1. Obre la carpeta del projecte amb VS Code.
2. Executa `flutter pub get`.
3. Executa `flutter run` amb un emulador o dispositiu Android connectat.

Dependència utilitzada: `flutter_form_builder: ^10.2.0`. No cal cap fitxer extern.

## Nota

L’estructura original de Flutter (android, ios, web, windows, linux, macos, test, etc.) es conserva. No s’hi inclouen carpetes temporals de compilació. El projecte no s’ha pogut executar en aquest entorn perquè no disposa de l'SDK de Flutter.
