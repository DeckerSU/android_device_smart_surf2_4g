## [ROM][UNOFFICIAL][6.0.1] CyanogenMod 13 for MTC Smart Surf2 4G ## (Decker, [http://www.decker.su](http://www.decker.su))

Сборка для запуска на стоковом ядрке 3.18.19 (!), 32-bit.

Внимание! Это тестовое дерево для сборки CM13.0 для МТС Smart Surf2 4G. Работы над деревом ведутся в данный момент,
поэтому прошивка может не собираться / не запускаться и т.п. 

- https://github.com/Nonta72/android_device_d5110_infinix/tree/cm-13.0 - дерево построено на основе этого CyanogenMod 13 for HOT 2.
- https://forum.xda-developers.com/hot-2/development/rom-cyanogenmod-13-t3442726

Заметки (Decker)
----------------

    ERROR: /home/decker/cm-13.0/frameworks/opt/telephony/../../../device/infinix/d5110/ril/telephony/java/com/android/internal/telephony/MediaTekRIL.java:299: Operators cannot be resolved to a type
    ERROR: /home/decker/cm-13.0/frameworks/opt/telephony/../../../device/infinix/d5110/ril/telephony/java/com/android/internal/telephony/MediaTekRIL.java:299: Operators cannot be resolved to a type
    ERROR: /home/decker/cm-13.0/frameworks/opt/telephony/../../../device/infinix/d5110/ril/telephony/java/com/android/internal/telephony/MediaTekRIL.java:828: Operators cannot be resolved to a type
    ERROR: /home/decker/cm-13.0/frameworks/opt/telephony/../../../device/infinix/d5110/ril/telephony/java/com/android/internal/telephony/MediaTekRIL.java:828: Operators cannot be resolved to a type

device/infinix/d5110/ril/telephony/java/com/android/internal/telephony/MediaTekRIL.java.bak 

                if (strings[i] != null && (strings[i].equals("") || strings[i].equals(strings[i+2]))) {
    [!]		Operators init = new Operators ();
    		String temp = init.unOptimizedOperatorReplace(strings[i+2]);
    		riljLog("lookup RIL responseOperatorInfos() " + strings[i+2] + " gave " + temp);
                    strings[i] = temp;
                    strings[i+1] = temp;
                }


MediaTekRIL.java и gps.h временно убраны из дерева (добавлено расширение .bak) чтобы убрать проблемы при сборке.
Отсутствующий Operators.java необходимый для сборки MediaTekRIL.java можно посмотреть здесь:
https://github.com/SeriniTY320/android_device_THL4000-cm-13.0/blob/master/ril/telephony/java/com/android/internal/telephony/Operators.java

libmtkplayer необходимый для FM Radio пока отключен в Vendor'е.

При сборке применен патч /home/decker/cm-13.0/external/sepolicy для поддержки POLICYVERS := 29, содержимое
/home/decker/cm-13.0/external/sepolicy которое использовалось при сборке есть в архиве external_sepolicy.tar

Что работает, что не работает
-----------------------------

[1] На данный момент работает запуск прошивки и отображение графики. Все остальное можно сказать не работает, т.е.
*не работает*:

WiFi, RIL, звук, камера и т.п.

Надо смотреть что сделано в дереве от CM14 и пробовать перенести изменения сюда.

Лог: 

logcat2.txt:




    01-04 09:08:52.925   294   294 I MtkAgpsNative: [CDMA mgr] cdma_mgr_dlopen_firmware 
    01-04 09:08:52.925   294   294 E MtkAgpsNative: [CDMA mgr] VIAMTKDBG Could not open /system/lib/libviagpsrpc.so, error: dlopen failed: library "/system/lib/libviagpsrpc.so" not found
    01-04 09:08:52.925   294   294 D agps    : [agps] WARNING: [MAIN] cdma_mgr_dlopen_firmware failed
    01-04 09:08:59.948   284   284 E HAL     : dlopen failed: cannot locate symbol "_ZN7android11AudioSystem24getVoiceUnlockDLInstanceEv" referenced by "/system/lib/hw/audio.primary.mt6737m.so"...
    01-04 09:09:07.498   284   284 E MtkOmxCore: dlopen failed, dlopen failed: library "libMtkOmxWmaDec.so" not found
    01-04 09:09:07.499   284   284 E MtkOmxCore: dlopen failed, dlopen failed: library "libMtkOmxWmaProDec.so" not found
    01-04 09:09:07.566   284   284 D MtkOmxVdecEx: [0xb0822000] ClearMotion is not enabled. dlopen failed: library "/system/lib/libClearMotionFW.so" not found

