#использовать "../src/core"
#Использовать asserts
#Использовать logos

Перем юТест;
Перем Лог;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт

	юТест = Тестирование;
	
	ИменаТестов = Новый Массив;
	
	ИменаТестов.Добавить("ТестДолжен_ПроверитьПарсингАргументов");
	ИменаТестов.Добавить("ТестДолжен_ПроверитьПарсингАргументовПослеСбросаОпций");
	
	Возврат ИменаТестов;

КонецФункции

Процедура ТестДолжен_ПроверитьПарсингАргументов() Экспорт
	
	ARG = Аргумент("ARG", Ложь).Флаг();
	SRC = Аргумент("SRC", "").ТСтрока();
	INT = Аргумент("INT", "").ТЧисло();
	DATE = Аргумент("DATE", "").ТДата();
	
	ИндексАргументов = Новый Соответствие;
	ИндексАргументов.Вставить("ARG", ARG);
	ИндексАргументов.Вставить("SRC", SRC);
	ИндексАргументов.Вставить("INT", INT);
	ИндексАргументов.Вставить("DATE", DATE);
		
	ТестовыеСлучаи = Новый Массив;

	ТестовыеСлучаи.Добавить(ТестовыйСлучай("-f x", "-f", Неопределено));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("a", "", "a"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("", "", Неопределено));

	Для каждого Тест Из ТестовыеСлучаи Цикл
		НачальноеКоличество = Тест.Аргументы.Количество();
			
		Лог.Отладка("Проверяю тестовый случай: %1", СтрСоединить(Тест.Аргументы, " "));
		

		Для каждого КлючЗначение Из ИндексАргументов Цикл
		
			Парсер_Аргумента = Новый АргументыПарсера(КлючЗначение.Значение);
			Утверждения.ПроверитьРавенство(КлючЗначение.Ключ, Парсер_Аргумента.ВСтроку(), "Парсер аргументов должен быть равен "+ КлючЗначение.Ключ);

			Контекст = Новый КонтекстПарсеров();
			Результат = Парсер_Аргумента.Поиск(Тест.Аргументы, Контекст);
			
			Утверждения.ПроверитьРавенство(НачальноеКоличество, Тест.Аргументы.Количество(), "Количество аргументов не должно измениться");
				
			Если Тест.ЗначениеОпции = Неопределено Тогда
				Утверждения.ПроверитьЛожь(Результат.Найден, "Аргумент не должен быть найден");
			Иначе
				Утверждения.ПроверитьИстину(Результат.Найден, "Аргумент должен быть найден");
				Утверждения.ПроверитьРавенство(1, Контекст.Аргументы[Парсер_Аргумента.Аргумент].Количество(), "Количество результатов должно быть 1");
				Утверждения.ПроверитьРавенство(Контекст.Аргументы[Парсер_Аргумента.Аргумент][0], Тест.ЗначениеОпции, "Ожидаемые результаты должны быть равны");
				Утверждения.ПроверитьРавенство(СтрСоединить(Результат.Аргументы, " "), СтрСоединить(Тест.АргументыВыхода, " "), "Аргументы выходные должны быть равны");
			
			КонецЕсли;
			

		КонецЦикла;

	КонецЦикла;

КонецПроцедуры

Функция ТестовыйСлучай(Знач Аргументы, Знач АргументыВыхода, Знач ЗначениеОпции)
	
	Тест = Новый Структура;
	Тест.Вставить("Аргументы", СтрРазделить(Аргументы," "));
	Тест.Вставить("АргументыВыхода", СтрРазделить(АргументыВыхода," "));
	Тест.Вставить("ЗначениеОпции", ЗначениеОпции);

	Возврат Тест;
КонецФункции

Процедура ТестДолжен_ПроверитьПарсингАргументовПослеСбросаОпций() Экспорт
	
	ARG = Аргумент("ARG", Ложь).Флаг();
	SRC = Аргумент("SRC", "").ТСтрока();
	INT = Аргумент("INT", "").ТЧисло();
	DATE = Аргумент("DATE", "").ТДата();
	
	ИндексАргументов = Новый Соответствие;
	ИндексАргументов.Вставить("ARG", ARG);
	ИндексАргументов.Вставить("SRC", SRC);
	ИндексАргументов.Вставить("INT", INT);
	ИндексАргументов.Вставить("DATE", DATE);
		
	ТестовыеСлучаи = Новый Массив;

	ТестовыеСлучаи.Добавить(ТестовыйСлучай("-f -x", "-x", "-f"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("-a", "", "-a"));

	Для каждого Тест Из ТестовыеСлучаи Цикл
		НачальноеКоличество = Тест.Аргументы.Количество();
			
		Лог.Отладка("Проверяю тестовый случай: %1", СтрСоединить(Тест.Аргументы, " "));
		

		Для каждого КлючЗначение Из ИндексАргументов Цикл
		
			Парсер_Аргумента = Новый АргументыПарсера(КлючЗначение.Значение);
			Утверждения.ПроверитьРавенство(КлючЗначение.Ключ, Парсер_Аргумента.ВСтроку(), "Парсер аргументов должен быть равен "+ КлючЗначение.Ключ);

			Контекст = Новый КонтекстПарсеров();
			Контекст.СбросОпций = Истина;
			Результат = Парсер_Аргумента.Поиск(Тест.Аргументы, Контекст);
			
			Утверждения.ПроверитьРавенство(НачальноеКоличество, Тест.Аргументы.Количество(), "Количество аргументов не должно измениться");
				
			Утверждения.ПроверитьИстину(Результат.Найден, "Аргумент должен быть найден");
			Утверждения.ПроверитьРавенство(1, Контекст.Аргументы[Парсер_Аргумента.Аргумент].Количество(), "Количество результатов должно быть 1");
			Утверждения.ПроверитьРавенство(Контекст.Аргументы[Парсер_Аргумента.Аргумент][0], Тест.ЗначениеОпции, "Ожидаемые результаты должны быть равны");
			Утверждения.ПроверитьРавенство(СтрСоединить(Результат.Аргументы, " "), СтрСоединить(Тест.АргументыВыхода, " "), "Аргументы выходные должны быть равны");
			
		КонецЦикла;

	КонецЦикла;
КонецПроцедуры

Функция Аргумент(Наименование, ЗначениеПоУмолчанию)
	Возврат Новый ПараметрКоманды("Аргумент", Наименование,  ЗначениеПоУмолчанию, "Тестовый параметр f")
КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.lib.cli_class_arg");
//Лог.УстановитьУровень(УровниЛога.Отладка);