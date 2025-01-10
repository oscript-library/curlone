#Использовать asserts
#Использовать ".."

Перем юТест;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт

	юТест = Тестирование;
	
	СписокТестов = Новый Массив;
	
	СписокТестов.Добавить("ТестДолжен_ВыброситьИсключениеКомандаНачинаетсяНеСCurl");
	СписокТестов.Добавить("ТестДолжен_ВыброситьИсключениеЕслиПереданаПустаяКоманда");
	СписокТестов.Добавить("ТестДолжен_ПроверитьОшибкуОпцияНеизвестна");
	СписокТестов.Добавить("ТестДолжен_ПроверитьОшибкуОпцияНеПоддерживается");
	СписокТестов.Добавить("ТестДолжен_ПроверитьОшибкуНеУказанURL");
	СписокТестов.Добавить("ТестДолжен_ВыброситьИсключениеПриНеудачномПолученииНомераПорта");
	СписокТестов.Добавить("ТестДолжен_ПроверитьОшибкуНеправильноеИспользованиеФигурныхСкобокПриПередачеФайла");
	СписокТестов.Добавить("ТестДолжен_ПроверитьОшибкуЗапрещеноОдновременноеИспользованиеНесколькихHTTPМетодов");
	СписокТестов.Добавить("ТестДолжен_ПроверитьОшибкуПротоколНеПоддерживается");

	Возврат СписокТестов;
	
КонецФункции

Процедура ТестДолжен_ВыброситьИсключениеКомандаНачинаетсяНеСCurl() Экспорт

	КонсольнаяКоманда = "myapp -H 'accept: text/html'";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(КонсольнаяКоманда);
	ПараметрыМетода.Добавить(Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(КонвертерКомандыCURL)
		.Метод("Конвертировать", ПараметрыМетода)
		.ВыбрасываетИсключение("Команда должна начинаться с ""curl""");

КонецПроцедуры

Процедура ТестДолжен_ВыброситьИсключениеЕслиПереданаПустаяКоманда() Экспорт

	КонсольнаяКоманда = "";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(КонсольнаяКоманда);
	ПараметрыМетода.Добавить(Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(КонвертерКомандыCURL)
		.Метод("Конвертировать", ПараметрыМетода)
		.ВыбрасываетИсключение("Передана пустая команда");

КонецПроцедуры


Процедура ТестДолжен_ПроверитьОшибкуОпцияНеизвестна() Экспорт

	КонсольнаяКоманда = "curl http://example.com/ --unknown-option";

	Ошибки = Неопределено;

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда,, Ошибки);

	Ожидаем.Что(Результат).Не_().Заполнено();
	Ожидаем.Что(Ошибки).Заполнено();
	Ожидаем.Что(Ошибки[0].Текст).Равно("Опция --unknown-option неизвестна");
	Ожидаем.Что(Ошибки[0].Критичная).ЭтоИстина();

КонецПроцедуры

Процедура ТестДолжен_ПроверитьОшибкуОпцияНеПоддерживается() Экспорт

	КонсольнаяКоманда = "curl http://example.com/ --hsts cache.txt";
	
	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	Ошибки = Неопределено;

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда,, Ошибки);

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	Ожидаем.Что(Ошибки).Заполнено();
	Ожидаем.Что(Ошибки[0].Текст).Равно("Опция --hsts не поддерживается");
	Ожидаем.Что(Ошибки[0].Критичная).ЭтоЛожь();

КонецПроцедуры

Процедура ТестДолжен_ПроверитьОшибкуНеУказанURL() Экспорт

	КонсольнаяКоманда = "curl";
	
	Ошибки = Неопределено;

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда,, Ошибки);

	Ожидаем.Что(Результат).Не_().Заполнено();
	Ожидаем.Что(Ошибки).Заполнено();
	Ожидаем.Что(Ошибки[0].Текст).Равно("Не указан URL");
	Ожидаем.Что(Ошибки[0].Критичная).ЭтоИстина();

КонецПроцедуры

