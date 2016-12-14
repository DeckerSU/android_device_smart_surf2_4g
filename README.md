МТС Smart Surf2 4G (дерево устройства)
--------------------------------------

Это дерево - попытка собрать CM14.1 под МТС Smart Surf2 4G. За основу взята разработка oleg.svs - https://github.com/olegsvs/android_device_archos_persimmon , за что ему огромное спасибо. Без этого дерева ничего бы не получилось.

Внимание! Дерево в находится в *режиме разработки*. Прошивка собирается, но перед ее сборкой необходимо применить соответствующие патчи из папки patches и patches_decker, причем часть из них возможно придется применить вручную, т.к. в .sh скрипт для патча я мог забыть что-то дописать. 

Что работает на данный момент?
------------------------------

Предупреждаю, что пока дерево в таком виде с комментариями здесь собрать достаточно сложно, но можно, если понимать о чем идет речь. К сожалению, пока это не тот вариант, чтобы сделать make -j# bacon и сразу же получить результат. Нужны правки исходников CM, применение патчей из дерева плюс ручное редактирование. Т.к. я пока не дозрел как все это нормально оформить.

Итак, работает:

- Дисплей и тач, т.е. прошивка запускается и можно видеть изображение (да, да, этого я тоже долго от нее добивался).
- Звук ... после нескольких суток работы проблемы с audio.primary.mt6737m.so удалось победить.
- Связь! Да, да, ril заработал, правда только после замены mtk-ril.so и mtk-rilmd2.so от другого аппарата на CM.
- Заработали основная и фронтальная камеры, заработал фонарик (пока не работает съемка видео). Также приложение камера пока падает, съемка возможна из меню Галерея -> Камера. 
- Не работают некоторые вещи, зависящие от vendor/lib/libwvm.so.

Рабочие заметки
---------------

[1] Если при сборке у вас появляется ошибка out of memory в jack, то нужно сделать следующее:

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

https://github.com/SlimRoms/frameworks_base/commit/81760e4b9026c3b3153a8e6691494484c7b92897

Либо вот так:

    diff --git a/core/jni/fd_utils-inl-extra.h b/core/jni/fd_utils-inl-extra.h
    index 993c320..3ef2b60 100644
    --- a/core/jni/fd_utils-inl-extra.h
    +++ b/core/jni/fd_utils-inl-extra.h
    @@ -20,6 +20,9 @@
         "/proc/aprf",
     */
     
    +#define PATH_WHITELIST_EXTRA_H \
    +    "/proc/ged",
    +
     // Overload this file in your device specific config if you need
     // to add extra whitelisted paths.
     // WARNING: Only use this if necessary. Custom inits should be


(!!!) По идее этот файл нужно положить в дерево устройства, но я не знаю как это сделать. Ни одного примера дерева с файлом fd_utils-inl-extra.h я не нашел.

[6] Чтобы запустилась связь mtk-ril.so и mtk-rilmd2.so не должны быть со стока, т.к. стоковые используют две функции из libnetutils.so :

- ifc_set_txq_state
- ifc_ccmni_md_cfg

Которых в исходниках CM14.1 просто нет. Решение найдено, mtk-ril.so и mtk-rilmd2.so должны быть взяты от другого аппарата на CM с рабочим радиомодулем. Либо же
надо пересобрать ril из исходников (которых нет). Исходники RIL'а удалось найти только для 6752 здесь - http://4pda.ru/forum/index.php?showtopic=583114&view=findpost&p=50599174 ,
но я пока не понял как их правильно подключить к дереву и попробовать собрать. Поэтому воспользуемся prebuilt версией.

Что не повредит почитать, если все-таки найти исходники ril'а:

- http://source.android.com/source/add-device.html - Understand Build Layers (я пока это понимаю не до конца)
- https://wiki.cyanogenmod.org/w/Doc:_adding_your_own_app - как добавить собственное приложение в сборку (PRODUCT_PACKAGES)

[7] 12-12 03:21:11.029   834   921 E WVMExtractor: Failed to open libwvm.so: dlopen failed: 
cannot locate symbol "_ZN7android16MediaBufferGroupC1Ev" referenced by "/system/vendor/lib/libwvm.so"...

