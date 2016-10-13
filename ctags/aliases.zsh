function tag() {
  ctags -R --languages=ruby --exclude=.git . $(bundle list --paths)
}
