/// Hosts used as scaffolding/dummy image URLs while a course's real
/// thumbnail hasn't been set yet (e.g. `https://example.com/x.png`, the
/// pattern this codebase's own fixtures use as a stand-in).
const _placeholderImageHosts = {'example.com', 'www.example.com'};

/// True when [url] is empty or points at a known dummy host rather than a
/// real, curated image — callers should render a local placeholder instead
/// of attempting to load it over the network.
bool isPlaceholderImageUrl(String url) {
  if (url.isEmpty) return true;

  final host = Uri.tryParse(url)?.host;
  return host == null || host.isEmpty || _placeholderImageHosts.contains(host);
}