[2] С последним коммиторм на момент 1/21/2017 6:59:06 PM  в данной прошивке уже работают WiFi, звук, камера (съемка фото, съемка видео пока не работает из-за проблем с кодеками, но причина тут уже другая, не та которая в дереве от CM14.1, т.е. здесь данная проблема наверняка решится быстрее ... с xml медиакодеков от CM14.1 поведение камеры при записи видео было точно такое же, как и в CM14.1, т.е. после 1-й секунды записи был звук остановки видео, здесь же после [этого коммита](https://github.com/DeckerSU/android_device_smart_surf2_4g/commit/9d90dd6ea64804119cf179bf0d91dbc12d496449) уже другая ситуация, после двух секунд записи падает камера ... и эту проблему уже вроде бы решали, пока нет времени окончательно разобраться), также работает GPS и запись с экрана. Но пока не удалось завести RIL ... Т.е. "Прошивка модуля связи" **неизвестно**. 

В данный момент идет работа над запуском RIL'а.

[3] RIL:

lib
---

	libmal.so
	libmdfx.so
	librilmtk.so
	librilmtkmd2.so
	mtk-ril.so
	mtk-rilmd2.so

bin
---

	gsm0710muxd
	gsm0710muxdmd2
	mtkrild
	mtkrildmd2

**divis1969**: Если вы можете собирать и анализировать логи, то последовательность запуска телефонии на mt6735 примерно такая:

- Стартует ccci_mdinit, его задача - загрузить в модем фирмваре
- После него стартует gsm0710muxd, он подготавливает несколько последовательных каналов (tty) для работы с модемом
- Потом стартует ril-daemon-mtk, он как раз и пользуется этими каналами, а сам создает сокеты для Java RIL
- Стартует Java RIL и подключается к сокетам. В логе можно искать по тегу RILJ

https://habrahabr.ru/post/183984/

[4] FIX RIL:

BIN

	gsm0710muxd
	gsm0710muxdmd2
	mtkrild
	mtkrildmd2

ETC

	firmware (folder)
	mddb (folder)
	apns-conf.xml
	spn-conf.xml
	trustzone.bin
	LIB & LIB64
	libc2kril.so
	libc2kutils.so
	libreference-ril.so
	libril.so
	librilmtk.so
	librilmtkmd2.so
	librilutils.so
	libviatelecom-withuim-ril.so
	mtk-ril.so
	mtk-rilmd2.so
	volte_imsm.so

Да, на всякий случай help по logcat'у. Чтобы снять полные логи RIL, надо указывать buffer либо radio, либо all. Не забывайте про это. Лучше всегда делать all, т.к. если важная строчка лога будет записано в другой буфер, а вы запустите logcat без -b all вы ее просто не увидите.

	# logcat --help
	...
	  -b <buffer>     Request alternate ring buffer, 'main', 'system', 'radio',
	                  'events', 'crash' or 'all'. Multiple -b parameters are
	                  allowed and results are interleaved. The default is
	                  -b main -b system -b crash.
	...

Короче для радио, так, либо просто all: 

	logcat -b radio (!)
	logcat -b all (!)

Файлы относящиеся к RIL пока берутся из вендора, но могут быть и скомпиленными из исходников, для этого
достаточно раскомментировать:

	#PRODUCT_PACKAGES += \
	#    gsm0710muxd \
	#    gsm0710muxdmd2 \
	#    mtkrild \
	#    mtkrildmd2 \
	#    mtk-ril \
	#    mtk-rilmd2

Сейчас я выключил их сборку.

[5] Удалось достичь некоторых успехов. С применным патчем 0002-xen0n-some-MTK-services-e.g.-ril-daemon-mtk-require-.patch
(правда пока непонятно, с blob'ами со стока или собранными из исходников) ril-daemon запустился, /dev/socket/rild
создался и Baseband Firmware и IMEI отобразился. Направление верное, т.е. одна из проблем была в нехватке переменных
окружения под названия сокетов создаваемых ril-daemon-mtk ...

[6] При изменении конфигурации, например, языковых пакетов делается make installclean ... Просто напоминалка.

Полезные ссылки
---------------

Деревья для сборки CM13:

- https://github.com/ferhung-mtk/android_device_Xiaomi_HM2014011 - 6582
- https://github.com/Nonta72/android_device_d5110_infinix/tree/cm-13.0 - 6580 (3.18.19)
- https://github.com/jsharma44/android_device_GIONEE_WBL7511
- https://github.com/SeriniTY320/android_device_THL4000-cm-13.0
- https://github.com/CyanogenMod/android_device_cyanogen_mt6735-common - android_device_cyanogen_mt6735-common
- https://github.com/Lucky76/android_device_ulefone_metal (MT6753, 64-bit)
- https://github.com/Mohancm/device_A7010a48 (MT6763, 64-bit)

В последнем дереве зачем-то сделан "интересный хак":

	#service ril-daemon /system/bin/rild
	service ril-daemon /system/bin/mtkrild

См. тут - https://github.com/Mohancm/device_A7010a48/blob/acbb4490d52f068f9950057a76cf936230544ca7/rootdir/etc/init.rc

Статьи:

- https://forum.xda-developers.com/k3-note/orig-development/rom-custom-nougat-roms-k-3-note-t3513466
- https://habrahabr.ru/post/183984/ (Слой радиоинтерфейса в ОС Android)

На тему решения проблемы с записью видео в камере:

- https://github.com/fire855/android_frameworks_av-mtk/commits/cm-13.0-mt6592
- https://github.com/nofearnohappy/device_hermes_cm13/blob/master/patches/frameworks/av/codec_and_audio.patch
- https://github.com/xen0n/android_device_meizu_arale/issues/17
- https://forum.xda-developers.com/k3-note/orig-development/rom-custom-nougat-roms-k-3-note-t3513466 (!!!)
- http://4pda.ru/forum/index.php?s=&showtopic=715583&view=findpost&p=57481976

Создал также отдельный репозитарий с описанием проблемы и полными логами:

https://github.com/DeckerSU/video_recording_problem_cm13/


[7] Уррра ... удалось завести запись видео с google.h264.encoder, однако пока что перепутаны цвета Red и Blue на
записи, т.е. красные объекты выглядят синими, а синие выглядят красными. Решаем эту проблему.

https://github.com/xen0n/android_device_meizu_arale/issues/17#issuecomment-274554382

***

Я пошел по другому пути. Т.е. есть два варианта как записывать видео:

1. Использовать софтовый google.h264.encoder из CM.
2. Использовать OMX.MTK.VIDEO.ENCODER.AVC.

Разбираться нужно последовательно, почему не работает в том и в другом случае. Я начал с варианта с google.h264.encoder. Медленно, но верно (весь сегодняшний вечер занимаюсь) я все-таки поднял (ура, ура, ура) съемку видео софтовым кодеком. Все снимает, ничего не крашится, но есть другая проблема. Color conversion, на записи перепутаны местами Red и Blue цвета. Т.е. например красный объект на записи будет выглядеть как синий, а синий, как красный )) Но эту проблему я знаю как решить, вернее знаю направление.

Когда решу ее, вторым шагом будет запуск OMX.MTK.VIDEO.ENCODER.AVC для кодирования видео. Я уже потихоньку начал понимать смысл вопроса. 

Вообщем сейчас у меня видео уже снимается, но с перепутанными цветами. Так что первый шаг сделан.

***

Это софтовый google.h264.encoder :

SoftOMXPlugin.cpp

    { "OMX.google.h264.encoder", "avcenc", "video_encoder.avc" },

libstagefright_soft_avcenc.so

А это хардверный MTK'шный:
	
	01-24 02:33:46.132   845   955 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.AVC), role(video_decoder.avc), path(libMtkOmxVdecEx.so)
	01-24 02:33:46.132   845   955 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.AVC.secure), role(video_decoder.avc), path(libMtkOmxVdecEx.so)

