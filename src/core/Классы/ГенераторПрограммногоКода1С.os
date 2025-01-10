#Использовать "../../internal"

Перем Результат; // Строка
Перем ИсходящиеОшибки; // Массив из Структура:
                       //   * Текст - Строка - Текст ошибки
                       //   * КритичнаяОшибка - Булево - Признак критичиной ошибки 
Перем ОписаниеЗапроса; // см. ОписаниеЗапроса

Перем ИмяПараметраЗаголовки;  // Строка
Перем ИмяПараметраСоединение; // Строка
Перем ИмяПараметраЗащищенноеСоединение; // Строка
Перем ИмяПараметраHTTPЗапрос; // Строка
Перем ИмяПараметраHTTPОтвет; // Строка
Перем ИмяПараметраПрокси; // Строка
Перем ИмяПараметраТелоЗапросаСтрока; // Строка

Перем ПрочитанныеФайлы; // Массив из Структура:
                        //   - ПередаваемыйФайл - см. ПередаваемыйФайл
                        //   - ИмяПеременной - Строка
Перем ИспользуетсяПрокси; // Булево
Перем ТелоЗапросаСтрока; // Строка
Перем ЕстьТекстовоеТелоЗапроса; // Булево
Перем ВызванМетодПоТекущемуURL; // Булево

#Область ПрограммныйИнтерфейс

// Генерирует программный код из переданного описания запроса
//
// Параметры:
//   Описание - см. ОписаниеЗапроса - Описание запроса
//   Ошибки - Неопределено - Выходной параметр. Передает обнаруженные при конвертации ошибки:
//      Массив из Структура:
//        * Текст - Строка - Текст ошибки
//        * Критичная - Булево - Признак критичиной ошибки 
//
// Возвращаемое значение:
//   Строка - Программный код
Функция Получить(Описание, Ошибки = Неопределено) Экспорт

	ОписаниеЗапроса = Описание;

	Результат = "";
	ИспользуетсяПрокси = Ложь;
	ЕстьТекстовоеТелоЗапроса = Ложь;
	ТелоЗапросаСтрока = "";
	ВызванМетодПоТекущемуURL = Ложь;	
	ПрочитанныеФайлы.Очистить();

	Если Ошибки = Неопределено Тогда
		Ошибки = Новый Массив();
	КонецЕсли;

	ИсходящиеОшибки = Ошибки;

	ВывестиЗаголовки();
	ВывестиЧтениеФайлов();
	ВывестиИнициализациюТекстовогоТелаЗапроса();
	ВывестиЗащищенноеСоединение();
	ВывестиИнициализациюПрокси();
		
	КоличествоURL = ОписаниеЗапроса.АдресаРесурсов.Количество();
	НомерЗапроса = 0;
	Для Каждого ОписаниеРесурса Из ОписаниеЗапроса.АдресаРесурсов Цикл
		
		НомерЗапроса = НомерЗапроса + 1;
		СтруктураURL = Новый ПарсерURL(ОписаниеРесурса.URL);
		ВызванМетодПоТекущемуURL = Ложь;

		ВывестиПустуюСтроку();
	
		Если КоличествоURL > 1 Тогда
			ВывестиСтроку(СтрШаблон("// Запрос %1. " + Лев(ОписаниеРесурса.URL, 100), НомерЗапроса));
		КонецЕсли;

		Если ОбщегоНазначения.ЭтоHTTP(СтруктураURL.Схема) Тогда
			ВывестиHTTPСоединение(СтруктураURL);
			ВывестиВызовHTTPМетодаДляКаждогоФайла(ОписаниеРесурса);

			Если Не ВызванМетодПоТекущемуURL Тогда
				ВывестиHTTPЗапрос(СтруктураURL);
				ВывестиУстановкуТелаЗапроса(ОписаниеРесурса);				
				ВывестиВызовHTTPМетода(ОписаниеРесурса);
			КонецЕсли;
		ИначеЕсли ОбщегоНазначения.ЭтоFTP(СтруктураURL.Схема) Тогда
			ВывестиFTPСоединение(СтруктураURL);
			ВывестиВызовFTPМетода(ОписаниеРесурса, СтруктураURL);
		Иначе
			ТекстОшибки = СтрШаблон("Протокол ""%1"" не поддерживается", СтруктураURL.Схема);
			ИсходящиеОшибки.Добавить(ОбщегоНазначения.НоваяКритичнаяОшибка(ТекстОшибки));
		КонецЕсли;

		Если ОбщегоНазначения.ЕстьКритичныеОшибки(ИсходящиеОшибки) Тогда
			Возврат "";
		КонецЕсли;

	КонецЦикла;

	Возврат СокрЛП(Результат);

КонецФункции

