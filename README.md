МТС Smart Surf2 4G (дерево устройства)
--------------------------------------

Это дерево - попытка собрать CM14.1 под МТС Smart Surf2 4G. За основу взята разработка oleg.svs - https://github.com/olegsvs/android_device_archos_persimmon , за что ему огромное спасибо. Без этого дерева ничего бы не получилось.

Внимание! Дерево в находится в *режиме разработки*, прошивка с ним на данный момент собирается, но, к сожалению, не запускается.

Замечания
----------

[1] 

Если при сборке у вас появляется ошибка out of memory в jack, то нужно сделать следующее:

export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4096m"
export ANDROID_JACK_VM_ARGS="-Xmx4g -Dfile.encoding=UTF-8 -XX:+TieredCompilation"
В $HOME/.jack-server/config.properties поставить jack.server.max-service=1.

Плюс, я запустил сборку как make -j2 bacon, вместо make -j5 bacon.

[2] Заметки:

- find . -type f -printf "%p\n" - получение списка файлов в директории

[3] Устранение ошибки с Gello:

Идём на https://maven.cyanogenmod.org/ и экспортируем сертификат.

apt-get install ca-certificates (обычно уже есть в системе)
install -m 0644 cyanogenmod.crt /usr/local/share/ca-certificates
update-ca-certificates.
                     
WBR, Decker [ http://www.decker.su ]

Credits
-------

oleg.svs

Полезные ссылки
---------------

- https://github.com/gryber/android_tree_n370b_cm_13/tree/master/doogee/n370b - пример дерева для аппарата на MT6737. Doogee N370B. По идее - это Doogee X5 MAX PRO.
- http://stackoverflow.com/questions/5057394/cyanogenmod-or-aosp-compile-a-single-project - Как собрать отдельное приложение из прошивки.
- http://xda-university.com/as-a-developer/downloadcompile-specific-rom-parts - На ту же тему.
- https://github.com/nE0sIghT/android_device_doogee_x5pro - дерево девайса на mt6735m.