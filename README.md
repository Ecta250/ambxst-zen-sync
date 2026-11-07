# Zen Browser Sync

Puts your Ambxst theme in Zen Browser. On every theme change, Ambxst writes `~/.cache/ambxst/pywalzen.css`; this mod copies it into a Zen mod named **Ambxst**, which it creates itself. Nothing to install in Zen.

## Install

In **Settings > Mods**, install from `https://github.com/Ecta250/ambxst-zen-sync.git`, enable the mod, then restart Ambxst. Or:

```sh
ambxst mods install https://github.com/Ecta250/ambxst-zen-sync.git
ambxst mods enable ecta250.zen-sync
ambxst reload
```

Requires Zen Browser, `python3`, and Ambxst 1.3.14 or newer.

## Profiles

By default the mod uses the profiles Zen starts with: for each Zen install, the `Default=` line of `profiles.ini`, in `~/.config/zen`, `~/.zen` or the Flatpak folders. To choose others, list their folders in **Settings > Mods > Zen Browser Sync > Zen profiles**, separated by commas.

To stop the colours in one profile, disable the **Ambxst** mod in Zen's settings. If you delete it there instead, it comes back on the next theme change.

## Web pages

With the Zen watcher below, web pages follow the theme as well. Two checkboxes in **Zen settings > Zen Mods > Ambxst** turn them on or off, without restarting:

- **Colour web pages**: text selection, scrollbars, caret and form controls on every site. Sites keep their own styles where they set them.
- **Site themes**: YouTube, GitHub, Wikipedia, Twitch, DuckDuckGo, Instagram, Reddit and X (dark themes: Lights out and Dim).

Site styles live in `payload/scripts/web/`, one file per site, using the `--ambxst-*` variables (each also exists as an `R, G, B` triplet, `--ambxst-*-rgb`). A site is added in `SITES` in `zen_sync.py`, in the site themes label in `MOD_PREFERENCES`, and as an overlay in `ambxst.mod.json`. Rules after a `/* when-dark */` line apply only with a dark theme. Sites change their markup now and then, so a style can need fixing.

## Updating open windows

Zen does not watch its mod files. **Live apply** therefore opens a Zen window for about two seconds, because a new window makes Zen reload its mods everywhere. It is skipped while a window is fullscreen or when no Zen window is open; the colours then arrive with the next Zen window.

### Without a window

`payload/zen/install.sh` adds a small startup script to Zen's install folder. It checks the mod's `chrome.css` every second and reloads Zen's mods when it changes, so no window opens. The script finds the Zen installs on its own (AUR packages, `/opt`, `/usr/lib`, the official tarball in `~/.tarball-installations`):

```sh
sudo sh ~/.local/share/ambxst/mods/packages/ecta250.zen-sync/payload/zen/install.sh
```

Restart Zen afterwards. For the tarball install in your home, run it without `sudo`. Pass a folder (the one containing `zen-bin`) if yours is elsewhere, and `--remove` to uninstall. The Flatpak version is read-only, so it keeps the window method. If a Zen update removes the script, the mod returns to the window method on its own.

Manual run: `python3 scripts/zen_sync.py [--live] [--profile DIR]`