Функция ПоддерживаемыеПротоколы() Экспорт
	Протоколы = Новый Массив();
	Протоколы.Добавить(ПротоколыURL.HTTP);
	Протоколы.Добавить(ПротоколыURL.HTTPS);
	Протоколы.Добавить(ПротоколыURL.FTP);
	Протоколы.Добавить(ПротоколыURL.FTPS);
	Возврат Протоколы;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриСозданииОбъекта()

	ИмяПараметраЗаголовки = "Заголовки";
	ИмяПараметраСоединение = "Соединение";
	ИмяПараметраЗащищенноеСоединение = "ЗащищенноеСоединение";
	ИмяПараметраHTTPЗапрос = "HTTPЗапрос";
	ИмяПараметраHTTPОтвет = "HTTPОтвет";
	ИмяПараметраПрокси = "Прокси";
	ИмяПараметраТелоЗапросаСтрока = "ТелоЗапроса";

	ПрочитанныеФайлы = Новый Массив;
	ИспользуетсяПрокси = Ложь;
	ЕстьТекстовоеТелоЗапроса = Ложь;
	ТелоЗапросаСтрока = "";
	ВызванМетодПоТекущемуURL = Ложь;

КонецПроцедуры

Функция ПолучитьПорт(СтруктураURL)

	Порт = СтруктураURL.Порт;
	Если Не ЗначениеЗаполнено(Порт) Тогда
		Если СтруктураURL.Схема = ПротоколыURL.HTTPS Тогда
			Порт = 443;
		ИначеЕсли СтруктураURL.Схема = ПротоколыURL.HTTP Тогда
			Порт = 80;
		ИначеЕсли СтруктураURL.Схема = ПротоколыURL.FTPS Тогда
			Порт = 990;
		ИначеЕсли СтруктураURL.Схема = ПротоколыURL.FTP Тогда
			Порт = 21;
		КонецЕсли;
	КонецЕсли;

	Возврат Формат(Порт, "ЧГ=");

КонецФункции

Процедура ВывестиЗащищенноеСоединение()
	
	ИспользуетсяЗащищенноеСоединение = Ложь;

	Для Каждого ОписаниеРесурса Из ОписаниеЗапроса.АдресаРесурсов Цикл		
		СтруктураURL = Новый ПарсерURL(ОписаниеРесурса.URL);
		ИспользуетсяЗащищенноеСоединение = ИспользуетсяЗащищенноеСоединение(СтруктураURL);
		Если ИспользуетсяЗащищенноеСоединение Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;

	Если Не ИспользуетсяЗащищенноеСоединение Тогда
		Возврат;
	КонецЕсли;

	ВывестиПустуюСтроку();

	// Сертификат клиента
	ИмяПараметраСертификатаКлиента = "";
	Если ЗначениеЗаполнено(ОписаниеЗапроса.ИмяФайлаСертификатаКлиента) Тогда
		ИмяПараметраСертификатаКлиента = "СертификатКлиента";

		ПараметрыФункции = Новый Массив;
		ПараметрыФункции.Добавить(ОбернутьКавычками(ОписаниеЗапроса.ИмяФайлаСертификатаКлиента));
		ПараметрыФункции.Добавить(ОбернутьКавычками(ОписаниеЗапроса.ПарольСертификатаКлиента, Истина));

		ВывестиСтроку(СтрШаблон("%1 = Новый СертификатКлиентаФайл(%2);", 
			ИмяПараметраСертификатаКлиента, 
			ПараметрыФункцииВСтроку(ПараметрыФункции)));
	КонецЕсли;

	// Сертификаты УЦ
	ИмяПараметраСертификатыУдостоверяющихЦентров = "СертификатыУдостоверяющихЦентров";
	Если ОписаниеЗапроса.ИспользоватьСертификатыУЦИзХранилищаОС Тогда
		ВывестиСтроку(СтрШаблон("%1 = Новый СертификатыУдостоверяющихЦентровОС();", ИмяПараметраСертификатыУдостоверяющихЦентров));
	ИначеЕсли ЗначениеЗаполнено(ОписаниеЗапроса.ИмяФайлаСертификатовУЦ) Тогда
		ВывестиСтроку(СтрШаблон("%1 = Новый СертификатыУдостоверяющихЦентровФайл(%2);", 
			ИмяПараметраСертификатыУдостоверяющихЦентров,
			ОбернутьКавычками(ОписаниеЗапроса.ИмяФайлаСертификатовУЦ)));		
	Иначе
		ИмяПараметраСертификатыУдостоверяющихЦентров = "";
	КонецЕсли;

	// Защищенное соединение
	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(ИмяПараметраСертификатаКлиента);
	ПараметрыФункции.Добавить(ИмяПараметраСертификатыУдостоверяющихЦентров);
	
	ВывестиСтроку(СтрШаблон("%1 = Новый ЗащищенноеСоединениеOpenSSL(%2);", 
		ИмяПараметраЗащищенноеСоединение,
		ПараметрыФункцииВСтроку(ПараметрыФункции)));
	
