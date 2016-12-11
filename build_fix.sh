#!/bin/bash
echo
echo Запуск через: source jack_memory_fix.sh , иначе переменные окружения не будут присвоены.
echo
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4096m"
export ANDROID_JACK_VM_ARGS="-Xmx4g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"

sudo install -m 0644 cyanogenmod.org.crt /usr/local/share/ca-certificates
sudo update-ca-certificates