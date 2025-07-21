#!/bin/sh
{
  echo ""
  echo "PUID=$(id -u)"
  echo "PGID=$(id -g)"
} >> .env