КонецПроцедуры

Процедура ВывестиИнициализациюПрокси()

	ИспользуетсяПрокси = ЗначениеЗаполнено(ОписаниеЗапроса.ПроксиСервер);

	Если Не ИспользуетсяПрокси Тогда
		Возврат;
	КонецЕсли;

	ДопустимыеПротоколыПрокси = Новый Массив();
	ДопустимыеПротоколыПрокси.Добавить(ПротоколыURL.HTTP);
	ДопустимыеПротоколыПрокси.Добавить(ПротоколыURL.HTTPS);
	ДопустимыеПротоколыПрокси.Добавить(ПротоколыURL.FTP);
	ДопустимыеПротоколыПрокси.Добавить(ПротоколыURL.FTPS);

	Если ДопустимыеПротоколыПрокси.Найти(ОписаниеЗапроса.ПроксиПротокол) = Неопределено Тогда
		ТекстОшибки = СтрШаблон("Прокси протокол %1 не поддерживается", ОписаниеЗапроса.ПроксиПротокол);
		ИсходящиеОшибки.Добавить(ОбщегоНазначения.НоваяКритичнаяОшибка(ТекстОшибки));
		Возврат;
	КонецЕсли;

	ВывестиПустуюСтроку();
	ВывестиСтроку(СтрШаблон("%1 = Новый ИнтернетПрокси();", ИмяПараметраПрокси));

	ИспользоватьАутентификациюОС = ОписаниеЗапроса.ТипАутентификацииПрокси = ТипыАутентификацииПрокси.NTLM;

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(ОбернутьКавычками(ОписаниеЗапроса.ПроксиПротокол));
	ПараметрыФункции.Добавить(ОбернутьКавычками(ОписаниеЗапроса.ПроксиСервер));
	ПараметрыФункции.Добавить(Формат(ОписаниеЗапроса.ПроксиПорт, "ЧГ="));
	ПараметрыФункции.Добавить(ОбернутьКавычками(ОписаниеЗапроса.ПроксиПользователь, Истина));
	ПараметрыФункции.Добавить(ОбернутьКавычками(ОписаниеЗапроса.ПроксиПароль, Истина));
	ПараметрыФункции.Добавить(?(ИспользоватьАутентификациюОС, "", "Ложь")); // Значение по умолчанию Истина

	ВывестиСтроку(СтрШаблон("%1.Установить(%2);", ИмяПараметраПрокси, ПараметрыФункцииВСтроку(ПараметрыФункции)));

КонецПроцедуры

Процедура ВывестиHTTPСоединение(СтруктураURL)

	Таймаут = 0;
	Если ЗначениеЗаполнено(ОписаниеЗапроса.Таймаут) И ЗначениеЗаполнено(ОписаниеЗапроса.ТаймаутСоединения) Тогда
		Таймаут = ОписаниеЗапроса.Таймаут + ОписаниеЗапроса.ТаймаутСоединения;
	КонецЕсли;

	ИспользуетсяЗащищенноеСоединение = ИспользуетсяЗащищенноеСоединение(СтруктураURL);

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(ОбернутьКавычками(СтруктураURL.Сервер));
	ПараметрыФункции.Добавить(ПолучитьПорт(СтруктураURL));
	ПараметрыФункции.Добавить(ОбернутьКавычками(ОписаниеЗапроса.ИмяПользователя, Истина));
	ПараметрыФункции.Добавить(ОбернутьКавычками(ОписаниеЗапроса.ПарольПользователя, Истина));
	ПараметрыФункции.Добавить(?(ИспользуетсяПрокси, ИмяПараметраПрокси, ""));
	ПараметрыФункции.Добавить(Формат(Таймаут, "ЧРД=.; ЧГ="));
	ПараметрыФункции.Добавить(?(ИспользуетсяЗащищенноеСоединение, ИмяПараметраЗащищенноеСоединение, ""));

	ВывестиСтроку(СтрШаблон(ИмяПараметраСоединение + " = Новый HTTPСоединение(%1);", 
		ПараметрыФункцииВСтроку(ПараметрыФункции)));

КонецПроцедуры

