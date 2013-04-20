## DAddYE GIST REPO

Create a repo called `gist` then clone it somewhere (in my case) `/usr/src/extras/gist`, then add in
your `.bash_profile`

```sh
gist(){
  cd /usr/src/extras/gist
  vim $1
  read -p 'Do you want push changes? (y/n) ' reply
  [[ $reply =~ ^[Yy]$ ]] && git add $1 && git commit -a && git push
  echo "** You can share: https://raw.github.com/DAddYE/gist/master/$1"
  echo "** You can browse diffs: https://github.com/DAddYE/dotfiles/commit/$(git rev-list head | head -n1)"
  cd -
}
```
