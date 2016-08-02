#!/bin/bash


export http_proxy=http://10.0.0.105:3128
docker build -t jenkins_slave .