Процедура ВывестиFTPСоединение(СтруктураURL)

	Если ЗначениеЗаполнено(ОписаниеЗапроса.FTPАдресОбратногоСоединения)
		И Не ОписаниеЗапроса.FTPАдресОбратногоСоединения = "-" Тогда
		ИсходящиеОшибки.Добавить(ОбщегоНазначения.НоваяОшибка("Адрес из опции -P, --ftp-port было проигнорировано"));
	КонецЕсли;

	Таймаут = 0;
	Если ЗначениеЗаполнено(ОписаниеЗапроса.Таймаут) И ЗначениеЗаполнено(ОписаниеЗапроса.ТаймаутСоединения) Тогда
		Таймаут = ОписаниеЗапроса.Таймаут + ОписаниеЗапроса.ТаймаутСоединения;
	КонецЕсли;

	ИспользуетсяЗащищенноеСоединение = ИспользуетсяЗащищенноеСоединение(СтруктураURL);

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(ОбернутьКавычками(СтруктураURL.Сервер));
	ПараметрыФункции.Добавить(ПолучитьПорт(СтруктураURL));
	ПараметрыФункции.Добавить(ОбернутьКавычками(ОписаниеЗапроса.ИмяПользователя, Истина));
	ПараметрыФункции.Добавить(ОбернутьКавычками(ОписаниеЗапроса.ПарольПользователя, Истина));
	ПараметрыФункции.Добавить(?(ИспользуетсяПрокси, ИмяПараметраПрокси, ""));
	ПараметрыФункции.Добавить(?(ОписаниеЗапроса.FTPПассивныйРежимСоединения, Истина, ""));
	ПараметрыФункции.Добавить(Формат(Таймаут, "ЧРД=.; ЧГ="));
	ПараметрыФункции.Добавить(?(ИспользуетсяЗащищенноеСоединение, ИмяПараметраЗащищенноеСоединение, ""));

	ВывестиСтроку(СтрШаблон(ИмяПараметраСоединение + " = Новый FTPСоединение(%1);", 
		ПараметрыФункцииВСтроку(ПараметрыФункции)));

КонецПроцедуры

Процедура ВывестиЗаголовки()
	
	Если ОписаниеЗапроса.Заголовки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ВывестиСтроку(ИмяПараметраЗаголовки + " = Новый Соответствие();");

	Для Каждого Заголовок Из ОписаниеЗапроса.Заголовки Цикл
		СтрокаЗаголовка = СтрШаблон("%1.Вставить(""%2"", ""%3"");", 
			ИмяПараметраЗаголовки, 
			Заголовок.Ключ, 
			ЭкранироватьКавычки(Заголовок.Значение));
		ВывестиСтроку(СтрокаЗаголовка);
	КонецЦикла;

КонецПроцедуры