При записи видео, например, через screenrecord используется:

SoftVideoEncoderOMXComponent.cpp
SoftVideoEncoderOMXComponent::ConvertRGB32ToPlanar

И вот там как раз если включим:

	#ifdef SURFACE_IS_BGR32
	    bgr = !bgr;
	#endif

То цвета в screenrecord'е на записи изменятся с RGB на BGR. Но (!) при использовании OMX.google.h264.encoder
при записи с камеры ConvertRGB32ToPlanar не вызывается (!), только при screenrecord'е. Запись же с камеры при
использовании OMX.google.h264.encoder сразу использует libstagefright_soft_avcenc.so. Т.е.

frameworks/av/media/libstagefright/codecs/avcenc/SoftAVCEnc.cpp .

Однако, при записи видео и кодировании google.h264.encoder (libstagefright_soft_avcenc.so) инициализируется
ColorConverter:

frameworks/av/media/libstagefright/colorconversion/ColorConverter.cpp 


	ColorConverter::ColorConverter(
	        OMX_COLOR_FORMATTYPE from, OMX_COLOR_FORMATTYPE to)
	    : mSrcFormat(from),
	      mDstFormat(to),
	      mClip(NULL) {

ALOGE("[Decker] ColorConverter::ColorConverter: %#x --> %#x", from, to);

}

со следующими параметрами:

