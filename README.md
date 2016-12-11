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

[2] Из файла proprietary-files.txt были удалены все ссылки на 64-х битные BLOB'ы, т.к. аппарат все равно 
использует 32-х битную архитектуру. Для создания дерева vendor/mts/smart_surf2_4g подключите аппарат с запущенным
TWRP через ADB и запустите последовательно: extract-files.sh - для копирования проприетарных модулей с 
аппарата, а затем setup-makefiles.sh для построения сборочных скриптов в vendor/mts/smart_surf2_4g.

[3] Q. Звук BT? audio.a2dp.default.so брать со стока или он собирается при сборке прошивки?

[4] При запуске прошивки видимо (!) не монтируются разделы. Из за этого даже при запуске adb shell мы получаем
сообщение о том, что sh не найден, скорее всего потому что раздел /system не был смонтирован при запуске системы.

[5] Версия "синхронизирована" с деревом persimmon 1.0.6 от oleg.svs, т.к. в изначальном варианте были 
существенные ошибки в init скриптах, например в init.rc не подключался генерируемый init.cm.rc и т.п.
Также были внесены другие правки.

[6] В /dev/block/platform/mtk-msdc.0 у нас находятся 11230000.msdc0 и 11240000.msdc1, а в них уже by-name и 
т.п., непосредственно в /dev/block/platform/mtk-msdc.0 никаких нет. Коммит с названием "fix paths" - 
попытка исправить это.

[7] find . -type f -printf "%p\n" - получение списка файлов в директории
                     
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