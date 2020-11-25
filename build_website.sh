#!/bin/sh

rm -fr _site/*
mkdir _site

cp -r website/* _site

cp CNAME _site

mkdir -p _site/assets
mkdir -p _site/specs

make -C src/b3 html latexpdf
cp -r src/b3/build/html/ _site/specs/b3
cp src/b3/build/latex/wishbone-b3.pdf _site/assets

make -C src/b3.1 html latexpdf
cp -r src/b3.1/build/html/ _site/specs/b3.1
cp src/b3.1/build/latex/wishbone-b3-1.pdf _site/assets
