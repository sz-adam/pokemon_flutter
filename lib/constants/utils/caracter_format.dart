String formatGenerationName(String name) {
  if (name.isEmpty) return name;

  // kötőjel alapján felosztja a szöveget 
  final parts = name.split('-');

  // első rész formázása kezdő betű nagybetű 
  final firstPart = parts[0];
  final formattedFirstPart = firstPart[0].toUpperCase() + firstPart.substring(1).toLowerCase();

  // kötöjel utáni összes betű nagybetű 
  final formattedRestParts = parts.sublist(1).map((part) {
    return part.toUpperCase();
  }).toList();

  // Csatlakoztatjuk a részeket
  return [formattedFirstPart, ...formattedRestParts].join('-');
}
 // Nagybetűsítés függvény
String capitalize(String name) {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }
