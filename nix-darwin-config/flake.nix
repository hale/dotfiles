# ❯ darwin-rebuild switch --flake ~/.dotfiles/nix-darwin-config
{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, stylix }:
  let
    configuration = { pkgs, config, ... }: {

      # Stylix configuration for system-wide theming
      stylix = {
        enable = true;
        
        # Use base16 default-dark theme
        base16Scheme = "${pkgs.base16-schemes}/share/themes/default-dark.yaml";
        
        # Set the Iosevka font you already have
        fonts = {
          monospace = {
            package = pkgs.nerd-fonts.iosevka;
            name = "Iosevka Nerd Font";
          };
          sizes = {
            terminal = 14;
          };
        };
        
      };

fonts.packages = with pkgs; [
  nerd-fonts.iosevka
];

      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;



      # Home Manager configuration
      users.users.philhale = {
        name = "philhale";
        home = "/Users/philhale";
      };
      
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.philhale = { pkgs, ... }: {
          home.stateVersion = "24.05";
          home.username = "philhale";
          home.homeDirectory = "/Users/philhale";
          
          # Packages to install for this user
          home.packages = with pkgs; [
            pure-prompt
            delta  # Git diff pager
            ncurses  # For terminal definitions including alacritty
            gh  # GitHub CLI
            
            # GPG tools
            gnupg
            pinentry_mac  # macOS pinentry for GPG passphrase
            
            # LSP servers for neovim
            nodePackages.typescript-language-server
            pyright
            solargraph  # Ruby LSP
            rust-analyzer
            
            # Other development tools
            ripgrep  # For telescope/fzf searching
            fd  # Better find
            silver-searcher  # ag command for ack.vim
            fzf  # Fuzzy finder with fzf-tmux
            bun  # JavaScript runtime and package manager
            
            # Shell enhancement tools
            tree  # For 't' alias
            coreutils  # For gls and other GNU utils
            grc  # Generic Colouriser for colorizing command output
            universal-ctags  # For ctags/retag aliases
            jq  # JSON processor
            htop  # Interactive process viewer
          ];
          
          # Alacritty configuration
          programs.alacritty = {
            enable = true;
            settings = {
              env = {
                TERM = "xterm-256color";
              };
              cursor = {
                style = "Block";
                unfocused_hollow = true;
              };
              # Font configuration is handled by Stylix
              # but we can override specific settings if needed
            };
          };
          
          # Zsh configuration
          programs.zsh = {
            enable = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            
            prezto = {
              enable = true;
              pmodules = [
                "environment"
                "terminal"
                "editor"
                "history"
                "directory"
                "spectrum"
                "utility"
                "completion"
                "syntax-highlighting"
                "history-substring-search"
                "autosuggestions"
                "prompt"
              ];
              
              autosuggestions.color = "fg=60";  # Use a distinct gray color
              
              prompt.theme = "pure";
            };
            
            shellAliases = {
              # Git aliases
              glg = "git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative master..HEAD";
              glgl = "git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
              gp = "git push";
              gd = "git diff";
              gdc = "git diff --cached";
              gc = "git commit --verbose";
              gca = "git commit --verbose -a";
              gco = "git checkout";
              gb = "git branch";
              g = "git status -sb";
              gu = "git up";
              ga = "git add";
              gaa = "git add --all";
              gri = "git rebase -i";
              grem = "git remote -v";
              gra = "git remote add";
              gf = "git find";
              girc = "git rebase --continue";
              gira = "git rebase --abort";
              gsh = "git show HEAD";
              grh = "git reset HEAD^";
              gml = "git merge --no-ff -";
              remotes = "git remote -v | column -t\t";
              
              # ls aliases (using coreutils gls if available)
              l = "gls -F --color 2>/dev/null || ls -F";
              ls = "gls -lAh --color 2>/dev/null || ls -lAh";
              ll = "gls -l --color 2>/dev/null || ls -l";
              la = "gls -A --color 2>/dev/null || ls -A";
              
              # Tmux aliases
              tm = "tmux -2";
              
              # Editor aliases
              vim = "nvim";
              vi = "nvim";
              
              # Quick exit
              q = "exit";
              ":q" = "exit";
              
              # Tree shortcut
              t = "tree";
              
              # SSH shortcuts
              ft02 = "ssh phale@192.168.1.95";
              
              # Ctags
              retag = "ctags -R --languages=ruby --exclude=.git . $(bundle list --paths)";
              
              # macOS maintenance
              clean-asl = "sudo rm -rfv /private/var/log/asl/*.asl";
              
              # Nix-darwin rebuild
              rebuild = "sudo nix run nix-darwin -- switch --flake ~/.dotfiles/nix-darwin-config";
              
              # Terraform
              tf = "terraform";
              
              # Ruby/Rails Docker aliases
              rc = "docker compose run console bin/rails c";
              dbm = "docker compose run console bin/rails db:migrate";
              dbtp = "docker compose run specs rails db:test:prepare";
              dbms = "docker compose run specs rails db:migrate:status";
              b = "docker compose run console bundle";
              be = "docker compose run console bundle exec";
              
              # Python/Conda aliases
              sa = "source activate";
              sd = "source deactivate";
              ipyn = "ipython notebook";
              cl = "conda env list";
              clex = "conda list --export > exported_packages.txt";
              
              # Public key to clipboard
              pubkey = "more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'";
            };
            
            initContent = ''
              # Pure prompt is installed via nix
              autoload -U promptinit; promptinit
              prompt pure
              
              # Core settings
              export KEYTIMEOUT=1
              export VIRTUAL_ENV_DISABLE_PROMPT=12
              export DISABLE_AUTO_TITLE="true"
              export DEFAULT_USER="$(whoami)"
              
              # Fix terminal definition for Alacritty
              export TERMINFO_DIRS="$TERMINFO_DIRS:$HOME/.nix-profile/share/terminfo:/etc/profiles/per-user/$USER/share/terminfo:/run/current-system/sw/share/terminfo"
              
              # Fix Ruby issues
              unset RUBYOPT
              
              # Ensure autosuggestions use the right color
              export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'
              
              # PATH additions
              export PATH="$HOME/.dotfiles/bin:$PATH"
              export PATH="/usr/local/share/npm/bin:$PATH"
              export PATH="$HOME/node_modules/.bin:$PATH"
              export PATH="$HOME/.yarn/bin:$PATH"
              export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"
              export PATH=".git/safe/../../node_modules/.bin:$PATH"
              export PATH=".git/safe/../../bin:$PATH"
              export PATH="$HOME/Library/Python/3.9/bin:$PATH"
              
              # Tool configurations
              export GIT_TEMPLATE_DIR="$HOME/.dotfiles/git/git_template"
              export FZF_DEFAULT_COMMAND='ag -g ""'
              export GPG_TTY=$(tty)
              export BUNDLE_JOBS=$(sysctl -n hw.ncpu)
              export RUBY_YJIT_ENABLE=1
              export PG_USER=postgres
              
              # Volta
              export VOLTA_HOME="$HOME/.volta"
              export PATH="$VOLTA_HOME/bin:$PATH"
              
              # N (node version manager)
              export N_PREFIX="$HOME/n"
              [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"
              
              # Increase file descriptor limit
              ulimit -n 2048
              
              # Disable zsh autocorrect
              unsetopt correct_all
              
              # Load completion
              autoload -U compinit
              compinit
              
              # Custom functions
              encrypt() { gpg -ao $1.asc -esr philip@pghale.com $1 }
              
              timestamp() {
                date "+%Y-%m-%dT%H:%M:%S"
              }
              
              statc() {
                stat -c '%a %n' *
              }
              
              ismac() {
                if [[ `uname -s` == "Darwin" ]]; then
                  return 0;
                else
                  return 1
                fi
              }
              
              islinux() {
                if [[ `uname -s` == "Linux" ]]; then
                  return 0;
                else
                  return 1
                fi
              }
              
              # Git functions
              grho() {
                git reset --hard origin
                BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
                cmd="git reset --hard origin/$BRANCH_NAME"
                echo $cmd
                echo "Running in 3 seconds..."
                sleep 3
                eval $cmd
              }
              
              stage() {
                BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)
                cmd="git push --force staging $BRANCH_NAME:master"
                echo $cmd
                echo "Running in 3 seconds..."
                sleep 3
                eval $cmd
              }
              
              git-rm() {
                git rebase --onto $1^ $1
              }
              
              # Live git diff with kicker gem
              gdl() {
                kicker -c -e "git diff --color" .
              }
              
              # Database reset function
              dbreset() {
                set -e
                {
                  rake db:drop db:create db:schema:load db:test:prepare
                }
              }
              
              # Setup binstubs
              binstub-setup() {
                mkdir ./.git/safe
              }
              
              # Ctags function
              tag() {
                ctags -R --languages=ruby --exclude=.git . $(bundle list --paths)
              }
              
              # Create conda environment from exported packages
              ccf() {
                conda create -n $1 --file exported_packages.txt
              }
              
              # FZF functions
              # Command repeat history
              fr() {
                print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
              }
              
              # Checkout git branch (including remote branches)
              fco() {
                local branches branch
                branches=$(git branch --all | grep -v HEAD) &&
                branch=$(echo "$branches" |
                         fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
                git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
              }
              
              # Open file with fuzzy finder
              fe() {
                local out file key
                out=$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
                key=$(head -1 <<< "$out")
                file=$(head -2 <<< "$out" | tail -1)
                if [ -n "$file" ]; then
                  [ "$key" = ctrl-o ] && open "$file" || ''${EDITOR:-vim} "$file"
                fi
              }
              
              # SSH to iMac via Back to My Mac
              imac() {
                ssh imac.$(echo show Setup:/Network/BackToMyMac | scutil | sed -n 's/.* : *\(.*\).$/\1/p')
              }
              
              # Trash - move files to trash instead of deleting
              trash() {
                for item in "$@"; do
                  if [ -e "$item" ]; then
                    mv "$item" ~/.Trash/
                    echo "Moved $item to trash"
                  else
                    echo "Error: $item does not exist"
                  fi
                done
              }
              
              # Tat - Attach or create tmux session named the same as current directory
              tat() {
                path_name="$(basename "$PWD" | tr . -)"
                session_name=''${1-$path_name}
                
                not_in_tmux() {
                  [ -z "$TMUX" ]
                }
                
                session_exists() {
                  tmux list-sessions | sed -E 's/:.*$//' | grep -q "^$session_name$"
                }
                
                create_detached_session() {
                  (TMUX=''' tmux new-session -Ad -s "$session_name")
                }
                
                create_if_needed_and_attach() {
                  if not_in_tmux; then
                    tmux new-session -As "$session_name"
                  else
                    if ! session_exists; then
                      create_detached_session
                    fi
                    tmux switch-client -t "$session_name"
                  fi
                }
                
                create_if_needed_and_attach
              }
              
              # Fun text files
              vom() { cat ~/.dotfiles/zsh/vom.txt }
              guy() { cat ~/.dotfiles/zsh/guy.txt }
              
              # GRC colorizer setup
              GRC=$(which grc 2>/dev/null)
              if [ "$TERM" != dumb ] && [ -n "$GRC" ]; then
                alias colourify="$GRC -es --colour=auto"
                alias configure='colourify ./configure'
                alias diff='colourify diff'
                alias make='colourify make'
                alias gcc='colourify gcc'
                alias g++='colourify g++'
                alias as='colourify as'
                alias gas='colourify gas'
                alias ld='colourify ld'
                alias netstat='colourify netstat'
                alias ping='colourify ping'
                alias traceroute='colourify /usr/sbin/traceroute'
              fi
              
              # All shell configs are now managed by nix-darwin
              # No need to source external .zsh files anymore
              
              # FZF
              [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
              
              # Direnv fix for tmux
              if [ -n "$TMUX" ] && [ -n "$DIRENV_DIR" ]; then
                  unset -m "DIRENV_*"
              fi
              eval "$(direnv hook zsh)"
            '';
          };
          
          # Tmux configuration
          programs.tmux = {
            enable = true;
            prefix = "`";
            terminal = "alacritty";
            keyMode = "vi";
            historyLimit = 1000000000;
            escapeTime = 0;
            mouse = true;
            
            extraConfig = ''
              # improve colors
              set-option -sa terminal-features ',alacritty:RGB'
              set-option -ga terminal-features ",alacritty:usstyle"
              set-option -ga terminal-overrides ',alacritty:Tc'
              
              # needed for proper nvim/tmux/base16 colors
              set -ga terminal-overrides ",xterm-256color:Tc"
              
              # load tmux.conf
              bind-key r source-file ~/.tmux.conf \; display-message "~/.tmux.conf reloaded"
              
              # easier splits
              bind-key - split-window -v  -c '#{pane_current_path}'
              bind-key \\ split-window -h  -c '#{pane_current_path}'
              bind c new-window -c "#{pane_current_path}"
              
              # break current pane into another window
              bind-key b break-pane -d
              
              set-option -g status-left-length 50
              
              # soften status bar color from harsh green to light gray
              set -g status-bg '#666666'
              set -g status-fg '#aaaaaa'
              
              # remove administrative debris (session name, hostname, time) in status bar
              set -g status-right ""
              
              # Smart pane switching with awareness of vim splits
              # See: https://github.com/christoomey/vim-tmux-navigator
              is_vim='echo "#{pane_current_command}" | grep -iqE "(^|\/)g?(view|n?vim?x?)(diff)?$"'
              bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
              bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
              bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
              bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"
              bind -n C-\\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"
              
              # resize panes with shift-arrows
              bind -n S-Left resize-pane -L 2
              bind -n S-Right resize-pane -R 2
              bind -n S-Down resize-pane -D 1
              bind -n S-Up resize-pane -U 1
              bind -n C-Left resize-pane -L 10
              bind -n C-Right resize-pane -R 10
              bind -n C-Down resize-pane -D 5
              bind -n C-Up resize-pane -U 5
              
              # vim-like settings for copy mode
              bind-key -T copy-mode-vi v send-keys -X begin-selection
              bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
              unbind-key -T copy-mode-vi Enter
              bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy"
              
              # quick git diff
              unbind d
              bind-key d split-window -h "git diff"
              
              unbind .
              bind-key . split-window -v -c ~/.dotfiles "vim +Files"
              
              bind-key K run-shell 'tmux switch-client -n \; kill-session -t "$(tmux display-message -p "#S")" || tmux kill-session'
              
              # enable mouse scroll, auto enter copy mode when scrolling
              bind -n WheelUpPane copy-mode
            '';
          };
          
          # Git configuration
          programs.git = {
            enable = true;
            userName = "Philip Hale";
            userEmail = "philip@pghale.com";
            signing = {
              key = "BDB4EB14";
              signByDefault = true;
            };
            
            # Global gitignore
            ignores = [
              "tags"
              ".DS_Store"
              ".svn"
              "*~"
              "*.swp"
              "*.rbc"
              ".rake_tasks"
            ];
            
            # Global gitattributes
            attributes = [
              "db/schema.rb merge=railsschema"
            ];
            
            aliases = {
              rank-contributers = "!$ZSH/bin/git-rank-contributers";
              count = "!git shortlog -sn";
              find = "log --pretty=\"format:%Cgreen%H %Cblue%s\" --name-status --grep";
              up = "pull --rebase --autostash";
            };
            
            extraConfig = {
              color = {
                diff = "auto";
                status = "auto";
                branch = "auto";
                ui = true;
              };
              core = {
                editor = "nvim";
                pager = "delta";
              };
              delta = {
                syntax-theme = "base16-256";
                navigate = true;
                light = false;
                side-by-side = false;
                line-numbers = true;
                file-style = "brightwhite box";
                file-decoration-style = "none";
                plus-style = "brightgreen black";
                plus-emph-style = "black green";
                minus-style = "brightred black";
                minus-emph-style = "black red";
                line-numbers-minus-style = "brightred";
                line-numbers-plus-style = "brightgreen";
                line-numbers-left-style = "#3e3e43";
                line-numbers-right-style = "#3e3e43";
                line-numbers-zero-style = "#57575f";
                zero-style = "syntax";
                whitespace-error-style = "black bold";
                blame-code-style = "syntax";
                blame-palette = "#161617 #1b1b1d #2a2a2d #3e3e43";
                merge-conflict-begin-symbol = "~";
                merge-conflict-end-symbol = "~";
                merge-conflict-ours-diff-header-style = "yellow bold";
                merge-conflict-ours-diff-header-decoration-style = "#3e3e43 box";
                merge-conflict-theirs-diff-header-style = "yellow bold";
                merge-conflict-theirs-diff-header-decoration-style = "#3e3e43 box";
              };
              merge = {
                conflictstyle = "diff3";
                "railsschema" = {
                  name = "newer Rails schema version";
                  driver = "ruby -e 'system %(git), %(merge-file), %(--marker-size=%L), %(%A), %(%O), %(%B); b = File.read(%(%A)); b.sub!(/^<+ .*\\nActiveRecord::Schema\\.define.version: (\\d+). do\\n=+\\nActiveRecord::Schema\\.define.version: (\\d+). do\\n>+ .*/) do; %(ActiveRecord::Schema.define(version: #{[$1, $2].max}) do); end; File.open(%(%A), %(w)) {|f| f.write(b)}; exit 1 if b.include?(%(<)*%L)'";
                };
              };
              diff = {
                colorMoved = "default";
              };
              apply = {
                whitespace = "nowarn";
              };
              mergetool = {
                keepBackup = false;
              };
              difftool = {
                prompt = false;
              };
              help = {
                autocorrect = 1;
              };
              push = {
                default = "simple";
              };
              credential = {
                helper = ["cache --timeout=86400" "osxkeychain"];
              };
              commit = {
                gpgsign = true;
              };
              pull = {
                rebase = true;
              };
              rebase = {
                autoStash = true;
              };
              filter.lfs = {
                clean = "git-lfs clean -- %f";
                smudge = "git-lfs smudge -- %f";
                process = "git-lfs filter-process";
                required = true;
              };
              branch = {
                sort = "-committerdate";
              };
              maintenance = {
                repo = "/Users/philhale/oc/opencounter";
              };
              rerere = {
                enabled = true;
                autoUpdate = true;
              };
            };
          };
          
          # Ctags configuration
          home.file.".ctags".text = ''
            --recurse=yes
            --exclude=.git
          '';
          
          # Create vim directories for backup, undo, swap, and views
          home.file.".vim/backup/.keep".text = "";
          home.file.".vim/undo/.keep".text = "";
          home.file.".vim/swap/.keep".text = "";
          home.file.".vim/views/.keep".text = "";
          
          # Direnv configuration  
          programs.direnv = {
            enable = true;
            nix-direnv.enable = true;
            
            config = {
              global = {
                hide_env_diff = true;
              };
            };
            
            stdlib = ''
              # See: https://github.com/direnv/direnv/issues/73
              export_function() {
                  local name=$1
                  local alias_dir=$PWD/.direnv/aliases
                  mkdir -p "$alias_dir"
                  PATH_add "$alias_dir"
                  local target="$alias_dir/$name"
                  if declare -f "$name" >/dev/null; then
                      echo "#!/usr/bin/env bash" > "$target"
                      declare -f "$name" >> "$target" 2>/dev/null
                      echo "$name \$*" >> "$target"
                      chmod +x "$target"
                  fi
              }
            '';
          };
          
          # Custom vim plugins
          home.file.".config/nvim/pack/custom/start/vim-alloy" = {
            source = pkgs.fetchFromGitHub {
              owner = "grafana";
              repo = "vim-alloy";
              rev = "main";
              sha256 = "sha256-9zwaz2/f8xQpTMjdUYjiEYy70826dQFOu+st1avhtkc=";
            };
          };

          home.file.".config/nvim/pack/custom/start/dwm-vim" = {
            source = pkgs.fetchFromGitHub {
              owner = "spolu";
              repo = "dwm.vim";
              rev = "master";
              sha256 = "sha256-9zwaz2/f8xQpTMjdUYjiEYy70826dQFOu+st1avhtkc=";
            };
          };

          # Neovim configuration
          programs.neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            
            plugins = with pkgs.vimPlugins; [
              # Core plugins
              vim-plug
              vim-tmux-navigator
              fzf-vim
              
              # Required for Stylix theming
              mini-nvim
              
              # UI and appearance
              # mini.statusline, mini.icons, mini.git, mini.diff are part of mini-nvim
              vim-indent-guides
              goyo-vim
              undotree
              
              # File and project management
              vim-rooter
              vim-vinegar
              ack-vim
              
              # Git integration
              vim-fugitive
              vim-gh-line
              
              # Text manipulation
              vim-surround
              vim-repeat
              vim-unimpaired
              nerdcommenter
              tabular
              
              # Tmux integration
              vimux
              vim-tmux
              
              # Language support
              vim-ruby
              vim-rails
              vim-javascript
              rust-vim
              rustaceanvim
              vim-terraform
              
              # Testing and development
              
              # Session/position management
              # nvim-lastplace  # Uncomment if you want cursor position restoration
              
              # LSP and completion (neovim)
              nvim-lspconfig
              nvim-cmp
              cmp-nvim-lsp
              cmp-buffer
              cmp-path
              cmp-cmdline
              cmp-vsnip
              vim-vsnip
              
            ];
            
            extraConfig = ''
              " Core settings
              runtime macros/matchit.vim
              set nocompatible
              set shell=/bin/sh
              set regexpengine=2 
              let g:netrw_nobeval = 1
              
              " Terminal colors
              if (has("termguicolors"))
                set termguicolors
              endif
              
              " Mouse support
              set mouse=a
              set mousehide
              
              " Clipboard integration
              set clipboard^=unnamed
              
              " History and navigation
              set history=5000
              set hidden
              set scrolloff=5
              set scrolljump=1
              
              " Search behavior
              set ignorecase
              set smartcase
              set incsearch
              set hlsearch
              set showmatch
              
              " Visual settings
              set list
              set listchars=tab:›\ ,trail:•,extends:#,nbsp:.
              set number
              set norelativenumber
              set showmode
              
              " Formatting
              set nowrap
              set autoindent
              set expandtab
              set shiftwidth=2
              set tabstop=2
              set tw=100
              
              " Performance
              set lazyredraw
              set ttyfast
              
              " Backup and undo settings
              set backup
              set undofile
              set undolevels=1000
              set undoreload=10000
              
              " Split behavior
              set splitright
              set splitbelow
              
              " Folding
              set foldmethod=indent
              set foldlevel=999
              
              " Suppress warnings
              set shortmess+=A
              
              " Other settings
              set nospell
              set laststatus=2
              
              " Rust formatting
              let g:rustfmt_autosave = 1
              
              filetype plugin indent on
              syntax on
              set colorcolumn=0
              highlight clear SignColumn
              highlight clear LineNr
              
              " Theming is handled automatically by Stylix
              
              " FZF settings
              let g:fzf_command_prefix = 'Fzf'
              
              " Mini plugins setup for full experience
              lua << MINI
              require('mini.statusline').setup()
              require('mini.icons').setup()
              require('mini.git').setup()
              require('mini.diff').setup()
              MINI
              
              " Vim rooter
              let g:rooter_patterns = ['.git', 'Makefile', 'package.json', 'Cargo.toml']
              
              " Silver searcher configuration
              if executable('ag')
                set grepprg=ag\ --nogroup\ --nocolor
                let g:ackprg = 'ag --nogroup --nocolor --column --ignore public/ --ignore static/ --ignore node_modules --ignore .git'
              endif
              
              " DWM settings
              let g:dwm_map_keys=0
              let g:dwm_master_pane_width=120
              
              " Rails ctags
              let g:rails_ctags_arguments = ['--languages=ruby', '--extra=f']
              
              " Custom keybindings
              let mapleader = " "
              
              " FZF mappings
              nnoremap <C-p> :FzfFiles<CR>
              noremap <C-P> :Files<CR>
              nnoremap <leader>b :FzfBuffers<CR>
              nnoremap <leader>g :FzfRg<CR>
              
              " Vim config shortcuts
              nnoremap <leader>ev :split $MYVIMRC<CR>
              nnoremap <leader>sv :source $MYVIMRC<CR>
              
              " Search shortcuts
              nmap <leader>F :Ack!<space>
              nmap <leader>f :Ack! <C-r><C-w><cr>
              nmap <silent> <leader>/ :set invhlsearch<CR>
              
              " Quick save and quit shortcuts
              nnoremap <leader>w :wa<CR>
              nnoremap <leader>q :wa<CR>:qa<CR>
              nnoremap <leader>Q :qa!<CR>
              
              " Clear search highlight
              nnoremap <leader>h :noh<CR>
              
              " Visual shifting without exiting Visual mode
              vnoremap < <gv
              vnoremap > >gv
              
              " For when you forget to sudo
              cmap w!! w !sudo tee % >/dev/null
              
              " Window management (DWM style)
              nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
              nnoremap <leader>= :wincmd =<cr>
              map <leader><leader> :call DWM_Focus()<CR>
              
              " DWM shortcuts
              nmap <C-N> <Plug>DWMNew
              nmap <C-C> <Plug>DWMClose
              
              " Easier horizontal scrolling
              map zl zL
              map zh zH
              
              " Rails/Ctags shortcuts
              map <leader>rt :Ctags<CR>
              
              " Find merge conflict markers
              map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>
              
              " Toggle paste mode
              nmap <leader>p :set paste!<CR>
              
              " Yank from cursor to end of line, consistent with C and D
              noremap Y y
              
              " Vimux shortcuts for test running
              map <leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>
              map <leader>vp :VimuxPromptCommand<CR>
              map <leader>vl :VimuxRunLastCommand<CR>
              map <leader>vi :VimuxInspectRunner<CR>
              map <leader>vq :VimuxCloseRunner<CR>
              map <leader>vx :VimuxInterruptRunner<CR>
              map <leader>vz :call VimuxZoomRunner()<CR>
              
              " Vimux slime function and mappings
              function! VimuxSlime()
                call VimuxSendText(@v)
                call VimuxSendKeys("Enter")
              endfunction
              vmap <leader>vs "vy :call VimuxSlime()<CR>
              nmap <leader>vs vip<leader>vs<CR>
              
              " Automatically rebalance windows on vim resize
              autocmd VimResized * :wincmd =
              
              " Git commit message cursor position
              au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
              
              " File type associations
              au BufNewFile,BufRead *.owl set filetype=xml
              au BufNewFile,BufRead *.jess set filetype=lisp
              au BufNewFile,BufRead *.md set filetype=markdown
              
              " Set vim directories (managed by Nix)
              set backupdir=~/.vim/backup//
              set directory=~/.vim/swap//
              set undodir=~/.vim/undo//
              set viewdir=~/.vim/views//
              
              " LSP configuration for Neovim
              lua << EOF
              if vim.fn.has('nvim') == 1 then
                local ok, cmp = pcall(require, 'cmp')
                if ok then
                  cmp.setup({
                  snippet = {
                    expand = function(args)
                      vim.fn["vsnip#anonymous"](args.body)
                    end,
                  },
                  mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                  }),
                  sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'vsnip' },
                  }, {
                    { name = 'buffer' },
                  })
                })
                
                  -- LSP servers
                  local lsp_ok, lspconfig = pcall(require, 'lspconfig')
                  if lsp_ok then
                    local capabilities = require('cmp_nvim_lsp').default_capabilities()
                    
                    -- Ruby
                    lspconfig.solargraph.setup{
                      capabilities = capabilities
                    }
                    
                    -- JavaScript/TypeScript
                    lspconfig.ts_ls.setup{
                      capabilities = capabilities
                    }
                    
                    -- Rust (handled by rustaceanvim)
                    -- Python
                    lspconfig.pyright.setup{
                      capabilities = capabilities
                    }
                  end
                end
              end
              EOF
            '';
          };
          
          # Stylix targets for Home Manager
          stylix.targets.neovim = {
            enable = true;
            plugin = "mini.base16";
          };
          
          # Other Home Manager programs can go here
        };
      };



      # List packages installed in system profile
      environment.systemPackages =
        [
          pkgs.claude-code
          pkgs.alacritty  # Keep in system for /Applications visibility
          pkgs.neovim
        ];
      
      # Set default editor
      environment.variables.EDITOR = "nvim";

      # macOS system settings
      system.primaryUser = "philhale";
      system.defaults = {
        NSGlobalDomain = {
          InitialKeyRepeat = 10;  # normal minimum is 15 (225 ms)
          KeyRepeat = 1;          # normal minimum is 2 (30 ms)
          ApplePressAndHoldEnabled = false;  # Disable press-and-hold for key repeat
        };
        
        finder = {
          FXPreferredViewStyle = "Nlsv";  # List view
          ShowExternalHardDrivesOnDesktop = true;
          ShowRemovableMediaOnDesktop = true;
        };
        
      };
      
      # Swap Caps Lock and Escape keys
      system.keyboard = {
        enableKeyMapping = true;
        remapCapsLockToEscape = true;
      };

      nix.enable = true;

      # Configure Nix settings
      nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        extra-platforms = [ "x86_64-darwin" "x86_64-linux" ];
        trusted-users = [ "@admin" ];
        extra-substituters = [ "https://cache.nixos.org/" ];
        builders-use-substitutes = true;
      };

      # Enable Linux builder
      nix.linux-builder = {
        enable = true;
        ephemeral = true;
        maxJobs = 4;
        config = {
          virtualisation = {
            darwin-builder = {
              diskSize = 40 * 1024;  # Default: 20 * 1024
              memorySize = 8 * 1024; # Default: 3 * 1024
            };
            cores = 6;               # Default: 1
          };
        };
      };

      nix.linux-builder.package = pkgs.darwin.linux-builder;

      # Set Git commit hash for darwin-version
      system.configurationRevision = self.rev or self.dirtyRev or null;

      system.stateVersion = 5;

      # The platform the configuration will be used on
      nixpkgs.hostPlatform = "aarch64-darwin";

      nixpkgs.config.allowUnfree = true;
    };
  in
  {
    darwinConfigurations."Phils-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";  # Explicitly set system architecture
      modules = [ 
        home-manager.darwinModules.home-manager
        stylix.darwinModules.stylix
        configuration 


      ];
    };

    darwinPackages = self.darwinConfigurations."Phils-MacBook-Pro".pkgs;
  };
}