Процедура ВывестиЧтениеФайлов()

	ПрочитанныеФайлы.Очистить();

	НомерФайла = 1;
	Для Каждого ПередаваемыйФайл Из ОписаниеЗапроса.Файлы Цикл

		Если Не (ПередаваемыйФайл.ПрочитатьСодержимое 
				Или ПередаваемыйФайл.Назначение = НазначенияПередаваемыхДанных.СтрокаЗапроса) Тогда
			Продолжить;
		КонецЕсли;

		ИмяПеременной = "ТекстовыеДанныеИзФайла_" + Формат(НомерФайла, "ЧГ=");

		ВывестиПустуюСтроку();

		Шаблон = "ТекстовыйДокумент = Новый ТекстовыйДокумент();
			|ТекстовыйДокумент.Прочитать(%2);
			|%1 = ТекстовыйДокумент.ПолучитьТекст();";

		Если ПередаваемыйФайл.УдалятьПереносыСтрок Тогда
			Шаблон = Шаблон + "
			|%1 = СтрЗаменить(%1, Символы.ПС, """");
			|%1 = СтрЗаменить(%1, Символы.ВК, """");";
		КонецЕсли;

		Если ПередаваемыйФайл.КодироватьСодержимое Тогда
			Шаблон = Шаблон + "
			|%1 = КодироватьСтроку(%1, СпособКодированияСтроки.URLВКодировкеURL);";
		КонецЕсли;

		Если ЗначениеЗаполнено(ПередаваемыйФайл.Ключ) Тогда
			Шаблон = Шаблон + "
			|%1 = """ + ПередаваемыйФайл.Ключ + "="" + %1;";
		КонецЕсли;

		Текст = СтрШаблон(Шаблон, ИмяПеременной, ОбернутьКавычками(ПередаваемыйФайл.ИмяФайла));

		ВывестиСтроку(Текст);
	
		ПрочитанныйФайл = Новый Структура("ПередаваемыйФайл, ИмяПеременной", ПередаваемыйФайл, ИмяПеременной);
		ПрочитанныеФайлы.Добавить(ПрочитанныйФайл);

		НомерФайла = НомерФайла + 1;
	КонецЦикла;

КонецПроцедуры

Процедура ВывестиHTTPЗапрос(СтруктураURL)

	ПараметрыФункции = Новый Массив;
	
	АдресРесурсаКод = ПолучитьКодСборкиАдресаРесурса(СтруктураURL);
	Если СтрЧислоСтрок(АдресРесурсаКод) > 1 Тогда
		ВывестиПустуюСтроку();
		ВывестиСтроку(СтрШаблон("АдресРесурса = %1;", АдресРесурсаКод));
		ПараметрыФункции.Добавить("АдресРесурса");
	Иначе
		ПараметрыФункции.Добавить(АдресРесурсаКод);
	КонецЕсли;

	Если ОписаниеЗапроса.Заголовки.Количество() Тогда
		ПараметрыФункции.Добавить(ИмяПараметраЗаголовки);
	КонецЕсли;

	ВывестиСтроку(СтрШаблон(ИмяПараметраHTTPЗапрос + " = Новый HTTPЗапрос(%1);", ПараметрыФункцииВСтроку(ПараметрыФункции)));

КонецПроцедуры

Функция ПолучитьКодСборкиАдресаРесурса(СтруктураURL)

	Кавычка = """";
	РазделительПараметровЗапроса = "&";
	КонкатенацияСПереносомСтрокиИАмперсандом = "
	|	+ ""&"" + ";
	КонкатенацияСПереносомСтроки = "
	|	+ ";

	КавычкаЗакрыта = Ложь;
	Код = Кавычка + СтруктураURL.Путь;
	СтрокаЗапроса = СобратьИсходнуюСтрокуЗапроса(СтруктураURL);

	Для Каждого ПередаваемыйТекст Из ОписаниеЗапроса.ОтправляемыеТекстовыеДанные Цикл
		Если ПередаваемыйТекст.Назначение = НазначенияПередаваемыхДанных.СтрокаЗапроса Тогда
			СтрокаЗапроса = СтрокаЗапроса 
				+ ?(ЗначениеЗаполнено(СтрокаЗапроса), РазделительПараметровЗапроса, "")
				+ ПередаваемыйТекст.Значение;
		КонецЕсли;
	КонецЦикла;

	КодПрочитанныхФайлов = "";	
	Для Каждого ПрочитанныйФайл Из ПрочитанныеФайлы Цикл
		Если ПрочитанныйФайл.ПередаваемыйФайл.Назначение = НазначенияПередаваемыхДанных.СтрокаЗапроса Тогда
			КодПрочитанныхФайлов = КодПрочитанныхФайлов 
				+ ?(КодПрочитанныхФайлов = "", "", КонкатенацияСПереносомСтрокиИАмперсандом)
				+ ПрочитанныйФайл.ИмяПеременной;
		КонецЕсли;
	КонецЦикла;

	Если ЗначениеЗаполнено(СтрокаЗапроса) 
		Или ЗначениеЗаполнено(КодПрочитанныхФайлов) Тогда
		Код = Код + "?";
	КонецЕсли;

	Код = Код + СтрокаЗапроса;

	Если ЗначениеЗаполнено(КодПрочитанныхФайлов) Тогда
		Код = Код + Кавычка 
			+ ?(ЗначениеЗаполнено(СтрокаЗапроса), 
				КонкатенацияСПереносомСтрокиИАмперсандом, 
				КонкатенацияСПереносомСтроки) 
			+ КодПрочитанныхФайлов;
		КавычкаЗакрыта = Истина;
	КонецЕсли;

	Если ЗначениеЗаполнено(СтруктураURL.Фрагмент) Тогда
		Фрагмент = "#" + СтруктураURL.Фрагмент;
		Если КавычкаЗакрыта Тогда
			Код = Код + " 
			|	+ " + ОбернутьКавычками(Фрагмент);
		Иначе
			Код = Код + Фрагмент;
		КонецЕсли;
	КонецЕсли;

	Если Не КавычкаЗакрыта Тогда
		Код = Код + Кавычка;
	КонецЕсли;

	Возврат Код;

КонецФункции

Процедура ВывестиИнициализациюТекстовогоТелаЗапроса()

	ЭлементыТелаЗапросаДляВывода = Новый Массив;
	КонкатенацияСПереносомСтрокиИРазделителя = "
	|	+ ""%1"" + ";
	КонкатенацияСПереносомСтроки = "
	|	+ ";
	
	ОтправляемаяСтрока = "";
	Для Каждого ПередаваемыйТекст Из ОписаниеЗапроса.ОтправляемыеТекстовыеДанные Цикл
		Если ПередаваемыйТекст.Назначение = НазначенияПередаваемыхДанных.ТелоЗапроса Тогда
			ОтправляемаяСтрока = ОтправляемаяСтрока
				+ ?(ОтправляемаяСтрока = "", "", ПередаваемыйТекст.РазделительТелаЗапроса)
				+ ПередаваемыйТекст.Значение;
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ОтправляемаяСтрока) Тогда
		ЭлементыТелаЗапросаДляВывода.Добавить(ОбернутьКавычками(ОтправляемаяСтрока));
	КонецЕсли;

	Для Каждого ПрочитанныйФайл Из ПрочитанныеФайлы Цикл
		Если ПрочитанныйФайл.ПередаваемыйФайл.Назначение = НазначенияПередаваемыхДанных.ТелоЗапроса Тогда
			Если ЭлементыТелаЗапросаДляВывода.Количество() Тогда
				Если Не ПустаяСтрока(ПрочитанныйФайл.ПередаваемыйФайл.РазделительТелаЗапроса) Тогда
					ЭлементыТелаЗапросаДляВывода.Добавить(
						СтрШаблон(КонкатенацияСПереносомСтрокиИРазделителя, ПрочитанныйФайл.ПередаваемыйФайл.РазделительТелаЗапроса)
						+ ПрочитанныйФайл.ИмяПеременной);
				Иначе
					ЭлементыТелаЗапросаДляВывода.Добавить(КонкатенацияСПереносомСтроки + ПрочитанныйФайл.ИмяПеременной);
				КонецЕсли;
			Иначе
				ЭлементыТелаЗапросаДляВывода.Добавить(ПрочитанныйФайл.ИмяПеременной);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

	КоличествоЭлементов = ЭлементыТелаЗапросаДляВывода.Количество();
	Если КоличествоЭлементов = 0 Тогда
		Возврат;
	КонецЕсли;

	ЕстьТекстовоеТелоЗапроса = Истина;

	Если КоличествоЭлементов = 1 Тогда
		ТелоЗапросаСтрока = ЭлементыТелаЗапросаДляВывода[0];
	Иначе
		ВывестиПустуюСтроку();
		ВывестиСтроку(СтрШаблон("%1 = %2;", ИмяПараметраТелоЗапросаСтрока, СтрСоединить(ЭлементыТелаЗапросаДляВывода)));
	КонецЕсли;