Процедура ТестДолжен_ВыброситьИсключениеПриНеудачномПолученииНомераПорта() Экспорт

	КонсольнаяКоманда = "curl http://example.com:port";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(КонсольнаяКоманда);
	ПараметрыМетода.Добавить(Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(КонвертерКомандыCURL)
		.Метод("Конвертировать", ПараметрыМетода)
		.ВыбрасываетИсключение("Не удалось получить номер порта из URL 'http://example.com:port'");

КонецПроцедуры

Процедура ТестДолжен_ПроверитьОшибкуНеправильноеИспользованиеФигурныхСкобокПриПередачеФайла() Экспорт

	ТестовыеЗначения = Новый Массив();
	ТестовыеЗначения.Добавить("{path");
	ТестовыеЗначения.Добавить("path}");
	ТестовыеЗначения.Добавить("}path}");
	ТестовыеЗначения.Добавить("{path{");
	ТестовыеЗначения.Добавить("}path{");

	Для Каждого ТестовоеЗначение Из ТестовыеЗначения Цикл
		КонсольнаяКоманда = "curl --upload-file '" + ТестовоеЗначение + "' http://example.com";

		Ошибки = Неопределено;

		КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
		Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда,, Ошибки);

		Ожидаем.Что(Ошибки).Заполнено();
		Ожидаем.Что(Ошибки[0].Текст).Равно("Неправильное использование фигурных скобок в значении '" + ТестовоеЗначение + "' опции -T, --upload-file");
		Ожидаем.Что(Ошибки[0].Критичная).ЭтоИстина();
	КонецЦикла;
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьОшибкуЗапрещеноОдновременноеИспользованиеНесколькихHTTPМетодов() Экспорт
	
	// Ошибочные команды
	ОшибочныеКоманды = Новый Массив();
	ОшибочныеКоманды.Добавить("-T file --get -d 'key=val'");
	ОшибочныеКоманды.Добавить("-T file -d 'key=val'");
	ОшибочныеКоманды.Добавить("-T file --json '{""key"": ""val""}'");
	ОшибочныеКоманды.Добавить("-T file --head");
	ОшибочныеКоманды.Добавить("-d 'key=val' --head");

	Для Каждого Команда Из ОшибочныеКоманды Цикл
		КонсольнаяКоманда = "curl http://example.com " + Команда;

		Ошибки = Неопределено;

		КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
		Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда,, Ошибки);

		Ожидаем.Что(Ошибки, "Команда не валидна: " + КонсольнаяКоманда).Заполнено();
		Ожидаем.Что(Ошибки[0].Текст).Содержит("Запрещено одновременное использование нескольких HTTP методов");
		Ожидаем.Что(Ошибки[0].Критичная).ЭтоИстина();
	КонецЦикла;
	
	// Валидные команды
	ВалидныеКоманды = Новый Массив();
	ВалидныеКоманды.Добавить("-T file --get");
	ВалидныеКоманды.Добавить("--get --head");
	ВалидныеКоманды.Добавить("-d 'key=val' --get");
	ВалидныеКоманды.Добавить("--get --head");
	ВалидныеКоманды.Добавить("-d 'key=val' --get --head");

	Для Каждого Команда Из ВалидныеКоманды Цикл
		КонсольнаяКоманда = "curl http://example.com " + Команда;

		Ошибки = Неопределено;

		КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
		Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда,, Ошибки);

		Ожидаем.Что(Ошибки, "Команда валидна: " + КонсольнаяКоманда).Не_().Заполнено();
	КонецЦикла;

КонецПроцедуры

Процедура ТестДолжен_ПроверитьОшибкуПротоколНеПоддерживается() Экспорт

	КонсольнаяКоманда = "curl smtp://example.com";

	Ошибки = Неопределено;

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда,, Ошибки);

	Ожидаем.Что(Результат).Не_().Заполнено();
	Ожидаем.Что(Ошибки).Заполнено();
	Ожидаем.Что(Ошибки[0].Текст).Равно("Протокол ""smtp"" не поддерживается");
	Ожидаем.Что(Ошибки[0].Критичная).ЭтоИстина();

КонецПроцедуры