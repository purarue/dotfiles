- generic - generic `bin` directory; may call out to `cross-platform` scripts
- mac - scripts meant to be used on mac
- linux - scripts meant to be used on linux
- cross-platform - scripts that check `$ON_OS`/`uname` to provide cross platform functionality (to interact with the clipboard, or send notifications)
- supervisor_jobs - jobs for supervisor background processes using [supervisor](https://github.com/Supervisor/supervisor), on mac and linux (see below)
- reminder-sink - scripts to remind me to do something, see [reminder-sink](https://github.com/purarue/reminder-sink)

## supervisor

supervisor is what I use to run background processes

Typically one would just use `cron` or a `systemd` service, but nothing ever seems to be cross platform enough for me.

Also, `cron` always feels like a hack when a requirement is syncing my scripts into git -- either you have to specify a full $PATH (so it works on mac), put things not in your $HOME directory, or do some symlinking, and none of those are things I'm a fan of.

supervisord is typically used to respawn processes on servers, but I've had a nice experience with it, so might as well try it here

On Linux, I can spawn this by 'exec'ing at the OS level (i.e. on Arch/i3, i3-exec). On mac, I check if this is running whenever I open a terminal (see [`$ZDOTDIR/mac.zsh`](https://github.com/purarue/dotfiles/blob/master/.config/zsh/mac.zsh))

The [`super`](https://purarue.xyz/d/super?dark) script is the entrypoint to this folder, it uses the [`supervisord.conf`](https://purarue.xyz/d/supervisord.conf?dark) file to determine how to run each of the background processes

See [`bgproc`](https://github.com/purarue/bgproc) and [`on_machine`](https://github.com/purarue/on_machine) for more information

```
$ super --ctl status
active_window                    RUNNING   pid 32014, uptime 0:00:52
bgproc                           RUNNING   pid 32015, uptime 0:00:52
mpv_history_daemon_watcher       RUNNING   pid 32018, uptime 0:00:52
```
