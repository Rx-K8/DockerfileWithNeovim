ARG base_image

FROM ${base_image}

SHELL ["/bin/bash", "-c"]

RUN { \
  echo 'export CUDA_HOME="/usr/local/cuda"'; \
  echo 'export PATH="${CUDA_HOME}/bin:${PATH}"'; \
  echo 'export LD_LIBRARY_PATH="${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}"'; \
  echo 'export CPATH=/usr/local/cuda/include'; \
  echo 'export LANG=ja_JP.UTF-8'; \
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
    vim \
    nano \
    && apt-get clean

RUN git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf

RUN { \
	echo '. $HOME/.asdf/asdf.sh'; \
	echo '. $HOME/.asdf/completions/asdf.bash'; \
	} >> ${HOME}/.bashrc

RUN { \
	source ${HOME}/.asdf/asdf.sh; \
	asdf update; \
	}

RUN { \
    source ${HOME}/.asdf/asdf.sh; \
    asdf plugin-add python; \
    asdf install python 3.11.7; \
    asdf global python 3.11.7; \
    asdf reshim python; \
    pip install -U pip; \
  }
