# Md2Pdf

This script lets you create a nicely formatted document from a markdown
source.

Primarily we created this script to enable us to quickly write markdown
documents for offers for clients without worrying about layout and
formatting and while being able to use a light weight text editor like
vim, emacs, gedit, notepad whatever.

We have added a Dockerfile in case you do not want to install latex.


## Usage

### Without docker

Use md2pdf help or --help to show help for options - should be self documenting

### With docker

Run

```bash
docker run -it --user $(id -u):$(id -g) -v "$(pwd):/md2docs" -v ${HOME}/.md2doc:/home/.md2doc  --entrypoint bash westghost/md2pdf
```

(you'd probably want to put that in a script)

## Recent breaking change

Since januari 2024 we have changed the Dockerfile to use /home has the home directory. This makes it necessary in the docker run command to change

```
-v ${HOME}/.md2doc:/.md2doc
```
to

```
-v ${HOME}/.md2doc:/home/.md2doc
```

reason: the pandoc command could not cope with / as a home directory

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