КонецПроцедуры


Процедура ВывестиУстановкуТелаЗапроса(ОписаниеРесурса)

	ВывестиУстановкуТелаЗапросаТекстовымиДанными();
	ВывестиУстановкуТелаЗапросаИзФайла(ОписаниеРесурса);

КонецПроцедуры

Процедура ВывестиВызовHTTPМетодаДляКаждогоФайла(ОписаниеРесурса)

	ДлинаИмениФайлаВКомментарии = 100;

	ВсеФайлы = Новый Массив();
	ОбщегоНазначения.ДополнитьМассив(ВсеФайлы, ОписаниеЗапроса.Файлы);
	ОбщегоНазначения.ДополнитьМассив(ВсеФайлы, ОписаниеРесурса.Файлы);

	ПередаваемыеФайлы = Новый Массив();
	Для Каждого ПередаваемыйФайл Из ВсеФайлы Цикл

		Если ПередаваемыйФайл.ОтправлятьОтдельно 
			И Не ПередаваемыйФайл.ПрочитатьСодержимое 
			И ПередаваемыйФайл.Назначение = НазначенияПередаваемыхДанных.ТелоЗапроса Тогда
			ПередаваемыеФайлы.Добавить(ПередаваемыйФайл);
		КонецЕсли;

	КонецЦикла;

	КоличествоФайлов = ПередаваемыеФайлы.Количество();
	НомерФайла = 0;
	Для Каждого ПередаваемыйФайл Из ПередаваемыеФайлы Цикл

		НомерФайла = НомерФайла + 1;

		Если КоличествоФайлов > 1 Тогда
			ИмяФайла = Лев(ПередаваемыйФайл.ИмяФайла, ДлинаИмениФайлаВКомментарии);
			ВывестиПустуюСтроку();
			ВывестиСтроку(СтрШаблон("// Передача файла %1. %2", НомерФайла, ИмяФайла));
		КонецЕсли;

		СтруктураURL = Новый ПарсерURL(ОписаниеРесурса.URL);
		Если ПередаваемыйФайл.ДобавлятьИмяФайлаКURL Тогда
			СтруктураURL.Путь = ДобавитьИмяФайлаКURL(ПередаваемыйФайл, СтруктураURL.Путь);
		КонецЕсли;

		ВывестиHTTPЗапрос(СтруктураURL);

		ВывестиСтроку(СтрШаблон("%1.УстановитьИмяФайлаТела(%2);", 
			ИмяПараметраHTTPЗапрос, 
			ОбернутьКавычками(ПередаваемыйФайл.ИмяФайла)));

		ВывестиВызовHTTPМетода(ОписаниеРесурса);

	КонецЦикла;

КонецПроцедуры

Процедура ВывестиУстановкуТелаЗапросаТекстовымиДанными()
	
	Если Не ЕстьТекстовоеТелоЗапроса Тогда
		Возврат;
	КонецЕсли;

	ВывестиСтроку(СтрШаблон("%1.УстановитьТелоИзСтроки(%2);",
		ИмяПараметраHTTPЗапрос,
		?(ЗначениеЗаполнено(ТелоЗапросаСтрока), ТелоЗапросаСтрока, ИмяПараметраТелоЗапросаСтрока)));

