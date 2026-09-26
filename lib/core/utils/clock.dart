/// Source of the current time. Injected into repositories so tests can use a
/// fixed time instead of the real clock.
typedef Clock = DateTime Function();
