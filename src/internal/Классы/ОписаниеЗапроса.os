Перем URL Экспорт; // Массив из Строка
Перем Заголовки Экспорт; // Соответствие из КлючИЗначение
Перем Метод Экспорт; // Строка
Перем ИмяПользователя Экспорт; // Строка
Перем ПарольПользователя Экспорт; // Строка
Перем ОтправляемыеТекстовыеДанные Экспорт; // Массив из Строка
Перем Файлы Экспорт; // Массив из см. ПередаваемыйФайл
Перем ПередаватьОтправляемыеДанныеВСтрокуЗапроса Экспорт; // Булево
Перем ИмяФайлаСертификатаКлиента Экспорт; // Строка
Перем ПарольСертификатаКлиента Экспорт; // Строка
Перем ИспользоватьСертификатыУЦИзХранилищаОС Экспорт; // Булево
Перем ИмяФайлаСертификатовУЦ Экспорт; // Строка
Перем ПараметрыЗапроса Экспорт; // Массив из Строка

Процедура ПриСозданииОбъекта()
	URL = Новый Массив;
	Заголовки = Новый Соответствие();
	Метод = "GET";
	ИмяПользователя = "";
	ПарольПользователя = "";
	ОтправляемыеТекстовыеДанные = Новый Массив;
	Файлы = Новый Массив;
	ПередаватьОтправляемыеДанныеВСтрокуЗапроса = Ложь;
	ИмяФайлаСертификатаКлиента = "";
	ПарольСертификатаКлиента = "";
	ИспользоватьСертификатыУЦИзХранилищаОС = Ложь;
	ИмяФайлаСертификатовУЦ = "";
	ПараметрыЗапроса = Новый Массив;
КонецПроцедуры