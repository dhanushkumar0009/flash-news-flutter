# Flash News — Flutter app setup

A complete Flutter Android app: splash, home feed, category filtering, search,
article detail with reading modes, and saved articles. No backend, no API keys,
no account — all data is local.

> **Read this first.** This project was written as source files. It has **not
> been compiled, run, or built into an APK**, because the machine it was written
> on had no Flutter SDK and no network access to install one. Section 5 lists
> exactly what was and was not verified. Follow section 2 and you will see it
> run on your machine in about ten minutes.

---

## 1. What you need installed

| Thing | How to check | If missing |
|---|---|---|
| Flutter SDK 3.19 or newer | `flutter --version` | https://docs.flutter.dev/get-started/install |
| Android Studio (for the emulator / Android SDK) | opens | Install from the same page |
| A device | `flutter devices` | Start an emulator, or plug in a phone with USB debugging on |

Run this once and fix anything it marks with a red ✗:

```bash
flutter doctor
```

Only the **Android toolchain** and **a connected device** need to pass. Ignore
Xcode and Visual Studio warnings.

---

## 2. Getting the app running (do this exactly)

The zip contains the Dart code — `lib/`, `test/`, `pubspec.yaml`. It does **not**
contain the `android/` folder, because those files are generated per machine by
Flutter itself and must match your SDK version. So: make a fresh project, then
drop this code into it.

**Step 1 — make an empty Flutter project**

```bash
cd ~/Desktop
flutter create --org com.flashnews --project-name flash_news flash_news
```

**Step 2 — unzip this archive somewhere else**, e.g. `~/Downloads/flash_news/`.

**Step 3 — replace three things in the new project with the ones from the zip:**

1. Delete the new project's `lib` folder. Copy the zip's `lib` folder in its place.
2. Overwrite the new project's `pubspec.yaml` with the zip's `pubspec.yaml`.
3. Delete the new project's `test` folder and copy the zip's `test` folder in.

(`analysis_options.yaml` and `SETUP.md` can be copied too, but nothing breaks if
you skip them.)

**Step 4 — download the two packages**

```bash
cd ~/Desktop/flash_news
flutter pub get
```

**Step 5 — run it**

```bash
flutter run
```

First build takes 2–5 minutes. After that, press `r` in the terminal to hot
reload after an edit, or `R` to restart.

### To hand in an APK

```bash
flutter build apk --release
```

The file lands at `build/app/outputs/flutter-apk/app-release.apk`.

### If something goes wrong

| Message | Fix |
|---|---|
| `No pubspec.yaml file found` | You are in the wrong folder. `cd` into the project folder. |
| `No devices found` | Start an Android emulator from Android Studio, then re-run. |
| `Because flash_news depends on …` after `pub get` | Run `flutter pub upgrade`, then `flutter pub get` again. |
| Images are grey boxes saying "Image unavailable" | The device has no internet. Expected — the app keeps working; only the photos are missing. |
| Red screen with yellow text | Copy the first line of the error and search it; it names the file and line. |

Internet is used for **one thing only**: loading the article photos from
`picsum.photos`. Everything else works offline.

---

## 3. What's in the project

```
lib/
├── main.dart                     app entry point, theme wiring
├── models/
│   └── article.dart              the Article class + relative time + search matching
├── data/
│   └── sample_articles.dart      24 sample stories, 4 per category
├── services/
│   ├── bookmark_service.dart     saved articles, stored with shared_preferences
│   └── theme_service.dart        light/dark choice, also stored on the device
├── theme/
│   └── app_theme.dart            colours and Material 3 themes (light + dark)
├── widgets/
│   ├── brand_mark.dart           the logo, drawn in code (no image file)
│   ├── article_image.dart        network image with loading + failure states
│   ├── category_chips.dart       the horizontal category filter
│   ├── news_card.dart            the standard list card
│   ├── featured_card.dart        the big card at the top
│   ├── breaking_ticker.dart      the red FLASH banner that auto-scrolls
│   └── state_views.dart          empty view, loading skeleton, section header
└── screens/
    ├── splash_screen.dart        logo + fade, 1.9s, then Home
    ├── home_screen.dart          ticker, search box, chips, featured, latest
    ├── search_screen.dart        live filtering as you type
    ├── article_detail_screen.dart  full story, Short/Standard/Full, share, open link
    └── saved_screen.dart         bookmarked list, swipe to remove
```

### How the features work

**Categories actually filter.** `HomeScreen._visible` keeps the articles whose
`category` equals the selected chip; `'All'` skips the filter. The featured
story and the Latest list are both built from that filtered list, so the whole
screen changes together.

**Search matches four fields.** `Article.matches()` lowercases the query and
checks the title, description, source and category. That is why typing
`reuters` or `sports` returns results even when no headline contains the word.

**Every article shows its own data.** The tapped `Article` object is passed into
`ArticleDetailScreen` through its constructor, so each card opens its own
headline, image, source, date and body text.

