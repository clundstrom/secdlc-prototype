#!/bin/bash

db(){
    docker rm -f db &> /dev/null || echo "No container found. Nothing removed."

    echo "Building database "
    docker build ./database -t authio-db:dev

    if [[ $1 == '-r' ]]; then
      echo "Starting db in detached mode.."
      docker run --name db -d -t -p "3306:3306" \
        --env-file ./database/db.env \
        authio-db:dev
    fi
}

api(){
    docker rm -f api &> /dev/null || echo "No container found. Nothing removed."

    echo "Building api "
    docker build ./api -t inventory-api:dev

    if [[ $1 == '-r' ]]; then
      echo "Starting api in detached mode.."
      docker run --name api -d -t -p "2022:2022" \
        --env-file ./api/.env \
        inventory-api:dev
    fi
}

if [[ $# -eq 0 ]]; then
    db
    exit 0
fi

if [[ "$1" == '-r' ]]; then
    run='-r'
fi

for i in "$@"; do
  case "$i" in
    "-r")
    ;;
    "db")
      db $run
      ;;
    "api")
      api $run
      ;;
    "all")
      db $run
      api $run
      ;;
    *)
      echo "Usage: $0 [OPTIONAL] {db|{empty}}"
      echo 'Optional: < -r > - Build and run container'
      echo "Example: $0 -r db"
      exit 1
      ;;
  esac
done