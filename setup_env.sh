#!/usr/bin/env bash
rm -rf env
mkdir env
cd env
ln -s ../newm/newm newm
ln -s ../pywm/pywm pywm

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
./start-newm.py -d > ~/.cache/newm_log 2>&1
EOF
chmod +x start.sh