ColorConverter: [Decker] ColorConverter::ColorConverter: 0x13 --> 0x6
OMX_COLOR_FormatYUV420Planar -> OMX_COLOR_Format16bitRGB565

frameworks/native/include/media/openmax/OMX_IVCommon.h 

	typedef enum OMX_COLOR_FORMATTYPE {
	0    OMX_COLOR_FormatUnused,
	1    OMX_COLOR_FormatMonochrome,
	2    OMX_COLOR_Format8bitRGB332,
	3    OMX_COLOR_Format12bitRGB444,
	4    OMX_COLOR_Format16bitARGB4444,
	5    OMX_COLOR_Format16bitARGB1555,
	6    OMX_COLOR_Format16bitRGB565,
	7    OMX_COLOR_Format16bitBGR565,
	8    OMX_COLOR_Format18bitRGB666,
	9    OMX_COLOR_Format18bitARGB1665,
	0xa    OMX_COLOR_Format19bitARGB1666,
	0xb    OMX_COLOR_Format24bitRGB888,
	0xc    OMX_COLOR_Format24bitBGR888,
	0xd    OMX_COLOR_Format24bitARGB1887,
	0xe    OMX_COLOR_Format25bitARGB1888,
	0xf    OMX_COLOR_Format32bitBGRA8888,
	0x10    OMX_COLOR_Format32bitARGB8888,
	0x11    OMX_COLOR_FormatYUV411Planar,
	0x12    OMX_COLOR_FormatYUV411PackedPlanar,
	0x13    OMX_COLOR_FormatYUV420Planar,
	0x14    OMX_COLOR_FormatYUV420PackedPlanar,

ColorConverter: [Decker] ColorConverter::ColorConverter: 0x13 --> 0x6
OMX_COLOR_FormatYUV420Planar -> OMX_COLOR_Format16bitRGB565

Здесь вроде как OMX_COLOR_FormatYUV420Planar берется непосредственно с камеры, а вот target format =
OMX_COLOR_Format16bitRGB565 задается здесь:

frameworks/av/media/libstagefright/StagefrightMetadataRetriever.cpp 

ColorConverter converter((OMX_COLOR_FORMATTYPE)srcFormat, OMX_COLOR_Format16bitRGB565); (!)

Сама конвертация происходит в frameworks/av/media/libstagefright/colorconversion/ColorConverter.cpp 

        case OMX_COLOR_FormatYUV420Planar:
            err = convertYUV420Planar(src, dst);

Поэтому если мы применим вот такой патч в коде convertYUV420Planar:

	    // [+] Decker, RGB <--> BGR converting for camera for OMX.google.h264.encoder (libstagefright_soft_avcenc.so)
            signed u_b = v * 409;
            signed u_g = -u * 100;
            signed v_g = -v * 208;
            signed v_r = u * 517;

Кстати, кому интересно могут почитать про цветовую модель YUV - https://ru.wikipedia.org/wiki/YUV .

И в этом случае на картинке предпросмотра, после съемки видео цвета будут адекватные. Однако, само кодирование видео по прежнему
идет с заменой Red <-> Blue, поэтому если посмотреть ролик, то в нем будут искаженные цвета :(

Вообщем я решил не зацикливаться на этом, т.к. как я понял с камеры идет OMX_COLOR_FormatYUV420Planar, Encoder как раз 
понимает этот формат и честно жмет его. А то что в YUV уже перепутанные R<->B естественно его не волнует. Т.е. по хорошему 
перед тем как сжимать видео с камеры нужна конвертация внутри YUV420Planar ... т.е. поменять местами RGB и BGR. Как это сделать
сходу (т.е. за ночь :( я не разобрался. Поэтому я решил перейти к аппаратным MTK'шным кодекам. А на использование
google.h264.encoder просто "забить".

[8] Ну продолжаем ... 

Итак, в проект дерева были добавлены:

- yuv_formats.txt - описание форматов YUV (в том числе и YUV420 Planar)
- yuv_formats.jpg - картинка, иллюстрирующая битовые плоскости различных форматов YUV
- stock-blobs-gcc-ver.txt - текстовый файл, в котором указаны версии GCC для всех lib/*.so из стоковой прошивки Rel015 (это нам пригодится в дальнейшем)
- 0006-Implement-mtk-color-format-support-fire855.patch - патч framework/av от уважаемого fire855 с добавлением color format'а OMX_MTK_COLOR_FormatYV12 (0x7F000200)
- init.mt6735.rc - были внесены изменения, касающихся прав на /dev/Vcodec (без этих изменений MTK'шный видеокодек скорее всего бы не запустился)

Итак, мы приняли решение отказаться от использования софтверного OMX.google.h264.encoder (libstagefright_soft_avcenc.so),
тем более что color conversion для него мы так и не написали. Поэтому вносим изменения в etc media codecs (в коммите
они будут отражены, поэтому здесь я их описывать не буду), т.е. добавляем поддержку аппаратных кодеков от MTK.

После этого при попытке записи видео мы получаем следующий лог:

	01-25 01:05:19.829  1001  1102 D MtkOmxCore: Mtk_OMX_Init gCoreComponents 0xa0aca000
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: +++++ dump_core_comp_table +++++
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.HEVC), role(video_decoder.hevc), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.MPEG2), role(video_decoder.mpeg2), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.H263), role(video_decoder.h263), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.MPEG4), role(video_decoder.mpeg4), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.AVC), role(video_decoder.avc), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.AVC.secure), role(video_decoder.avc), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.RV), role(video_decoder.rv), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.VC1), role(video_decoder.vc1), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.VPX), role(video_decoder.vpx), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.VP9), role(video_decoder.vp9), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.DIVX), role(video_decoder.divx), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.DIVX3), role(video_decoder.divx3), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.XVID), role(video_decoder.xvid), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.DECODER.S263), role(video_decoder.s263), path(libMtkOmxVdecEx.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.RA), role(audio_decoder.ra), path(libMtkOmxCookDec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.MP3), role(audio_decoder.mp3), path(libMtkOmxMp3Dec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.G711.ALAW), role(audio_decoder.g711), path(libMtkOmxG711Dec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.G711.MLAW), role(audio_decoder.g711), path(libMtkOmxG711Dec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.WMAPRO), role(audio_decoder.wma), path(libMtkOmxWmaProDec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.WMA), role(audio_decoder.wma), path(libMtkOmxWmaDec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.ENCODER.AVC), role(video_encoder.avc), path(libMtkOmxVenc.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.ENCODER.H263), role(video_encoder.h263), path(libMtkOmxVenc.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.VIDEO.ENCODER.MPEG4), role(video_encoder.mpeg4), path(libMtkOmxVenc.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.ENCODER.VORBIS), role(audio_encoder.vorbis), path(libMtkOmxVorbisEnc.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.APE), role(audio_decoder.ape), path(libMtkOmxApeDec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.FLAC), role(audio_decoder.flac), path(libMtkOmxFlacDec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.ADPCM.MS), role(audio_decoder.adpcm), path(libMtkOmxAdpcmDec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.ADPCM.DVI), role(audio_decoder.adpcm), path(libMtkOmxAdpcmDec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.ENCODER.ADPCM.MS), role(audio_encoder.adpcm), path(libMtkOmxAdpcmEnc.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.ENCODER.ADPCM.DVI), role(audio_encoder.adpcm), path(libMtkOmxAdpcmEnc.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.RAW), role(audio_decoder.raw), path(libMtkOmxRawDec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.GSM), role(audio_decoder.gsm), path(libMtkOmxGsmDec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: name(OMX.MTK.AUDIO.DECODER.ALAC), role(audio_decoder.alac), path(libMtkOmxAlacDec.so)
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: ----- dump_core_comp_table -----
	01-25 01:05:19.830  1001  1102 D MtkOmxCore: -MTK_OMX_Init tick=1485295519830

Т.е. мы видим, что наши аппаратные кодеки были "подцеплены", однако, съемка видео все равно крашится через несколько секунд из-за этого:

	01-25 01:45:42.469   267  3226 E MtkOmxVenc: [0xa8f7b600] [ERROR] cannot support H.264 (1920x1080) encoder
	01-25 01:45:42.469   267  3226 E MtkOmxVenc: [0xa8f7b600] [ERROR] for low-cost chip, we still support H.264 (1920x1080) encoder
	01-25 01:45:42.469   267  3226 E MtkOmxVenc: [0xa8f7b600] VAL_CHIP_NAME_DENALI_2
	01-25 01:45:42.469   267  3226 I VDO_LOG : [getChipName] outChipName: VAL_CHIP_NAME_DENALI_2
	01-25 01:45:42.469   267  3226 I VDO_LOG : [ION][eVideoMemAlloc] mt_ion_open, val_public i4IonDevFd = 167 
	01-25 01:45:42.470   267  3226 I VDO_LOG : [ION][eVideoMemAlloc] pvMemVa = 0xa8cb9000, pvAlignMemVa = 0xa8cb9000, pvMemPa = 0x6b00000, pvAlignMemPa = 0x6b00000, MemSize = 872, ByteAlignment = 32
	01-25 01:45:42.470   267  3226 I VDO_LOG : [ION][eVideoMemAlloc] pvMemVa = 0xa8cb8000, pvAlignMemVa = 0xa8cb8000, pvMemPa = 0x7400000, pvAlignMemPa = 0x7400000, MemSize = 256, ByteAlignment = 32
	01-25 01:45:42.470   267  3226 I VDO_LOG : [WRAPPER] Wrapper's handle : 0xa8cb92c8
	01-25 01:45:42.470   267  3226 E VDO_LOG : @@ first use h.264 enc, so dlopen libh264enc_sa.ca7.so
	01-25 01:45:42.480   267  3226 E MtkOmxVenc: [0xa8f7b600] @@ [MtkOmxVenc::EncodeAVC] FrameWidth=1920, FrameHeight=1080, BufWidth=1920, BufHeight=1080
	01-25 01:45:42.480   267  3226 E VDO_LOG : [eHalEMICtrlForRecordSize] VideoRecordSize_Set(BWC_SIZE(1920, 1080))
	01-25 01:45:42.480   267  3226 I VDO_LOG : [getChipName] outChipName: VAL_CHIP_NAME_DENALI_2
	01-25 01:45:42.480   267  3226 I VDO_LOG : [eValInit] pid = 0x10b, driver type = 0x5
	01-25 01:45:42.480   267  3226 I VDO_LOG : VCodec_ValFd=170
	01-25 01:45:42.480   267  3226 I VDO_LOG : [eHalEMICtrl] VideoEncodeCodec_Set(BWCVT_H264)
	01-25 01:45:42.481   267  3226 I VDO_LOG : [eHalEMICtrl] Profile_Change(BWCPT_VIDEO_RECORD, true)
	01-25 01:45:42.481   267  3226 I VDO_LOG : H264 init val 0x0, hal 0xa8cb90e0
	01-25 01:45:42.481   267  3226 I VDO_LOG : [getChipName] outChipName: VAL_CHIP_NAME_DENALI_2
	01-25 01:45:42.482   267  3226 D MtkOmxVenc: [0xa8f7b600] [EncSettingCodec] Input Format = 0x7f000200, ColorFormat = 0x5
	01-25 01:45:42.482   267  3226 D MtkOmxVenc: [0xa8f7b600] 0x2
	01-25 01:45:42.482   267  3226 D MtkOmxVenc: [0xa8f7b600] Encoding: Format = 5, Profile = 1, Level = 8, Width = 1920, Height = 1080, BufWidth = 1920, BufHeight = 1080, NumPFrm = 29, NumBFrm = 0, Framerate = 30, Interlace = 0FrameRateQ16=1966080, IntraFrameRate=30, fgMBAFF=0
	01-25 01:45:42.482   267  3226 I VDO_LOG : ======== pfnOpen ========pmhalVdoDrv a8cb90e0, prCodecAPI a8cb92c8, pfnOpen b5fd0c45
	01-25 01:45:42.482   267  3226 I VDO_LOG : ======== pfnOpen ========handle 0 addr = a8cb90e0 prCodecAPI a8cb92c8
	01-25 01:45:42.482   267  3226 I VDO_LOG : [WRAPPER] EncodeOpen
	01-25 01:45:42.482   267  3226 I VDO_LOG : [ION][eVideoMemAlloc] pvMemVa = 0xa8cb5000, pvAlignMemVa = 0xa8cb5000, pvMemPa = 0xb100000, pvAlignMemPa = 0xb100000, MemSize = 9816, ByteAlignment = 64
	01-25 01:45:42.483   267  3226 E VDO_LOG : ======== pfnSetParameter VCODEC_ENC_PARAM_BITRATE = 14000 ========
	01-25 01:45:42.483   267  3226 I VDO_LOG : ======== pfnSetParameter VCODEC_ENC_PARAM_SET_AVAILABLE_CPU_NUM = 1 ========
	01-25 01:45:42.536   267  3225 D MtkOmxVenc: [0xa8f7b600] a8f7b600 ETB (0xB5D97F80) (0xA5680000) (8), mNumPendingInput(2)
	01-25 01:45:42.538   267  3226 I VDO_LOG : [ION][eVideoMemAlloc] pvMemVa = 0x9adf5000, pvAlignMemVa = 0x9adf5000, pvMemPa = 0xb200000, pvAlignMemPa = 0xb200000, MemSize = 19913280, ByteAlignment = 32
	01-25 01:45:42.560   267  3226 I VDO_LOG : [WRAPPER] EncodeGenerateHeader
	01-25 01:45:42.561   267  3226 I VDO_LOG : [WRAPPER] UpdateBitstreamWP
	01-25 01:45:42.561   267  3226 D MtkOmxVenc: [0xa8f7b600] Sequence header size = 26
	01-25 01:45:42.561   267  3226 D MtkOmxVenc: [0xa8f7b600] mIsMultiSlice = 0
	01-25 01:45:42.561   267  3226 D MtkOmxVenc: [0xa8f7b600] a8f7b600 FBD (0xB5D98460) (0xA4B80000) 28615 (26), mNumPendingOutput(7)
	01-25 01:45:42.561   267  3223 D MtkOmxVenc: [0xa8f7b600] MtkOmxVenc::GetParameter (0x02000001)
	01-25 01:45:42.562   267  3226 D MtkOmxVenc: [0xa8f7b600] FrameBuf : handle = 0xb5d58c00, VA = 0x9aaf7000, PA = 0xae00000, format=HAL_PIXEL_FORMAT_YV12(0x32315659), ion=161
	01-25 01:45:42.564   267  3225 D MtkOmxVenc: [0xa8f7b600] a8f7b600 FTB (0xB5D98460) (0xA4B80000) (2097152), mNumPendingOutput(8)
	01-25 01:45:42.567   267  3225 D MtkOmxVenc: [0xa8f7b600] a8f7b600 ETB (0xB5D980A0) (0xA5380000) (8), mNumPendingInput(3)
	01-25 01:45:42.613   267  3225 D MtkOmxVenc: [0xa8f7b600] a8f7b600 ETB (0xB5D98100) (0xA5080000) (8), mNumPendingInput(4)
	01-25 01:45:42.673   267  3225 D MtkOmxVenc: [0xa8f7b600] a8f7b600 ETB (0xB5D98160) (0xA4D80000) (8), mNumPendingInput(5)
	01-25 01:45:42.698   267  3226 F libc    : Fatal signal 11 (SIGSEGV), code 1, fault addr 0x0 in tid 3226 (MtkOmxVencEncod)

	01-25 01:45:42.757   264   264 F DEBUG   : *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
	01-25 01:45:42.758   264   264 F DEBUG   : CM Version: '13.0-20170124-UNOFFICIAL-smart_surf2_4g'
	01-25 01:45:42.758   264   264 F DEBUG   : Build fingerprint: 'MTS/cm_smart_surf2_4g/smart_surf2_4g:6.0.1/MOB31K/ec5185323d:userdebug/test-keys'
	01-25 01:45:42.758   264   264 F DEBUG   : Revision: '0'
	01-25 01:45:42.758   264   264 F DEBUG   : ABI: 'arm'
	01-25 01:45:42.758   759   897 W NativeCrashListener: Couldn't find ProcessRecord for pid 267
	01-25 01:45:42.758   264   264 F DEBUG   : pid: 267, tid: 3226, name: MtkOmxVencEncod  >>> /system/bin/mediaserver <<<
	01-25 01:45:42.758   264   264 F DEBUG   : signal 11 (SIGSEGV), code 1 (SEGV_MAPERR), fault addr 0x0
	01-25 01:45:42.758   264   264 E DEBUG   : AM write failed: Broken pipe
	01-25 01:45:42.762  1873  3260 I system_update: [262656,0,0,NULL]
	01-25 01:45:42.782  1688  1933 I GCoreUlr: Unbound from all location providers
	01-25 01:45:42.782  1688  1933 I GCoreUlr: Place inference reporting - stop
	01-25 01:45:42.784   264   264 F DEBUG   :     r0 00000000  r1 00000000  r2 00000000  r3 00000000
	01-25 01:45:42.784   264   264 F DEBUG   :     r4 9adf5010  r5 9adf5010  r6 9adf7010  r7 00000000
	01-25 01:45:42.784   264   264 F DEBUG   :     r8 9adf5010  r9 00000001  sl 00000000  fp 9adf5498
	01-25 01:45:42.784   264   264 F DEBUG   :     ip b5f9deec  sp a8170408  lr b5f8a4e1  pc b69e20f2  cpsr 40000030
	01-25 01:45:42.799   264   264 F DEBUG   : 
	01-25 01:45:42.799   264   264 F DEBUG   : backtrace:
	01-25 01:45:42.799   264   264 F DEBUG   :     #00 pc 000400f2  /system/lib/libc.so (pthread_cond_wait+3)
	01-25 01:45:42.799   264   264 F DEBUG   :     #01 pc 000014df  /system/lib/libvcodec_oal.so (VCodecPthread_cond_wait+14)
	01-25 01:45:42.799   264   264 F DEBUG   :     #02 pc 00026cec  /system/lib/libh264enc_sa.ca7.so (H264SwEncStrmEncode+4260)

Почему? Давайте посмотрим на версии компилятора библиотек libc.so, libvcodec_oal.so и libvcodec_oal.so. Первая собрана у нас из исходников CM, здесь у нас GCC: (GNU) 4.9.x-google 20140827 (prerelease) clang version 3.6. Две другие взяты из стоковой Rel15, кодеки от MTK:

- libvc1dec_sa.ca7.so: GCC: (GNU) 4.7
- libvcodecdrv.so: GCC: (GNU) 4.9.x-google 20140827 (prerelease) clang version 3.6
- libvcodec_cap.so: GCC: (GNU) 4.9.x-google 20140827 (prerelease) clang version 3.6
- libvcodec_oal.so: GCC: (GNU) 4.7 
- libvcodec_utility.so: GCC: (GNU) 4.9.x-google 20140827 (prerelease) clang version 3.6
 
Не знаю как объяснить правильно, но с совместимостью библиотек собранными разными версиями GCC до 4.8 включительно и выше есть некая проблема, связанная с pthread / address alignment / address sanites (???), которую я описал здесь - [GCC: (GNU) 4.9.x-google 20140827 (prerelease). Проблема с alignment (address sanitize)?](https://toster.ru/q/390882) (может быть профессионалы там дадут ответ на вопрос), также ее описал daniel_hk [здесь](https://forum.xda-developers.com/k3-note/orig-development/rom-custom-nougat-roms-k-3-note-t3513466) (читать с раздела III. The Camera, там правда у него крашится при вызове ioctl и он связывает это именно со специфическими memory align, но думаю здесь проблема со схожими корнями). Итак, наша задача найти библиотеки, которые взяты из стоковой прошивки и собраны современным gcc 4.9.x, собранными с более низкой версией GCC. Я это сделал в дереве [android_vendor_d5110_infinix](https://github.com/Nonta72/android_vendor_d5110_infinix) от Nonta72.

Там libvcodecdrv.so и ibvcodec_utility.so собраны с помощью GCC: (GNU) 4.8 (!), заменим их в нашей прошивке.

А также заменим libMtkOmxVenc.so, libvcodec_oal.so по тем же причинам (вообще в случае проблем libMtk*.so, т.е. все что касается OMX наверное можно целиком взять оттуда, т.к. там все это собрано 4.8 GCC) и ниже.

В итоге получаем **рабочую запись видео** ... На этом моменте можно кричать - ура, ура, ура ... ;)

[9] Осталось пофиксить Bluetooth, SEPolicy ... еще раз проверить работу RIL, добавить пункт LTE в меню сетей, а то
сейчас по-умолчанию стоит ro.telephony.default_network=9 , а в меню только пунты 2G/3G ;) Плюс свякие мелочи, 
вроде добавления реальной емкости батареи в overlay и т.д. и т.п.

[10] Починен Bluetooth. Теперь он работает. Правда проверялось только на передаче файлов с телефона на телефон,
другие профили, например, связь с беспроводной гарнитурой не тестировались. Проблема с Bluetooth была вызвана
libbt-vendor собираемым из исходников, который оказался в дереве "по наследству" от MT6580. Дело в том что 
MT6580 по другому общается с Bluetooth'ом, через libbluetoothdrv.so, которой в MT6737M естественно нет. Простым 
отключением сборки libbt-vendor в PRODUCT_PACKAGES в device_smart_surf2_4g.mk удалось заставить его работать.
Для других профилей (связь с гарнитурой и т.п.) возможно нужны патчи framework'а, например этот [0001_bt_update.patch](https://github.com/sicmosh/cm13.0_device_tree_xiaomi_hennessy/blob/master/patches/system_bt/0001_bt_update.patch),
но это только предстоит выяснить.

Так как в Android.mk в папке libbt-vendor-mtk присутствует, то модуль почему-то (?) собирается и копируется в /system/vendor 
даже несмотря на его отсутствие в PRODUCT_PACKAGES. Поэтому я, чтобы не удалять модуль из дерева (мало ли где пригодится), 
дополнительно просто сделал проверку платформы в Android.mk, это видно в коммите.

Другими словами - то что в папке **mtk** в дереве при сборке **не используется** совсем. Почему я просто не удалил
эту папку из дерева? Просто потому что частично эти исходники могут понадобиться мне, а также другим пользователям,
которые будут пытаться собирать что-то свое на базе моего дерева и не хотелось чтобы они "потерялись".

[11]

А вот так можно сделать фильтр по нескольким платформам:

	ifeq ($(TARGET_BOARD_PLATFORM), $(filter $(TARGET_BOARD_PLATFORM), mt6735m mt6580))
	endif

Продолжение следует ... ;)
