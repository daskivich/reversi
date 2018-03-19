#!/bin/bash

export PORT=5103

cd ~/www/reversi
./bin/reversi stop || true
./bin/reversi start
