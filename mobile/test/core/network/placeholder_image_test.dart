import 'package:flutter_test/flutter_test.dart';
import 'package:mentor_stream_flutter/core/network/placeholder_image.dart';

void main() {
  test('empty URL is a placeholder', () {
    expect(isPlaceholderImageUrl(''), isTrue);
  });

  test('example.com URLs are placeholders', () {
    expect(isPlaceholderImageUrl('https://example.com/x.png'), isTrue);
    expect(isPlaceholderImageUrl('http://www.example.com/thumb.jpg'), isTrue);
  });

  test('unparsable URLs are treated as placeholders', () {
    expect(isPlaceholderImageUrl('not a url'), isTrue);
  });

  test('a real, curated thumbnail URL is not a placeholder', () {
    expect(
      isPlaceholderImageUrl('https://cdn.mentorstream.dev/courses/flutter.jpg'),
      isFalse,
    );
  });
}
