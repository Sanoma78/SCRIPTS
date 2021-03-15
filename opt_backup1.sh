#!/bin/bash
  tar --create \
          --file=arechive.2.tar \
          --listed-incremental=/var/log/opt.snar \
           /opt