КонецПроцедуры

Процедура ВывестиУстановкуТелаЗапросаИзФайла(ОписаниеРесурса)

	Файлы = Новый Массив();
	ОбщегоНазначения.ДополнитьМассив(Файлы, ОписаниеЗапроса.Файлы);
	ОбщегоНазначения.ДополнитьМассив(Файлы, ОписаниеРесурса.Файлы);

	ЭтоПервыйФайл = Истина;
	Для Каждого ПередаваемыйФайл Из Файлы Цикл

		Если ПередаваемыйФайл.ПрочитатьСодержимое 
			Или ПередаваемыйФайл.ОтправлятьОтдельно
			Или Не ПередаваемыйФайл.Назначение = НазначенияПередаваемыхДанных.ТелоЗапроса Тогда
			Продолжить;
		КонецЕсли;

		ВывестиСтроку(СтрШаблон("%1%2.УстановитьИмяФайлаТела(%3);", 
			?(ЭтоПервыйФайл, "", "// "),
			ИмяПараметраHTTPЗапрос, 
			ОбернутьКавычками(ПередаваемыйФайл.ИмяФайла)));

		ЭтоПервыйФайл = Ложь;

	КонецЦикла;

КонецПроцедуры

Процедура ВывестиВызовHTTPМетода(ОписаниеРесурса)

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(ОбернутьКавычками(ОписаниеРесурса.Метод));
	ПараметрыФункции.Добавить(ИмяПараметраHTTPЗапрос);
	ПараметрыФункции.Добавить(ОбернутьКавычками(ОписаниеРесурса.ИмяВыходногоФайла, Истина));

	ВывестиПустуюСтроку();
	ВывестиСтроку(СтрШаблон("%1 = %2.ВызватьHTTPМетод(%3);", 
		ИмяПараметраHTTPОтвет,
		ИмяПараметраСоединение,
		ПараметрыФункцииВСтроку(ПараметрыФункции)));

	ВызванМетодПоТекущемуURL = Истина;

КонецПроцедуры

Процедура ВывестиВызовFTPМетода(ОписаниеРесурса, СтруктураURL)

	ВывестиПустуюСтроку();

	Если ОписаниеРесурса.Метод = "RETR" Тогда
		ВывестиВызовПолученияФайлаFTP(ОписаниеРесурса, СтруктураURL);
	ИначеЕсли ОписаниеРесурса.Метод = "STOR" Тогда
		ВывестиВызовОтправкиФайлаFTP(ОписаниеРесурса, СтруктураURL);
	ИначеЕсли ОписаниеРесурса.Метод = "NLST" Тогда
		ВывестиПолучениеСпискаФайловВДиректорииFTP(СтруктураURL);
	ИначеЕсли ОписаниеРесурса.Метод = "HEAD" Тогда
		ВывестиПолучениеЗаголовковФайлаFTP(СтруктураURL);
	Иначе
		Если ЗначениеЗаполнено(ОписаниеРесурса.Метод) Тогда
			ТекстОшибки = СтрШаблон("FTP метод '%1' не поддерживается", ОписаниеРесурса.Метод);
		Иначе
			ТекстОшибки = "Не определен FTP метод";
		КонецЕсли;

		ИсходящиеОшибки.Добавить(ОбщегоНазначения.НоваяКритичнаяОшибка(ТекстОшибки));
	КонецЕсли;

КонецПроцедуры

Процедура ВывестиВызовПолученияФайлаFTP(ОписаниеРесурса, СтруктураURL)

	ИмяВыходногоФайла = ?(ЗначениеЗаполнено(ОписаниеРесурса.ИмяВыходногоФайла), ОписаниеРесурса.ИмяВыходногоФайла, "path/to/file");

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(ОбернутьКавычками(СтруктураURL.Путь));
	ПараметрыФункции.Добавить(ОбернутьКавычками(ИмяВыходногоФайла));

	ВывестиСтроку(СтрШаблон("%1.Получить(%2);", 
		ИмяПараметраСоединение,
		ПараметрыФункцииВСтроку(ПараметрыФункции)));

КонецПроцедуры

Процедура ВывестиВызовОтправкиФайлаFTP(ОписаниеРесурса, СтруктураURL)

	Для Каждого ПередаваемыйФайл Из ОписаниеРесурса.Файлы Цикл
		Если Не ПередаваемыйФайл.ОтправлятьОтдельно Тогда
			Продолжить;
		КонецЕсли;

		АдресРесурса = СтруктураURL.Путь;
		Если ПередаваемыйФайл.ДобавлятьИмяФайлаКURL Тогда
			АдресРесурса = ДобавитьИмяФайлаКURL(ПередаваемыйФайл, АдресРесурса);
		КонецЕсли;

		ПараметрыФункции = Новый Массив;
		ПараметрыФункции.Добавить(ОбернутьКавычками(ПередаваемыйФайл.ИмяФайла));
		ПараметрыФункции.Добавить(ОбернутьКавычками(АдресРесурса));

		ВывестиСтроку(СтрШаблон("%1.Записать(%2);", 
			ИмяПараметраСоединение,
			ПараметрыФункцииВСтроку(ПараметрыФункции)));
	КонецЦикла;

