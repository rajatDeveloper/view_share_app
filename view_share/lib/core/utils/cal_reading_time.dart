int calReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;
  final time = (wordCount / 200).ceil();
  return time.ceil();
}
