#!/usr/bin/env bash

kill "$(lsof -t -i:"$1")"
