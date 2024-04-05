class RemoveAcento{
  String removeAcentos(String input) {
    return input.replaceAll(RegExp(r'[^\w\s]'), '').replaceAll(RegExp(r'[^\x00-\x7F]'), '');
    // final Map<String, String> mapaAcentos = {
    //   'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
    //   'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', 'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
    //   'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', 'ç': 'c', 'ñ': 'n',
    // };
    //
    // return input.replaceAllMapped(
    //     RegExp(r'[áàâãäéèêëíìîïóòôõöúùûüçñ]'),
    //         (match) => mapaAcentos[match.group(0)]!
    // );
  }
}