https://d.fuqu.jp/c++filtjs/ -> _ZN7android16MediaBufferGroupC1Ev -> android::MediaBufferGroup::MediaBufferGroup()

frameworks/av/media/libstagefright 

Вот тут http://forum.xda-developers.com/showpost.php?p=69901934&postcount=381 вроде пофиксили такую же ошибку.

Еще можно поискать так:

- https://github.com/search?utf8=%E2%9C%93&q=_ZN7android16MediaBufferGroupC1Ev&type=Code&ref=searchresults
- https://github.com/CypherOS/device_oneplus_bacon/tree/bac8376f86be16145a2b2ffe7b8692674908f9ab/libshims и посмотреть вот сюда (libshim - заглушка)

[8] HAL     : dlopen failed: cannot locate symbol "_ZN7android11AudioSystem24getVoiceUnlockDLInstanceEv" referenced by "/system/lib/hw/audio.primary.mt6737m.so"...

- https://github.com/xen0n/android_device_meizu_arale/issues/2
- https://github.com/xen0n/local_manifests_arale/commit/c0aaada - как подключить android_frameworks_av для mtk в локальный манифест.
- https://github.com/xen0n/android_frameworks_av_mtk/commit/a00acd6#diff-0b40c18c5446aae2e6abded76d87f3b9
- http://pastebin.com/raw/sFdPewqW - здесь _ZN7android11AudioSystem24getVoiceUnlockDLInstanceEv() запихнули прямо в media/libmedia/AudioSystem.cpp, как экспортируемую
- https://github.com/xen0n/android_frameworks_av_mtk/tree/cm-14.0 - *интересная* репа **xen0n** , перепиленные под MTK framework'и и многое другое
- https://github.com/fire855 - еще один интересный репозитарий, в котором есть многое по MTK.

Мой корявый патч для звука есть в 0001-mtk-audio-fix.patch0001-mtk-audio-fix.patch .

Еще audio.primary.mt6737m.so был нужен mrdump, вот откуда я его взял - https://github.com/nofearnohappy/vendor_AOSP/tree/master/mediatek/proprietary . Тоже интересная ссылка,
есть исходники некоторых модулей Mediatek.

[9] **libwvm.so**

- _ZNK7android11MediaSource11ReadOptions9getSeekToEPxPNS1_8SeekModeE -> android::MediaSource::ReadOptions::getSeekTo(long long*android::MediaSource::ReadOptions::SeekMode*)
   Варианты решения: поправлено в патче patches_decker\0002-fix-access-wvm-to-ReadOptions.patch 
