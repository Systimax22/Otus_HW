В начале загрузки, нажимаем "e" и редактируем параметры загрузчика, добавляем init=/bin/bash


## Способ 1.


![alt text](https://github.com/Systimax22/Otus_HW/blob/main/Lession7/img/1.png "Редактирование")

Выходим через ctrl+x, загружаемся, получаем шелл с правами root, монтируем ФС в режиме чтение/запись, создаем файл /.autorelabel для Selinux, меняем пароль.

![alt text](https://github.com/Systimax22/Otus_HW/blob/main/Lession7/img/2.png "Смена пароля")

В загрузчике можно сразу указать опцию rw.

## Способ 2.

