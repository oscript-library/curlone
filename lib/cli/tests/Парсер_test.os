#использовать "../src/core"
#Использовать asserts
#Использовать logos

Перем юТест;
Перем Лог;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт

	юТест = Тестирование;
	
	ИменаТестов = Новый Массив;
	
	ИменаТестов.Добавить("ТестДолжен_ПроверитьПарсинг");
	// ИменаТестов.Добавить("ТестДолжен_ПроверитьПарсингОпций");
	// ИменаТестов.Добавить("ТестДолжен_ПроверитьПарсингМассивовОпций");
	
	Возврат ИменаТестов;

КонецФункции

Процедура ТестДолжен_ПроверитьПарсинг() Экспорт

	опция_a = Опция("a all", "");
	опция_b = Опция("b ball", "");
	
	ИндексОпций = Новый Соответствие;
	ИндексОпций.Вставить("-a", опция_a);
	ИндексОпций.Вставить("--all", опция_a);
	ИндексОпций.Вставить("-b", опция_b);
	ИндексОпций.Вставить("--ball", опция_b);

	Опции = Новый Соответствие;
	Опции.Вставить(опция_a, опция_a);
	Опции.Вставить(опция_b, опция_b);


	аргумент_ARG = Аргумент("ARG", "");

	Аргументы = Новый Соответствие;
	Аргументы.Вставить(аргумент_ARG, аргумент_ARG);

	ИндексАргументов = Новый Соответствие;
	ИндексАргументов.Вставить("ARG", аргумент_ARG);

	ТестовыеСлучаи = Новый Массив;
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("", "")); 
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("-a", "S1 -a (S2)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("--all", "S1 -a (S2)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("-a -b", "S1 -a S2
													|S2 -b (S3)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("-a -b", "S1 -a S2
													|S2 -b (S3)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("-a | -b", "S1 -a (S2)
													|S1 -b (S3)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("-a...", "S1 -a (S2)
													|(S2) -a (S2)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("[-a...]", "(S1) -a (S2)
													|(S2) -a (S2)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("[-a]...", "(S1) -a (S2)
													|(S2) -a (S2)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("-a -b | ARG", "S1 -a S2
													|S2 -b (S3)
													|S2 ARG (S4)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("-a (-b | ARG)", "S1 -a S2
													|S2 -b (S3)
													|S2 ARG (S4)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("(-a -b) | ARG...", "S1 -a S2
													|S1 ARG (S4)
													|S2 -b (S3)
													|(S4) ARG (S4)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("-ab", "S1 -ab (S2)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("-a -- ARG", "S1 -a S2
													|S2 -- S3
													|S3 ARG (S4)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("[OPTIONS]", "(S1) -ab (S2)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("[ОПЦИИ]", "(S1) -ab (S2)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("[ANY]", "(S1) -abARG (S2)"));
	ТестовыеСлучаи.Добавить(ТестовыйСлучай("[ЛЮБОЙ]", "(S1) -abARG (S2)"));

	Для каждого Тест Из ТестовыеСлучаи Цикл
		fsm = Новый ВыборСовпадений();
		Лог.Отладка("Проверяю тестовый случай: %1", Тест.Спек);
		Лог.Отладка("Строка состояния: %1", Тест.Соединения);
	
		Лексер = Новый Лексер(Тест.Спек).Прочитать();
		
		Утверждения.ПроверитьЛожь(Лексер.ЕстьОшибка(), "Лексер должен отработать успешно. Ошибка: " + Лексер.ПолучитьИнформациюОбОшибке());

		ТокеныПарсера = Лексер.ПолучитьТокены();
	
		ПараметрыПарсера =  Новый Структура;
		ПараметрыПарсера.Вставить("Спек", Тест.Спек);	
		ПараметрыПарсера.Вставить("Опции", Опции);	
		ПараметрыПарсера.Вставить("Аргументы", Аргументы);	
		ПараметрыПарсера.Вставить("ОпцииИндекс", ИндексОпций);	
		ПараметрыПарсера.Вставить("АргументыИндекс", ИндексАргументов);	
		
		парсер = Новый Парсер(ТокеныПарсера, ПараметрыПарсера);
		НачальноеСостояние = парсер.Прочитать();
		
		СтрокаПути = fsm.СгенеритьСтрокуПути(НачальноеСостояние);
		
		МассивОжиданийСтрок = СтрРазделить(Тест.Соединения, Символы.ПС);
		Для каждого ОжидаемаяСтрока Из МассивОжиданийСтрок Цикл
			
			Утверждения.ПроверитьВхождение(СтрокаПути, ОжидаемаяСтрока, "Ожидали, что все строки будут найдены. Тестовый спек: " + Тест.Спек);
		
		КонецЦикла;

	КонецЦикла;

КонецПроцедуры

Функция Опция(Наименование, ЗначениеПоУмолчанию)
	Возврат Новый ПараметрКоманды("опция", Наименование,  ЗначениеПоУмолчанию, "Тестовый параметр f");
КонецФункции

Функция Аргумент(Наименование, ЗначениеПоУмолчанию)
	Возврат Новый ПараметрКоманды("Аргумент", Наименование,  ЗначениеПоУмолчанию, "Тестовый параметр f");
КонецФункции

Функция ТестовыйСлучай(Знач Спек, Знач Соединения)
	
	Тест = Новый Структура;
	Тест.Вставить("Спек",Спек);
	Тест.Вставить("Соединения",Соединения);

	Возврат Тест;
КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.lib.spec_parse");
//Лог.УстановитьУровень(УровниЛога.Отладка);