#Использовать asserts
#Использовать ".."

Перем юТест;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт

	юТест = Тестирование;
	
	СписокТестов = Новый Массив;
	
	СписокТестов.Добавить("ТестДолжен_ВыброситьИсключениеКомандаНачинаетсяНеСCurl");
	СписокТестов.Добавить("ТестДолжен_ВыброситьИсключениеЕслиПереданаПустаяКоманда");

	Возврат СписокТестов;
	
КонецФункции

Процедура ТестДолжен_ВыброситьИсключениеКомандаНачинаетсяНеСCurl() Экспорт

	КонсольнаяКоманда = "myapp -H 'accept: text/html'";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(КонсольнаяКоманда);
	ПараметрыМетода.Добавить(Новый КонстуркторПрограммногоКода1С());

	Ожидаем.Что(КонвертерКомандыCURL)
		.Метод("Конвертировать", ПараметрыМетода)
		.ВыбрасываетИсключение("Команда должна начинаться с ""curl""");

КонецПроцедуры

Процедура ТестДолжен_ВыброситьИсключениеЕслиПереданаПустаяКоманда() Экспорт

	КонсольнаяКоманда = "";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(КонсольнаяКоманда);
	ПараметрыМетода.Добавить(Новый КонстуркторПрограммногоКода1С());

	Ожидаем.Что(КонвертерКомандыCURL)
		.Метод("Конвертировать", ПараметрыМетода)
		.ВыбрасываетИсключение("Команда должна начинаться с ""curl""");

КонецПроцедуры
