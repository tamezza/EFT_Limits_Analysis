#!/bin/bash

# define conda environment name
CONDA_ENV_NAME=statistical_analysis

# check if the conda command exists
CONDA_INSTALLED=false
if command -v conda &> /dev/null; then
  CONDA_INSTALLED=true
fi

# check if conda is already installed
if [[ "$CONDA_INSTALLED" = false ]]; then
  printf "No system conda found!\n\n"
  CONDA_INSTALL=$PWD/conda/

  # install miniforge locally if it doesn't already exist
  if [[ ! -d "${CONDA_INSTALL}" ]]; then
    printf -- "--> Installing conda ..\n\n"
    CONDA_REPOSITORY=https://github.com/conda-forge/miniforge/releases/latest/download
    # installation for macOS (including support for M1 MacBooks)
    if [[ $OSTYPE == 'darwin'* ]]; then
      MAC_TYPE="$(uname -m)"
      if [[ $MAC_TYPE == 'arm64' ]]; then 
        CONDA_INSTALLER="Miniforge3-MacOSX-arm64.sh"
      else
        CONDA_INSTALLER="Miniforge3-MacOSX-x86_64.sh"
      fi    
    # installation for linux
    elif [[ $OSTYPE == 'linux'* ]]; then
      CONDA_INSTALLER="Miniforge3-Linux-x86_64.sh"
    # other operating system not supported
    else
      echo "Operating system not supported. Setup not possible."
      return 1 # exit will kill bash after sourcing, use return
    fi
    # install miniforge to local directory
    curl -L -O ${CONDA_REPOSITORY}/${CONDA_INSTALLER}
    bash ${CONDA_INSTALLER} -b -p ${CONDA_INSTALL}
    rm ${CONDA_INSTALLER}
  else
    printf -- "--> Found previous installation of conda, skipping installation\n\n"
  fi

  # activate conda
  printf -- "--> Activating conda\n\n"
  source ${CONDA_INSTALL}/bin/activate
else
  printf "Found system conda, initializing...\n\n"

  CONDA_BASE=$(conda info --base)
  CONDA_SETUP_PATH="${CONDA_BASE}/etc/profile.d/conda.sh"

  if [[ -f "$CONDA_SETUP_PATH" ]]; then
      printf -- "--> Setting up conda with: $CONDA_SETUP_PATH\n\n"
      source "$CONDA_SETUP_PATH"
      if [[ $? -eq 0 ]]; then
          printf -- "--> conda setup completed successfully\n\n"
      else
          printf -- "--> Failed to source $CONDA_SETUP_PATH\n\n"
          return 1
      fi
  elif [[ -f "/etc/profile.d/conda.sh" ]]; then
      printf -- "--> $CONDA_SETUP_PATH not found\n\n"
      printf -- "--> Setting up conda with: /etc/profile.d/conda.sh\n\n"
      source /etc/profile.d/conda.sh
      if [[ $? -eq 0 ]]; then
         printf -- "--> conda setup completed successfully\n\n"
      else
         printf -- "--> Failed to source /etc/profile.d/conda.sh"
         return 1
      fi
  else
      printf -- "--> $CONDA_SETUP_PATH not found\n"
      printf -- "--> /etc/profile.d/conda.sh not found\n"
      printf -- "--> Aborting setup\n\n"
      return 1
  fi
fi

# check if conda environment exists
if ! conda env list | grep -q "^$CONDA_ENV_NAME\s"; then
  # create conda environment
  printf -- "--> conda environment '$CONDA_ENV_NAME' not found\n\n"
  printf -- "--> Creating new conda environment: $CONDA_ENV_NAME\n\n"
  conda env create -f requirements.yaml -n $CONDA_ENV_NAME
  printf -- "--> Activating new conda environment: $CONDA_ENV_NAME\n\n"
  conda activate $CONDA_ENV_NAME
  # always export the framework paths
  export PATH=${CONDA_PREFIX}/bin:$PATH

  # install this package
  printf -- "--> Installing framework as python package\n\n"
  export PYTHONPATH=${PWD}:${PYTHONPATH}
  python -m pip install -e .
else
  # activate conda environment
  printf -- "--> Activating existing conda environment: $CONDA_ENV_NAME\n\n"
  conda activate $CONDA_ENV_NAME
  # always export the framework paths
  printf -- "--> Setting up python path\n\n"
  export PYTHONPATH=${PWD}:${PYTHONPATH}
fi
