ARG base_image

FROM ${base_image}

SHELL ["/bin/bash", "-c"]

RUN { \
  echo 'export CUDA_HOME="/usr/local/cuda"'; \
  echo 'export PATH="${CUDA_HOME}/bin:${PATH}"'; \
  echo 'export LD_LIBRARY_PATH="${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}"'; \
  echo 'export CPATH=/usr/local/cuda/include'; \
  echo 'export LANG=ja_JP.UTF-8'; \
  echo "export EDITOR='nvim'"; \
  echo 'export SHELL=/bin/bash'; \
  echo "export export CUDA_VISIBLE_DEVICES='0'"; \
  echo 'export PATH="${PATH}:${HOME}/.local/bin"'; \
  echo '# Load git completion'; \
  echo 'if [ -f "${HOME}/.git-completion.sh" ]; then'; \
  echo '    source "${HOME}/.git-completion.sh"'; \
  echo 'fi'; \
  echo 'if [ -f "${HOME}/.git-prompt.sh" ]; then'; \
  echo '    source "${HOME}/.git-prompt.sh"'; \
  echo 'fi'; \
  echo ''; \
  echo '# Prompt'; \
  echo 'GIT_PS1_SHOWDIRTYSTATE=true'; \
  echo 'GIT_PS1_SHOWUNTRACKEDFILES=true'; \
  echo 'GIT_PS1_SHOWSTASHSTATE=true'; \
  echo 'GIT_PS1_SHOWUPSTREAM=auto'; \
  echo 'PS1='\''[\[\033[32m\]\u@\h\[\033[00m\] \[\033[33m\]\w\[\033[1;36m\]$(__git_ps1 " (%s)")\[\033[00m\]]\n\$ '\'''; \
} >> ${HOME}/.bashrc

RUN apt-get update && apt-get install -y  \
    locales-all \
    language-pack-ja-base \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    liblzma-dev \
    libreadline-dev \
    libbz2-dev \
    libsqlite3-dev \
    libffi-dev \
    libncurses-dev \
    wget \
    curl \
    zip \
    unzip \
    git \
    && apt-get clean

RUN git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf

RUN { \
  echo '. $HOME/.asdf/asdf.sh'; \
  echo '. $HOME/.asdf/completions/asdf.bash'; \
  echo '. $HOME/.asdf/plugins/java/set-java-home.bash'; \
} >> ${HOME}/.bashrc

RUN { \
	source ${HOME}/.asdf/asdf.sh; \
	asdf update; \
	}

RUN { \
  source ${HOME}/.asdf/asdf.sh; \
  asdf plugin-add python; \
  asdf install python 3.10.15; \
  asdf global python 3.10.15; \
  asdf reshim python; \
  pip install -U pip; \
  asdf plugin-add nodejs; \
  asdf install nodejs latest; \
  asdf global nodejs latest; \
  asdf reshim nodejs; \
  asdf plugin-add java https://github.com/halcyon/asdf-java.git; \
  asdf install java oracle-21.0.2; \
  asdf global java oracle-21.0.2; \
  asdf reshim java; \
}

RUN { \
  source ${HOME}/.asdf/asdf.sh; \
  curl -sSL https://install.python-poetry.org | python -; \
}

RUN { \
  curl -o ${HOME}/.git-completion.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash; \
  curl -o ${HOME}/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh; \
}

RUN { \
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*'); \
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"; \
  tar xf lazygit.tar.gz lazygit; \
  install lazygit /usr/local/bin ; \
}

RUN { \
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage; \
  chmod u+x nvim.appimage; \
  ./nvim.appimage --appimage-extract; \
  ./squashfs-root/AppRun --version; \
  mv squashfs-root /; \
  ln -s /squashfs-root/AppRun /usr/bin/nvim; \
  rm nvim.appimage; \
}

RUN { \
  echo "# This is Git's per-user configuration file."; \
  echo '[user]'; \
  echo '        name = Keito Fukuoka'; \
  echo '        email = keito.0o0.kirby@gmail.com'; \
  echo '# Please adapt and uncomment the following lines:'; \
  echo '[init]'; \
  echo '        defaultBranch = main'; \
  echo '[filter "lfs"]'; \
  echo '        clean = git-lfs clean -- %f'; \
  echo '        smudge = git-lfs smudge -- %f'; \
  echo '        process = git-lfs filter-process'; \
  echo '        required = true'; \
  echo '[alias]'; \
  echo '        lol = log --graph --decorate --pretty=oneline --all --abbrev-commit'; \
} >> ${HOME}/.gitconfig
