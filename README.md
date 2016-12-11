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

[4] Сделать revert этого commit'а:

Автор: Dimitry Ivanov <dimitry@google.com>  2016-01-22 00:25:32
Коммитер: Dimitry Ivanov <dimitry@google.com>  2016-01-22 03:43:04
Предок: 05c2f6b3d39ee92eae248e902a5a54fdcc6c696f (Merge "libc: hide __signalfd4 symbol")
Потомок:  a42483baad9a37297e6bbbe02d433ecbde890386 (Merge "Revert "Temporary apply LIBC version to __pthread_gettid"")
Ветка: remotes/github/cm-14.1, remotes/m/cm-14.1
Следует за: android-sdk-adt_r12
Предшествует: 

    Revert "Temporary apply LIBC version to __pthread_gettid"
    
    This reverts commit 0ef1d121b5e4845f4ef3b59ae9a1f99ceb531186.
    
    Bug: http://b/26392296
    Bug: http://b/26391427
    Change-Id: I7bbb555de3a43813e7623ff6ad4e17874d283eca

Т.е. сделать apply LIBC version to __pthread_gettid.

[5] Добавить /proc/ged в FD whitelist в frameworks/base/core/jni/fd_utils-inl.h 

index 84252c0..2888064 100644
--- a/core/jni/fd_utils-inl.h
+++ b/core/jni/fd_utils-inl.h
@@ -58,6 +58,7 @@ static const char* kPathWhitelist[] = {
   "/dev/ion",
   "/dev/dri/renderD129", // Fixes b/31172436
   "/system/framework/org.cyanogenmod.platform-res.apk",
+  "/proc/ged" // [+] Decker
 #ifdef PATH_WHITELIST_EXTRA_H
 PATH_WHITELIST_EXTRA_H
 #endif

WBR, Decker [ http://www.decker.su ]

Credits
-------

oleg.svs

Полезные ссылки
---------------

- https://github.com/gryber/android_tree_n370b_cm_13/tree/master/doogee/n370b - пример дерева для аппарата на MT6737. Doogee N370B. По идее - это Doogee X5 MAX PRO.
- http://stackoverflow.com/questions/5057394/cyanogenmod-or-aosp-compile-a-single-project - Как собрать отдельное приложение из прошивки.
- http://xda-university.com/as-a-developer/downloadcompile-specific-rom-parts - На ту же тему.
- https://github.com/nE0sIghT/android_device_doogee_x5pro - дерево девайса на mt6735m.diff --git a/core/jni/fd_utils-inl.h b/core/jni/fd_utils-inl.h
