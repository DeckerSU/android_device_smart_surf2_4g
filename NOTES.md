###Заметки

Как обычно, заметки к прошивке. Разработка CM14.1 / LineageOS 14.1 началась вот с [этого дерева](https://github.com/DeckerSU/android_device_smart_surf2_4g/tree/master), ветка **master** в котором является неактивной и больше не поддерживается на данный момент, однако, оставлена из-за ценных комментариев и т.п., которые просто жалко терять.

Собственно что касается этого смартфона история была следующей. Вначале я собрал CM14 с неработающей видеозаписью и GPS. Потом, т.к. на тот момент я не мог разобраться что к чему, я временно бросил CM14 ветку и создал [полностью работающее дерево для CM13](https://github.com/DeckerSU/android_device_smart_surf2_4g/tree/cm13.0-test01) . После чего временно занялся другими аппаратами - Tele2 Maxi Plus и Tele2 Maxi LTE. Ветка CM13 для Tele2 Maxi LTE "выросла" как раз из этого дерева для CM13, с изменениями классов для RIL, многочисленными фиксами и специфичными для 64-bit девайсов вещами.

Затем именно с Tele2 Maxi LTE я начал работать над CM14 и уже тогда мне удалось заставить работать видеозапись и GPS на CM14. Эта ветка, как раз попытка вернуться с результатами достигнутыми для Tele2 Maxi LTE и применить их к МТС Smart Surf2. 

Итого путь который прошло дерево:

- [master] Smart Surf2 CM14 -> тупиковая ветвь.
- [cm13.0-test01] Smart Surf2 32 bit -> [cm13/lineage13] Tele2 Maxi LTE 64-bit -> [cm14/lineage14] Tele2 Maxi LTE 64-bit -> [lineage14] МТС Smart Surf2 32-bit.

Надеюсь, теперь понятно где смотреть "откуда ноги растут", если вы хотите понять историю изменения какого-либо патча или коммита. 

###Как переопределить один из заголовочных файлов прошивки в дереве?

Пример можно посмотреть прямо здесь. В BoardConfig'е указывается папка в которой будут лежать модифицированные инклуды:

TARGET_SPECIFIC_HEADER_PATH := device/mts/smart_surf2_4g/include

Ну а в папке include в корне device уже кладутся соответствующие заголовочные файла, конкретно здесь это fd_utils-inl-extra.h. Для коммита:

add /proc/ged in fd_utils-inl-extra.h
    
    For more information look: https://github.com/DeckerSU/android_device_smart_surf2_4g/blob/master/README.md
    
    Note #5: add /proc/ged in FD whitelist in frameworks/base/core/jni/fd_utils-inl.h
    
Т.е. здесь мы переопределяем заголовочный файл, лежащий в frameworks/base/core/jni/fd_utils-inl.h.