КонецПроцедуры

Процедура ВывестиПолучениеСпискаФайловВДиректорииFTP(СтруктураURL)

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(ОбернутьКавычками(СтруктураURL.Путь));
	ПараметрыФункции.Добавить(ОбернутьКавычками("*"));

	ВывестиСтроку(СтрШаблон("Файлы = %1.НайтиФайлы(%2);", 
		ИмяПараметраСоединение,
		ПараметрыФункцииВСтроку(ПараметрыФункции)));

КонецПроцедуры

Процедура ВывестиПолучениеЗаголовковФайлаFTP(СтруктураURL)

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(ОбернутьКавычками(СтруктураURL.Путь));

	ВывестиСтроку(СтрШаблон("Файл = %1.НайтиФайлы(%2)[0];", 
		ИмяПараметраСоединение,
		ПараметрыФункцииВСтроку(ПараметрыФункции)));

КонецПроцедуры

Функция СобратьИсходнуюСтрокуЗапроса(СтруктураURL)

	СтрокаЗапроса = "";

	Для Каждого Параметр Из СтруктураURL.ПараметрыЗапроса Цикл
		СтрокаЗапроса = СтрокаЗапроса 
			+ ?(СтрокаЗапроса = "", "", "&")
			+ Параметр.Ключ
			+ "="
			+ КодироватьСтроку(Параметр.Значение, СпособКодированияСтроки.URLВКодировкеURL);
	КонецЦикла;

	Возврат СтрокаЗапроса;

КонецФункции

Функция ИспользуетсяЗащищенноеСоединение(СтруктураURL)
	Возврат СтруктураURL.Схема = ПротоколыURL.HTTPS 
		Или СтруктураURL.Схема = ПротоколыURL.FTPS
		Или ЗначениеЗаполнено(ОписаниеЗапроса.ИмяФайлаСертификатаКлиента);
КонецФункции

Функция ДобавитьИмяФайлаКURL(ПередаваемыйФайл, URL)
	Файл = Новый Файл(ПередаваемыйФайл.ИмяФайла);
	Если Прав(URL, 1) = "/" Тогда
		Возврат URL + Файл.Имя;
	КонецЕсли;
	Возврат URL;
КонецФункции

Процедура ВывестиСтроку(Строка)
	Результат = Результат + Символы.ПС + Строка;
КонецПроцедуры

Процедура ВывестиПустуюСтроку()
	Результат = Результат + Символы.ПС;
КонецПроцедуры

Функция ПараметрыФункцииВСтроку(ПараметрыФункции)
	
	ПараметрыСтрокой = "";

	МаксимальнаяДлинаВсехПараметровНаОднойСтроке = 110;
	ПереноситьКаждыйПараметр = СтрДлина(СтрСоединить(ПараметрыФункции, ", ")) > МаксимальнаяДлинаВсехПараметровНаОднойСтроке;

	Если ПереноситьКаждыйПараметр Тогда
		Разделитель = "," + Символы.ПС + Символы.Таб;
	Иначе
		Разделитель = ", ";
	КонецЕсли;

	КоличествоПараметров = ПараметрыФункции.Количество();

	ЕстьЗаполненный = Ложь;
	Для Инд = 1 По КоличествоПараметров Цикл
		
		Значение = ПараметрыФункции[КоличествоПараметров - Инд];
		Если ТипЗнч(Значение) = Тип("Булево") Тогда
			Значение = Формат(Значение, "БЛ=Ложь; БИ=Истина");
		КонецЕсли;

		Если Не ЕстьЗаполненный И Не ЗначениеЗаполнено(Значение) Тогда
			Продолжить;
		КонецЕсли;

		ПараметрыСтрокой = Значение + ?(ПараметрыСтрокой = "", "", Разделитель) + ПараметрыСтрокой;

		ЕстьЗаполненный = Истина;

	КонецЦикла;

	Возврат СокрЛП(ПараметрыСтрокой);

КонецФункции

Функция ОбернутьКавычками(Значение, ОборачиватьТолькоЗаполненные = Ложь)
	Если ЗначениеЗаполнено(Значение) Или Не ОборачиватьТолькоЗаполненные Тогда
		Возврат СтрШаблон("""%1""", ЭкранироватьКавычки(Значение));
	КонецЕсли;
	Возврат "";
КонецФункции

Функция ЭкранироватьКавычки(Строка)
	Возврат СтрЗаменить(Строка, """", """""");
КонецФункции

#КонецОбласти