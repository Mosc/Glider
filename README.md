# Glider for Hacker News

[![Get it on Google Play][play store badge]][play store]

Glider is an opinionated Hacker News client. Ad-free, open-source, no-nonsense.

- Browse stories, comments and user profiles
- Vote and comment using an existing or new Hacker News account (experimental)
- Collapse comment trees
- No ads, no telemetry
- Automatic theming
- Sensible defaults

<p>
  <img width="206px" src="./promotional/mockup-1.png">
  <img width="206px" src="./promotional/mockup-2.png">
  <img width="206px" src="./promotional/mockup-3.png">
  <img width="206px" src="./promotional/mockup-4.png">
</p>

[play store]: https://play.google.com/store/apps/details?id=nl.viter.glider
[play store badge]: https://play.google.com/intl/en_us/badges/images/badge_new.png

## Development

Glider is built with the latest beta version of Flutter. Code that can be generated is not included in the repository. Generate it by running `build_runner`:

```sh
flutter pub run --no-sound-null-safety build_runner build --delete-conflicting-outputs
```
