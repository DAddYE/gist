## DAddYE GIST REPO

Create a repo called `gist` then clone it somewhere (in my case) `/usr/src/extras/gist`, then add in
your `.bash_profile`

```sh
gist(){
  cd /usr/src/extras/gist
  $EDITOR $1
  read -p 'Do you want push changes? (y/n) ' reply
  [[ $reply =~ ^[Yy]$ ]] && git add $1 && git commit -a && git push
  echo
  echo "**************************************************************************"
  echo "Link: https://raw.github.com/DAddYE/gist/master/$1"
  echo "Diff: https://github.com/DAddYE/gist/commit/`git rev-list head | head -n1`"
  echo "**************************************************************************"
  cd - > /dev/null
}
```

If you want to add bash completion of content of your workingdir add in your `.bash_profile`

```sh
__gist_complete(){
  local cur len wrkdir;
  local IFS=$'\n'
  wrkdir="/usr/src/extras/gist/"
  cur=${COMP_WORDS[COMP_CWORD]}
  len=$((${#wrkdir} + 2))
  COMPREPLY=( $(compgen -df $wrkdir/$cur| cut -b $len-) )
}

complete -o nospace -F __gist_complete gist
```

Now you can use `gist [tab][tab]` and will autocomplete with the content of `/usr/src/extras/gist`
(in my case).

## License

DWYW: Do whatever you want!

## Author

Github, Twitter: @DAddYE
Website: http://daddye.it
Email: info[-]daddye.it
