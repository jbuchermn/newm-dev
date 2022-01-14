#!/usr/bin/env bash
if [ ! -d "./env" ]; then
    mkdir env
    cd env
    ln -s ../newm/newm newm
    ln -s ../newm/newm_panel_basic newm_panel_basic
    ln -s ../pywm/pywm pywm
    cd ..
fi
cd env

pushd ../pywm
rm -rf build
meson build && ninja -C build
popd

pushd pywm
rm ./_pywm.so
ln -s ../build/_pywm.*.so ./_pywm.so

popd
cp ../newm/bin/.start-newm ./start-newm.py
cp ../newm/bin/newm-cmd ./newm-cmd.py
cp ../newm/bin/newm-panel-basic ./newm-panel-basic.py

if [ ! -f "./config.py" ]; then
  cp ~/.config/newm/config.py ./
  chmod +w config.py
fi

cat <<EOF > start.sh
#!/usr/bin/env bash
pushd ../pywm
meson build && ninja -C build
popd

./start-newm.py --debug --config-file ./config.py > ./newm_log 2>&1
EOF
chmod +x start.sh