- _Z8WV_SetupRP9WVSessionRKSsS3_R13WVCredentials14WVOutputFormatmPv -> WV_Setup(..
- _ZN7android16MediaBufferGroup14acquire_bufferEPPNS_11MediaBufferE -> android::MediaBufferGroup::acquire_buffer(android::MediaBuffer**)
   Варианты решения: для предыдущих версий CM: https://gist.github.com/ishantvivek/ba0ec07f0e8cdf8ca3f2
                                               https://review.cyanogenmod.org/#/c/77502/ add mising MediaBufferGroup::acquire_buffer symbol 
- _ZN7android16MediaBufferGroup14acquire_bufferEPPNS_11MediaBufferEb - android::MediaBufferGroup::acquire_buffer(android::MediaBuffer**bool)
	     
Вообщем все что касается импортируемых функций в libwvm в стоковой прошивке импортировалось из libstagefright, в исходниках CM14.1 все что касается MediaBuffer'а
было убрано из экспорта, и насколько я понял разработчики придерживаются мнения, что эти функции в stagefright в CM не должны быть экспортируемыми, т.е. решение
которое предлагается командой Cyanogen - правьте код, который использует MediaBuffer. В нашем случае пересобрать libwvm мы не можем, т.к. она была взята из стоковой
прошивки, поэтому единственный остающийся доступный вариант - это правка исходников stagefright и добавление всего недостающего в экспорт. Правильно я это сделал
или нет - вопрос пока открытый. Но направление что править и как - есть.

После того как удалось все это поправить выяснилось что:

	WVMExtractor: Failed to open libwvm.so: dlopen failed: cannot locate symbol "EVP_PKEY_new_mac_key" referenced by "/system/lib/libdrmmtkutil.so"...

Суть проблемы - EVP_PKEY_new_mac_key была в external/boringssl в CM13.0, однако в CM14.1 она просто отсутствует. Т.к. был вот такой вот коммит:

https://boringssl-review.googlesource.com/#/c/5120/ с названием Remove EVP_PKEY_HMAC.

Как решить это - я пока не придумал.

https://github.com/CyanogenMod/android_external_boringssl - 1e4884f615b20946411a74e41eb9c6aa65e2d5f3 (вот тут все сломалось)

git reset --hard b668df14e33797d154fa8c56c0cab5fa05b03b94 - откат
		 20e10d33d55155a05c50ff9d0c2f332984a842fd - вернуть все на прежнее место

https://boringssl-review.googlesource.com/#/c/5120/
	
[10] Случайно увидел еще один красивый вариант фикса недостающих экспортов при запуске /system/lib/hw/audio.primary.mt6737m.so (см. п. 8), в решении из 8 и моем патче необходимые экспорты добавляются в libmedia ... а здесь - https://github.com/olegsvs/android_device_cyanogen_mt6735-common/commit/24f4cac2876e583b1e01e186733c15407b129c52 все отстутствующее собирается в libmtk_symbols, которая потом в init'е помешается в LD_PRELOAD. Решение красиво тем, что в подключаемой таким способом библиотеке можно собрать заглушки для любых экспортов.

[11] 

- Сохранение лога build'а: make -j2 bacon 2>&1 | tee device/mts/smart_surf2_4g/build.log
- Выбор версии Java - sudo update-alternatives --config java
                      sudo update-alternatives --config javac

- http://ubuntuhandbook.org/index.php/2015/01/install-openjdk-8-ubuntu-14-04-12-04-lts/
- http://stackoverflow.com/questions/27955851/android-5-0-build-errors-with-java-version-issue

Есть 4 варианта для альтернативы java (предоставляет /usr/bin/java).
    
      Выбор   ПутьПриор Состояние
    ------------------------------------------------------------
      0/usr/lib/jvm/java-8-oracle/jre/bin/java  1081  автоматический режим
      1/usr/lib/jvm/java-7-openjdk-amd64/jre/bin/java   1071  ручной режим
      2/usr/lib/jvm/java-7-oracle/jre/bin/java  1 ручной режим
      3/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java   1081  ручной режим
    * 4/usr/lib/jvm/java-8-oracle/jre/bin/java  1081  ручной режим


[12] Временно убрал из списка файлов:

    # подсветка экрана и т.п.
    
    lib/hw/audio.a2dp.default.so
    lib/hw/audio_policy.stub.so
    lib/hw/lights.mt6737m.so
    lib/hw/radio.fm.mt6737m.so
    lib/hw/remoteir.default.so	

Без этого подсветка экрана не гаснет, не работает авторегулировка яркости и т.п. Верну, когда разберусь с камерой.

[http://4pda.ru/forum/index.php?s=&showtopic=715583&view=findpost&p=56099172](http://4pda.ru/forum/index.php?s=&showtopic=715583&view=findpost&p=56099172) - камера заработала, описание как я это сделал тут.

[13] ...

[14] Работа продолжается ... 

WBR, Decker [ [http://www.decker.su](http://www.decker.su) ]

Credits
-------

oleg.svs


Полезные ссылки
---------------

- https://github.com/gryber/android_tree_n370b_cm_13/tree/master/doogee/n370b - пример дерева для аппарата на MT6737. Doogee N370B. По идее - это Doogee X5 MAX PRO.
- http://stackoverflow.com/questions/5057394/cyanogenmod-or-aosp-compile-a-single-project - Как собрать отдельное приложение из прошивки.
- http://xda-university.com/as-a-developer/downloadcompile-specific-rom-parts - На ту же тему.
- https://github.com/nE0sIghT/android_device_doogee_x5pro - дерево девайса на mt6735m.diff --git a/core/jni/fd_utils-inl.h b/core/jni/fd_utils-inl.h
- http://microsin.net/programming/android/what-is-android-mk.html