**Saving survives closing the app.** `BookmarkService` keeps a `Set<String>` of
article ids in a `ValueNotifier` and writes it to `shared_preferences`. Any
widget wrapped in a `ValueListenableBuilder` rebuilds the instant you tap a
bookmark — which is why the icon on the card, the badge on the app bar, and the
Saved screen all update at once.

**Pull to refresh.** `RefreshIndicator` waits 900 ms, re-sorts the list newest
first and shows a snackbar. There is no server to call, so the delay is there to
make the gesture feel real.

**Dark mode.** `ThemeService` holds a `ThemeMode` in a `ValueNotifier`;
`MaterialApp` listens to it, so one tap on the app bar re-themes every screen.

---

## 4. Viva cheat sheet

Likely questions, and the honest answer with the file to point at.

**Which Flutter concepts does this use?**

| Concept | Where |
|---|---|
| `StatelessWidget` | `NewsCard`, `FeaturedCard`, `SavedScreen` |
| `StatefulWidget` + `setState` | `HomeScreen`, `SearchScreen`, `ArticleDetailScreen` |
| Widget lifecycle (`initState`, `dispose`) | `BreakingTicker`, `SplashScreen` |
| Animation (`AnimationController`, `FadeTransition`) | `SplashScreen` |
| `ValueNotifier` / `ValueListenableBuilder` | both services, used in `NewsCard` |
| Navigation (`push`, `pushReplacement`, `pop`) | `HomeScreen`, `SplashScreen` |
| Passing data between screens | `ArticleDetailScreen(article: article)` |
| `ListView.builder` / `ListView.separated` | `SearchScreen`, `SavedScreen` |
| `RefreshIndicator`, `Dismissible`, `Badge` | `HomeScreen`, `SavedScreen` |
| Local storage | `shared_preferences` in both services |
| Material 3 theming | `app_theme.dart`, `ColorScheme.fromSeed` |
| Async / `Future` / `await` | `main()`, `BookmarkService.toggle` |
| Error handling | `ArticleImage.errorBuilder`, try/catch around storage |

**Why no `setState` for bookmarks?**
Because the bookmark state is needed on three screens at once. A `ValueNotifier`
in a shared service lets each widget listen to the same value, so there is one
source of truth instead of three copies that can disagree.

**Why `dispose()` in `BreakingTicker`?**
It owns a `Timer` and a `PageController`. Without `dispose()` the timer keeps
firing after the widget is gone and Flutter logs a leak.

**Why is the search field on its own screen?**
A `TextField` on the home screen would rebuild the whole feed on every
keystroke. Keeping it on `SearchScreen` means only the results list rebuilds.

**Where does the data come from?**
`lib/data/sample_articles.dart` — 24 hand-written sample stories. The app is
frontend-only by design: no backend, no database, no API key. Timestamps are
built relative to `DateTime.now()` at launch, so "2 hours ago" is always true.

**Is this connected to your website?**
No. The website (React + Express + MongoDB) is a separate project. This app
shares its colours and layout ideas so they look like the same product, but it
makes no network calls to it and has no account system.

**How does Share work?**
`ArticleDetailScreen._share()` copies the headline, summary and link to the
clipboard and confirms with a snackbar. It uses `Clipboard` from
`flutter/services`, so no extra package is needed. "Read on publisher site"
opens the real URL in the phone's browser via `url_launcher`.

---

## 5. What was verified, and what was not

Be able to say this accurately if you are asked.

**Not tested — no Flutter SDK was available on the machine that wrote the code,
and the hosts needed to install one were blocked:**

| Check | Status |
|---|---|
| `flutter pub get` resolves | **Not tested** |
| `flutter analyze` clean | **Not tested** |
| `flutter test` passes | **Not tested** |
| App compiles and launches | **Not tested** |
| APK builds | **Not tested** |
| Behaviour on a real device | **Not tested** |

**Passed — static checks that were actually run over all 18 Dart files:**

| Check | Status |
|---|---|
| Brackets, braces and parentheses balanced in every file | **Passed** |
| Every relative `import` points at a file that exists | **Passed** |
| Every imported package is declared in `pubspec.yaml` | **Passed** |
| Every project class used in a file is declared and imported | **Passed** |
| Both declared packages are actually used | **Passed** |
| Every article id unique, every category in the chip list | **Passed** (by reading the data; the test asserting it was not run) |

So: the code is structurally consistent, but a compiler has not seen it. Budget
time tonight to run `flutter pub get` and `flutter run` once. If the compiler
flags anything, it will be a small fix — a renamed constructor or an API that
moved between Flutter versions — and the error message will name the file and
line.

---

## 6. AI tool disclosure

Claude (Anthropic) was used to write this Flutter application — the project
structure, the sample data, the widgets, the screens and this document. The code
has been read through and every file above can be explained and modified by
hand.
