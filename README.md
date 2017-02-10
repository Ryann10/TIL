# Today I Learned

Commit what I learned today with the following rules. [thoughtbot til 참고](https://github.com/thoughtbot/til)

## Basic rules
- Create document with [GFM (Github Flavored Markdown)](https://help.github.com/articles/github-flavored-markdown/). (extension `.md`)
- Folder name should be related with technology or programming language. (Should not create document in root)
- Use only english name when create a new document.

## Use in local
Use [gollum](https://github.com/gollum/gollum), [pow](http://pow.cx/) and [anvil](http://anvilformac.com/).

### Install gollum
```bash
#Prerequisite
$ [sudo] brew install icu4c

$ [sudo] gem install gollum
```

### Install & Uninstall pow
```bash
#Install
$ curl get.pow.cx | sh

#Uninstall
$ curl get.pow.cx/uninstall.sh | sh
```

### How to run

```bash
$ cd path/to/this_local_repo
$ gollum
$ cd ~/.pow
$ ln -s path/to/this_local_repo til.wiki
```

Access [http://til.wiki.dev/](http://til.wiki.dev/) in browser.

### Install Anvil
pow GUI management tool [http://anvilformac.com/](http://anvilformac.com/)
