# Colorize Maven Output
color_maven() {
  /usr/local/bin/mvn $* | sed -e 's/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/\033[1;32mTests run: \1\033[0m, Failures: \033[1;31m\2\033[0m, Errors: \033[1;33m\3\033[0m, Skipped: \033[1;34m\4\033[0m/g' \
        -e 's/\(\[WARN\].*\)/\033[1;33m\1\033[0m/g' \
            -e 's/\(\[INFO\].*\)/\033[1;34m\1\033[0m/g' \
                -e 's/\(\[ERROR\].*\)/\033[1;31m\1\033[0m/g'
}
alias mvn=color_maven
