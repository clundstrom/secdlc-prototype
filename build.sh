#!/bin/bash

frontend(){
    docker rm -f frontend &> /dev/null || echo "No container found. Nothing removed."

    echo "Building frontend "
    docker build ./frontend -t authio-frontend:dev

    if [[ $1 == '-r' ]]; then
      echo "Starting frontend in detached mode.."
      docker run --name frontend -d -p "4200:80" \
        --env-file ./frontend/.env \
        --network authio-net \
        -t authio-frontend:dev
    fi
}

db(){
    docker rm -f db &> /dev/null || echo "No container found. Nothing removed."

    echo "Building database "
    docker build ./database -t authio-db:dev

    if [[ $1 == '-r' ]]; then
      echo "Starting db in detached mode.."
      docker run --name db -d -p "3306:3306" \
        --env-file ./database/db.env \
        --network authio-net \
        -t authio-db:dev
        
    fi
}

api(){
    docker rm -f api &> /dev/null || echo "No container found. Nothing removed."

    echo "Building api "
    docker build ./api -t authio-api:dev

    if [[ $1 == '-r' ]]; then
      echo "Starting api in detached mode.."
      docker run --name api -d -p "2022:2022" \
        --env-file ./api/.env \
        --network authio-net \
        -t authio-api:dev
    fi
}

network_create(){
  docker network create \
        --driver=bridge \
        --subnet=10.1.0.0/16 \
        --ip-range=10.1.0.0/24 \
        --gateway=10.1.0.1 \
        authio-net || true
}

if [[ $# -eq 0 ]]; then
    db
    exit 0
fi

if [[ "$1" == '-r' ]]; then
    run='-r'
    network_create
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
    "frontend")
      frontend $run
      ;;
    "all")
      db $run
      api $run
      ;;
    *)
      echo "Usage: $0 [OPTIONAL] {db|api|frontend|{empty}}"
      echo 'Optional: < -r > - Build and run container'
      echo "Example: $0 -r db"
      exit 1
      ;;
  esac
done