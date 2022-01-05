#!/usr/bin/env bash
rm -rf env
mkdir env
cd env
ln -s ../newm/newm newm
ln -s ../pywm/pywm pywm

pushd pywm
rm ./_pywm.so
ln -s ../build/_pywm.*.so ./_pywm.so

popd
cp ../newm/bin/.start-newm ./start-newm.py
