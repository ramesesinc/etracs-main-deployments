#!/bin/sh
RUN_DIR=`pwd`
cd ..
BASE_DIR=`pwd`

cd $BASE_DIR/appserver/terminal && docker-compose down

cd $BASE_DIR/appserver/terminal && docker-compose up -d

cd $BASE_DIR/appserver/terminal && docker-compose logs -f

cd $RUN_DIR
