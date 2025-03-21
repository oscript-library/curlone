// BSLLS:LatinAndCyrillicSymbolInWord-off

#Использовать asserts
#Использовать coloratos
#Использовать "../src/cli"

&Тест
Процедура ТестДолжен_ПроверитьКонвертациюПоУмолчанию() Экспорт

	Аргументы = Новый Массив();
	Аргументы.Добавить("convert");
	Аргументы.Добавить("http://example.com/");

	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонсольныйКонвертер = Новый КонсольныйКонвертерКомандыCURL(Аргументы);
	КонсольныйКонвертер.Конвертировать();

	Результат = КонсольныйКонвертер.ПолучитьРезультат();

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);

КонецПроцедуры

&Тест
Процедура ТестДолжен_ПроверитьКонвертацию1C() Экспорт

	Аргументы = Новый Массив();
	Аргументы.Добавить("convert");
	Аргументы.Добавить("1C");
	Аргументы.Добавить("http://example.com/");

	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонсольныйКонвертер = Новый КонсольныйКонвертерКомандыCURL(Аргументы);
	КонсольныйКонвертер.Конвертировать();

	Результат = КонсольныйКонвертер.ПолучитьРезультат();

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

&Тест
Процедура ТестДолжен_ПроверитьКонвертациюКоннектор() Экспорт

	Аргументы = Новый Массив();
	Аргументы.Добавить("convert");
	Аргументы.Добавить("connector");
	Аргументы.Добавить("http://example.com/");

	ПрограммныйКод = "Результат = КоннекторHTTP.Get(""http://example.com"");";

	КонсольныйКонвертер = Новый КонсольныйКонвертерКомандыCURL(Аргументы);
	КонсольныйКонвертер.Конвертировать();

	Результат = КонсольныйКонвертер.ПолучитьРезультат();

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);

КонецПроцедуры

&Тест
Процедура ТестДолжен_ПроверитьОтсутствиеВлиянияРегистраКоманд() Экспорт

	Аргументы = Новый Массив();
	Аргументы.Добавить("coNverT");
	Аргументы.Добавить("coNnecTor");
	Аргументы.Добавить("http://example.com/");

	ПрограммныйКод = "Результат = КоннекторHTTP.Get(""http://example.com"");";

	КонсольныйКонвертер = Новый КонсольныйКонвертерКомандыCURL(Аргументы);
	КонсольныйКонвертер.Конвертировать();

	Результат = КонсольныйКонвертер.ПолучитьРезультат();

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

&Тест
Процедура ТестДолжен_ПроверитьСПередачейАргументаCurlБезЯзыка() Экспорт

	Аргументы = Новый Массив();
	Аргументы.Добавить("convert");
	Аргументы.Добавить("curl");
	Аргументы.Добавить("http://example.com/");

	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонсольныйКонвертер = Новый КонсольныйКонвертерКомандыCURL(Аргументы);
	КонсольныйКонвертер.Конвертировать();

	Результат = КонсольныйКонвертер.ПолучитьРезультат();

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

&Тест
Процедура ТестДолжен_ПроверитьСПередачейАргументаCurlИЯзыка() Экспорт

	Аргументы = Новый Массив();
	Аргументы.Добавить("convert");
	Аргументы.Добавить("connector");
	Аргументы.Добавить("curl");
	Аргументы.Добавить("http://example.com/");

	ПрограммныйКод = "Результат = КоннекторHTTP.Get(""http://example.com"");";

	КонсольныйКонвертер = Новый КонсольныйКонвертерКомандыCURL(Аргументы);
	КонсольныйКонвертер.Конвертировать();

	Результат = КонсольныйКонвертер.ПолучитьРезультат();

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

&Тест
Процедура ТестДолжен_ПроверитьВыбрасываниеИсключенияСОшибочнойКомандой() Экспорт

	Аргументы = Новый Массив();
	Аргументы.Добавить("wrong");

	КонсольныйКонвертер = Новый КонсольныйКонвертерКомандыCURL(Аргументы);

	Ожидаем.Что(КонсольныйКонвертер)
		.Метод("Конвертировать")
		.ВыбрасываетИсключение();
	
КонецПроцедуры