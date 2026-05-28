# Forza 6 Temp Cleaner

A tiny Windows helper that waits for **Forza Horizon 6** to close, then cleans the current user's `%TEMP%` folder.

It runs in the background, writes a log, and skips files Windows still has locked.

## What It Does

- Watches for `ForzaHorizon6.exe`
- Waits until the game closes
- Deletes files and folders inside your user temp folder
- Leaves the `%TEMP%` folder itself in place
- Skips locked temp files automatically
- Writes cleanup status to `forza6-temp-cleaner.log`

## What It Does Not Do

- Does not modify Forza files
- Does not modify Windows system folders
- Does not require administrator permissions
- Does not spoof hardware, patch the game, or bypass protections

## Files

| File | Purpose |
| --- | --- |
| `start-forza6-temp-cleaner-hidden.vbs` | Main file to double-click. Starts the cleaner hidden in the background. |
| `clean-temp-after-forza.bat` | Worker script that watches Forza and cleans `%TEMP%`. |
| `forza6-temp-cleaner.log` | Created after running. Shows what happened. Not meant to be committed. |

## How To Use

1. Download or clone this folder.
2. Double-click `start-forza6-temp-cleaner-hidden.vbs`.
3. Launch Forza Horizon 6.
4. Play normally.
5. Close Forza Horizon 6.
6. The cleaner runs automatically after the game closes.

You can start the cleaner before or after launching Forza Horizon 6. If the game is not running yet, the cleaner waits silently in the background.

## How To Know It Worked

Open `forza6-temp-cleaner.log` in the same folder.

You should see lines like:

```text
Started hidden watcher for ForzaHorizon6.exe.
Temp folder is C:\Users\YourName\AppData\Local\Temp.
Waiting for ForzaHorizon6.exe to run.
Detected ForzaHorizon6.exe. Waiting for the game to close.
ForzaHorizon6.exe closed. Starting temp cleanup.
Temp items before cleanup: 123
Temp items after cleanup: 8
Cleanup finished. Locked system/app temp files can remain; that is normal.
```

Some temp files may remain. That is normal when Windows or another app is still using them.

## Run Visible For Testing

If you want to test it with a visible terminal, run:

```bat
clean-temp-after-forza.bat --worker
```

## Troubleshooting

If the log stays on `Waiting for ForzaHorizon6.exe to run`, the game's process name may be different on your system.

Check Task Manager while Forza Horizon 6 is running:

1. Open Task Manager.
2. Go to the `Details` tab.
3. Find the Forza process.
4. If the name is not `ForzaHorizon6.exe`, edit this line in `clean-temp-after-forza.bat`:

```bat
set "GAME_EXE=ForzaHorizon6.exe"
```

## Publish To GitHub

Install Git first if `git` is not available in your terminal:

- [Git for Windows](https://git-scm.com/download/win)

Then run these commands in this folder:

```bat
git init
git add README.md LICENSE .gitignore clean-temp-after-forza.bat start-forza6-temp-cleaner-hidden.vbs
git commit -m "Initial Forza 6 temp cleaner"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/forza6-temp-cleaner.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your GitHub username.
