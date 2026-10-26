# Putting Flash News on the web, like the PrepMate link

The goal: a public URL such as `https://flash-news-flutter.onrender.com` that
shows the app running. Render compiles the Flutter project for you, so you
still don't install anything.

**Time:** about 5 minutes of clicking, then 8–15 minutes of waiting for the
first build.

---

## 1. Put the project on GitHub

In the unzipped project folder:

```bash
git init
git add .
git commit -m "Flash News Flutter app"
```

Make a new **empty** repository on github.com — call it `flash-news-flutter`,
don't add a README or a .gitignore — then copy the two lines GitHub shows you
under "push an existing repository", which look like:

```bash
git remote add origin https://github.com/<your-username>/flash-news-flutter.git
git branch -M main
git push -u origin main
```

## 2. Create the Render site

1. Sign in at [render.com](https://render.com) with your GitHub account.
2. **New** → **Static Site**.
3. Pick the `flash-news-flutter` repository.
4. Fill in exactly:

   | Field | Value |
   |---|---|
   | Name | `flash-news-flutter` (this becomes the URL) |
   | Branch | `main` |
   | Build Command | `bash build.sh` |
   | Publish Directory | `build/web` |

5. **Create Static Site**.

Render now downloads Flutter and builds the app. Watch the log. The first
build is slow because it clones the whole Flutter SDK; later builds reuse it.

When it finishes you get `https://flash-news-flutter.onrender.com`.

> `render.yaml` in the repo already contains these settings, so if Render
> offers to read it, let it — you can skip the form.

---

## 3. What to expect

- **On a phone**, the app fills the screen like a normal app.
- **On a laptop**, it is drawn inside a phone-shaped frame in the middle of
  the window, because a phone app stretched across a desktop browser looks
  broken. That frame only exists on the web build (`lib/widgets/web_shell.dart`,
  guarded by `kIsWeb`); the Android app is untouched.
- Saved articles work — `shared_preferences` uses the browser's localStorage on
  the web, so bookmarks survive a refresh on that browser.
- "Read on publisher site" works — `url_launcher` opens a new tab.
- Render static sites don't sleep, so the link stays fast. (Free *web
  services* sleep after 15 minutes; a static site is not one.)

---

## 4. If the build fails

The build log names the file and the line. This is the first time a compiler
has seen this code, so a small fix is possible. The likely ones:

| Log says | Fix |
|---|---|
| `Target of URI doesn't exist: ...` | A file is missing from the commit. Check `git status`, `git add` it, push again. |
| `The method 'X' isn't defined` | An API moved between Flutter versions. Send me the line and I'll correct it. |
| `Unable to determine Flutter version` | The SDK clone was shallow. `build.sh` already does a full clone, so this shouldn't happen — re-run the deploy. |
| Build times out | Click **Manual Deploy** → **Clear build cache & deploy**, or retry; the SDK clone is the slow part. |

`flutter analyze` runs during the build but is set not to fail it, so style
warnings won't block the deploy — only real compile errors will.

---

## 5. Still want the APK?

The web build doesn't produce one. For an `.apk` you need an Android
toolchain: either install Flutter + Android Studio locally, or open the repo
in GitHub Codespaces and run:

```bash
flutter create . --platforms=android
flutter build apk --release
```

then download `build/app/outputs/flutter-apk/app-release.apk` from the
Codespace.
