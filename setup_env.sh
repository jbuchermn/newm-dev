#!/usr/bin/env bash
if [ ! -d "./env" ]; then
    mkdir env
    cd env
    ln -s ../newm/newm newm
    ln -s ../pywm/pywm pywm
    cd ..
fi
cd env

pushd ../pywm
meson build && ninja -C build
popd

pushd pywm
rm ./_pywm.so
ln -s ../build/_pywm.*.so ./_pywm.so

popd
cp ../newm/bin/.start-newm ./start-newm.py

cat <<EOF > start.sh
#!/usr/bin/env bash
if [ ! -f "./config.py" ]; then
  cp ~/.config/newm/config.py ./
  chmod +w config.py
fi
./start-newm.py --debug --config-file ./config.py > ./newm_log 2>&1
EOF
chmod +x start.sh
