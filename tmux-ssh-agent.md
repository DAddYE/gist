## SSH AGENT FORWARD + TMUX

This come from: http://blog.codersbase.com/2012/03/tmux-ssh-agent.html

Add in `~/.ssh/rc` this:

```sh
#!/bin/bash
if test "$SSH_AUTH_SOCK" ; then
    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi
```

Then in `.tmux.conf` this:

```
set -g update-environment "DISPLAY SSH_ASKPASS SSH_AGENT_PID SSH_CONNECTION WINDOWID XAUTHORITY"
set-environment -g 'SSH_AUTH_SOCK' ~/.ssh/ssh_auth_sock
```

That's it
