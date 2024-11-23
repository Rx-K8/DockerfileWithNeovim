#!/bin/bash
# -*- coding: utf-8 -*-

: <<EOF_COMMENT
-----------------------------------------------------------
Create docker container with cuda.

Created Date: 2024/01/14: FUKUOKA Keito
Updated Date: 2024/07/17: FUKUOKA Keito
-----------------------------------------------------------
EOF_COMMENT

# nvidia/cuda docker images versions
declare -A CUDA_VERSIONS=(
  ['12.1']='nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04'
  ['11.8']='nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04'
  ['11.7']='nvidia/cuda:11.7.1-cudnn8-devel-ubuntu22.04'
  ['11.6']='nvidia/cuda:11.6.1-cudnn8-devel-ubuntu20.04'
  ['11.5']='nvidia/cuda:11.5.2-cudnn8-devel-ubuntu20.04'
  ['11.4']='nvidia/cuda:11.4.3-cudnn8-devel-ubuntu20.04'
  ['11.3']='nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04'
  ['11.2']='nvidia/cuda:11.2.2-cudnn8-devel-ubuntu20.04'
  ['11.1']='nvidia/cuda:11.1.1-cudnn8-devel-ubuntu20.04'
  ['11.0']='nvidia/cuda:11.0.3-cudnn8-devel-ubuntu20.04'
)

# Command argument analysis
while getopts :-: opt; do
  optarg="${!OPTIND}"
  [[ "$opt" = - ]] && opt="-$OPTARG"
  case "-$opt" in
    --cuda_version)
      cuda_version=$optarg
      shift
      ;;
    --share_dir)
      share_dir=$optarg
      shift
      ;;
    --name)
      container_name=$optarg
      shift
      ;;
    --*)
      echo "ERROR: $0: illegal option -- ${opt##-}" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND - 1))

# Make sure that docker is already installed.
if [ -z $(which docker) ]; then
  echo 'Docker is not installed. Please install Docker.' 1>&2
  exit 1
fi

# Make sure that this script is not run in user directory
if [ "${HOME}" == "${PWD}" ]; then
  echo 'ERROR: This script is not run in user directory.' 1>&2
  exit 1
fi

# Make sure share directory
if [ -z ${share_dir} ]; then
  share_dir=${PWD}
fi
if [[ ! "${share_dir}" =~ ^${HOME}.* ]]; then
  echo "ERROR: share_dir option must be the absolute path." 1>&2
  exit 1
fi

# Make sure container name
if [ -z ${container_name} ]; then
  echo "ERROR: Your option do not have container name." 1>&2
  exit 1
fi

# parameters
base_image=${CUDA_VERSIONS["${cuda_version}"]}
repository_name='miyalab/cuda'
tag_name="${base_image##*:}-keito_custom"
image_name="${repository_name}:${tag_name}"

# Make sure that docker image exists already.
image_exists=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep ${image_name})
if [ -z "${image_exists}" ]; then
  docker build -t ${image_name} --build-arg base_image=${base_image} --no-cache .
fi

mkdir -p "${share_dir}"

docker create -it --name="${container_name}" --gpus=all --ipc=host -v "${share_dir}":/home "${image_name}"
# docker create -it --name="${container_name}" --gpus=all --ipc=host -v "${share_dir}":/share "${image_name}"
exit 0
