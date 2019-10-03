#!/usr/bin/env bash

check_venv() {
  if [ -n "${VIRTUAL_ENV}" ]; then
    echo "Please deactivate your current virtual environment by typing deactivate"
    exit 1
  fi
}

check_python_exists() {
  if command -v python3; then
    PYTHON=python3
    return
  fi

  if [ -z ${PYTHON} ]; then
    echo "No usable Python found. Please make sure to have python3 installed"
    exit 1
  fi
}

check_chromium() {
  if ! dpkg -l | grep chromium; then
      echo "Chromium not found."
  fi
}

create_new_venv() {
  if [ -d ".venv" ]; then
    echo ".venv already exists, delete existing .venv? [y/N]"
    read -r REPLY
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      rm -rf .venv
      if ! ${PYTHON} -m venv .venv; then
        echo "Could not create virtual environment"
        exit 1
      fi
    fi
  else
    if ! ${PYTHON} -m venv .venv; then
          echo "Could not create virtual environment"
          exit 1
    fi
  fi
  source .venv/bin/activate
}

install_deps() {
  if ! ${PYTHON} -m pip install -r requirements.txt; then
    echo "Could not install requirements"
    exit 1
  fi
}

check_python_exists

case $* in
install | -i)
  check_chromium
  check_venv
  create_new_venv
  install_deps
  ;;
esac
