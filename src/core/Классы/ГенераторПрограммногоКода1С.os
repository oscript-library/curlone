// BSLLS:LatinAndCyrillicSymbolInWord-off

#Использовать "../../internal"

Перем Конструктор; // см. КонструкторПрограммногоКода
Перем ИсходящиеОшибки; // Массив из Структура:
                       //   * Текст - Строка - Текст ошибки
                       //   * КритичнаяОшибка - Булево - Признак критичиной ошибки 
Перем ОписаниеЗапроса; // см. ОписаниеЗапроса

Перем ПрочитанныеФайлы; // Массив из Структура:
                        //   - ПередаваемыйФайл - см. ПередаваемыйФайл
                        //   - ИмяПеременной - Строка
Перем ВызванМетодПоТекущемуURL; // Булево
Перем ТелоЗапросаСтрока; // Строка
Перем МетодУстановкиТелаЗапроса; // Строка
Перем ИнициализированыЗаголовки; // Булево
Перем КодЛокализации; // Строка
Перем ПакетРесурсов; // Объект.ПакетРесурсовЛокализации, Объект.ГруппаПакетовРесурсовЛокализации
Перем ДесериализоватьОтветИзJSON; // Булево

Перем ИмяПараметраЗаголовки;  // Строка
Перем ИмяПараметраСоединение; // Строка
Перем ИмяПараметраЗащищенноеСоединение; // Строка
Перем ИмяПараметраHTTPЗапрос; // Строка
Перем ИмяПараметраHTTPОтвет; // Строка
Перем ИмяПараметраПрокси; // Строка
Перем ИмяПараметраТелоЗапросаСтрока; // Строка
Перем ИмяПараметраРазделительДанныхMultipart; // Строка
Перем ИмяПараметраРезультат; // Строка

#Область ПрограммныйИнтерфейс

// Генерирует программный код 1С из переданного описания запроса
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

	Если Ошибки = Неопределено Тогда
		Ошибки = Новый Массив();
	КонецЕсли;

	ОписаниеЗапроса = Описание;
	ИсходящиеОшибки = Ошибки;
	Конструктор = Новый КонструкторПрограммногоКода();
	ПрочитанныеФайлы.Очистить();
	
	ПакетРесурсов = МенеджерРесурсовЛокализации.ПолучитьПакеты(
		"Общий, КлючевыеСловаЯзыка, ГенераторПрограммногоКода1С", 
		КодЛокализации
	);

	ОпределитьМетодУстановкиТелаЗапроса();
	ДобавитьЧтениеФайлов();
	ДобавитьДанныеЗапроса();
	ДобавитьРазделительДанныхMultipart();
	ДобавитьЗаголовки();
	ДобавитьЗащищенноеСоединение();
	ДобавитьПрокси();
	ДобавитьЗапросы();

	Результат = Конструктор.ПолучитьРезультат();

	ПакетРесурсов.ЗаполнитьШаблон(Результат);

	Если Не КодЛокализации = "ru" Тогда
		Переводчик = Новый ПереводПрограммногоКода(ПакетРесурсов);
		Результат = Переводчик.Перевести(Результат);
	КонецЕсли;

	Возврат Результат;

КонецФункции

// Устанавливает язык перевода
//
// Параметры:
//   Локаль - Строка - Код локализации (ru, en)
Процедура УстановитьЯзыкПеревода(Локаль) Экспорт
	КодЛокализации = Локаль;
КонецПроцедуры

// HTTP ответ будет десериализован из JSON
//
// Параметры:
//   Десериализовать - Булево
Процедура ДесериализоватьОтветИзJSON(Десериализовать = Истина) Экспорт
	ДесериализоватьОтветИзJSON = Десериализовать;
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПоддерживаемыеОпции() Экспорт

	ПоддерживаемыеОпции = "url
	|H
	|header
	|X
	|request
	|u
	|user
	|d
	|data
	|data-ascii
	|data-raw
	|data-binary
	|data-urlencode
	|T
	|upload-file
	|G
	|get
	|I
	|head
	|E
	|cert
	|ca-native
	|cacert
	|url-query
	|o
	|output
	|output-dir
	|create-dirs
	|O
	|remote-name
	|remote-name-all
	|x
	|proxy
	|U
	|proxy-user
	|proxy-basic
	|proxy-ntlm
	|m
	|max-time
	|connect-timeout
	|json
	|A
	|user-agent
	|oauth2-bearer
	|ftp-pasv
	|P
	|ftp-port
	|l
	|list-only
	|basic
	|ntlm
	|negotiate
	|F
	|form
	|form-string";

	Возврат СтрРазделить(ПоддерживаемыеОпции, Символы.ПС, Ложь);

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

	ПрочитанныеФайлы = Новый Массив();

	УстановитьЯзыкПеревода("ru");
	ДесериализоватьОтветИзJSON(Ложь);

	ИмяПараметраЗаголовки = "Заголовки";
	ИмяПараметраСоединение = "Соединение";
	ИмяПараметраЗащищенноеСоединение = "ЗащищенноеСоединение";
	ИмяПараметраHTTPЗапрос = "HTTPЗапрос";
	ИмяПараметраHTTPОтвет = "HTTPОтвет";
	ИмяПараметраПрокси = "Прокси";
	ИмяПараметраТелоЗапросаСтрока = "ТелоЗапроса";
	ИмяПараметраРазделительДанныхMultipart = "РазделительMultipart";
	ИмяПараметраРезультат = "Результат";

КонецПроцедуры

Процедура ДобавитьРазделительДанныхMultipart()

	Если Не ОписаниеЗапроса.ОтправлятьКакMultipartFormData Тогда
		Возврат;
	КонецЕсли;

	Конструктор
		.ДобавитьПустуюСтроку()
		.ДобавитьСтроку(
			"%1 = СтрЗаменить(Новый УникальныйИдентификатор, ""-"", """");", 
			ИмяПараметраРазделительДанныхMultipart
		);
	
КонецПроцедуры

Процедура ДобавитьЗаголовки()

	ИнициализированыЗаголовки = Ложь;
	
	ЛокальныйКонструктор = Новый КонструкторПрограммногоКода();

	Для Каждого Заголовок Из ОписаниеЗапроса.Заголовки Цикл

		ПараметрыФункции = Новый Массив();
		ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(Заголовок.Ключ));
		ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(Заголовок.Значение));

		ЛокальныйКонструктор.ДобавитьСтроку(
			"%1.Вставить(%2);",
			ИмяПараметраЗаголовки, 
			ЛокальныйКонструктор.ПараметрыФункцииВСтроку(ПараметрыФункции)
		);

	КонецЦикла;

	ДобавитьЗаголовокAuthorization(ЛокальныйКонструктор);
	ДобавитьЗаголовокContentTypeMultipart(ЛокальныйКонструктор);

	Если Не ЛокальныйКонструктор.Пустой() Тогда

		Конструктор
			.ДобавитьПустуюСтроку()
			.ДобавитьСтроку("%1 = Новый Соответствие();", ИмяПараметраЗаголовки)
			.ДобавитьСтроку(ЛокальныйКонструктор.ПолучитьРезультат()
		);

		ИнициализированыЗаголовки = Истина;

	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьЗаголовокAuthorization(Конструктор)
	
	Если ОписаниеЗапроса.ТипАутентификации = ТипыАутентификации.Bearer Тогда

		Конструктор.ДобавитьСтроку(
			"%1.Вставить(""Authorization"", %2);",
			ИмяПараметраЗаголовки, 
			Конструктор.ПараметрВСтроку("Bearer " + ОписаниеЗапроса.ТокенBearer)
		);

	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьЗаголовокContentTypeMultipart(Конструктор)

	Если Не ОписаниеЗапроса.ОтправлятьКакMultipartFormData Тогда
		Возврат;
	КонецЕсли;

	Конструктор.ДобавитьСтроку(
		"%1.Вставить(""Content-Type"", ""multipart/form-data; boundary="" + %2);",
		ИмяПараметраЗаголовки, 
		ИмяПараметраРазделительДанныхMultipart
	);	

КонецПроцедуры

Процедура ДобавитьЧтениеФайлов()
	
	ТребуетсяЧтениеФайловТелаЗапроса = Не МетодУстановкиТелаЗапроса = "Файл";

	ФайлыДляЧтения = Новый Массив();
	Для Каждого ПередаваемыйФайл Из ОписаниеЗапроса.Файлы Цикл

		Если Не (ПередаваемыйФайл.ПрочитатьСодержимое 
			Или ПередаваемыйФайл.Назначение = НазначенияПередаваемыхДанных.СтрокаЗапроса) Тогда
			Продолжить;
		КонецЕсли;

		Если ПередаваемыйФайл.Назначение = НазначенияПередаваемыхДанных.ТелоЗапроса
			И Не ТребуетсяЧтениеФайловТелаЗапроса Тогда
			Продолжить;
		КонецЕсли;

		ФайлыДляЧтения.Добавить(ПередаваемыйФайл);

	КонецЦикла;

	Код = ЛокальныйГенераторКода.ЧтениеТекстовыхФайлов(ФайлыДляЧтения, ПрочитанныеФайлы);

	Если Не ПустаяСтрока(Код) Тогда
		Конструктор
			.ДобавитьПустуюСтроку()
			.ДобавитьСтроку(Код);
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьДанныеЗапроса()

	Если ОписаниеЗапроса.ОтправлятьКакMultipartFormData Тогда
		Возврат;
	КонецЕсли;

	ТелоЗапросаСтрока = "";
	ТелоЗапроса = ЛокальныйГенераторКода.ДанныеЗапроса(
		НазначенияПередаваемыхДанных.ТелоЗапроса,
		ОписаниеЗапроса.ОтправляемыеТекстовыеДанные, 
		ПрочитанныеФайлы
	);

	Если ЗначениеЗаполнено(ТелоЗапроса) Тогда

		Если СтрЧислоСтрок(ТелоЗапроса) = 1 Тогда
			ТелоЗапросаСтрока = ТелоЗапроса;
		Иначе
			Конструктор
				.ДобавитьПустуюСтроку()
				.ДобавитьСтроку("%1 = %2;", ИмяПараметраТелоЗапросаСтрока, ТелоЗапроса);
		КонецЕсли;

	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьЗащищенноеСоединение()
	
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

	Конструктор.ДобавитьПустуюСтроку();

	// Сертификат клиента
	ИмяПараметраСертификатаКлиента = "";
	Если ЗначениеЗаполнено(ОписаниеЗапроса.ИмяФайлаСертификатаКлиента) Тогда

		ИмяПараметраСертификатаКлиента = "СертификатКлиента";

		ПараметрыФункции = Новый Массив;
		ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(ОписаниеЗапроса.ИмяФайлаСертификатаКлиента));
		ПараметрыФункции.Добавить(Конструктор.НеобязательныйПараметрВСтроку(ОписаниеЗапроса.ПарольСертификатаКлиента));

		Конструктор.ДобавитьСтроку(
			"%1 = Новый СертификатКлиентаФайл(%2);", 
			ИмяПараметраСертификатаКлиента, 
			Конструктор.ПараметрыФункцииВСтроку(ПараметрыФункции)
		);

	КонецЕсли;

	// Сертификаты УЦ
	ИмяПараметраСертификатыУдостоверяющихЦентров = "СертификатыУдостоверяющихЦентров";
	Если ОписаниеЗапроса.ИспользоватьСертификатыУЦИзХранилищаОС Тогда

		Конструктор.ДобавитьСтроку(
			"%1 = Новый СертификатыУдостоверяющихЦентровОС();", 
			ИмяПараметраСертификатыУдостоверяющихЦентров
		);

	ИначеЕсли ЗначениеЗаполнено(ОписаниеЗапроса.ИмяФайлаСертификатовУЦ) Тогда

		Конструктор.ДобавитьСтроку(
			"%1 = Новый СертификатыУдостоверяющихЦентровФайл(%2);", 
			ИмяПараметраСертификатыУдостоверяющихЦентров,
			Конструктор.ПараметрВСтроку(ОписаниеЗапроса.ИмяФайлаСертификатовУЦ)
		);	

	Иначе

		ИмяПараметраСертификатыУдостоверяющихЦентров = "";

	КонецЕсли;

	// Защищенное соединение
	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(ИмяПараметраСертификатаКлиента);
	ПараметрыФункции.Добавить(ИмяПараметраСертификатыУдостоверяющихЦентров);
	
	Конструктор.ДобавитьСтроку(
		"%1 = Новый ЗащищенноеСоединениеOpenSSL(%2);", 
		ИмяПараметраЗащищенноеСоединение,
		Конструктор.ПараметрыФункцииВСтроку(ПараметрыФункции)
	);
	
КонецПроцедуры

Процедура ДобавитьПрокси()

	Если Не ОписаниеЗапроса.ИспользуетсяПрокси() Тогда
		Возврат;
	КонецЕсли;

	Если Не ОбщийНаборИнструментов.ПротоколПроксиПоддерживатся(ОписаниеЗапроса.ПроксиПротокол) Тогда
		ТекстОшибки = СтрШаблон("Прокси протокол %1 не поддерживается", ОписаниеЗапроса.ПроксиПротокол);
		ИсходящиеОшибки.Добавить(ОбщийНаборИнструментов.НоваяКритичнаяОшибка(ТекстОшибки));
		Возврат;
	КонецЕсли;

	Конструктор
		.ДобавитьПустуюСтроку()
		.ДобавитьСтроку(ЛокальныйГенераторКода.ИнтернетПрокси(ОписаниеЗапроса, ИмяПараметраПрокси));

КонецПроцедуры

Процедура ДобавитьЗапросы()

	МаксимальнаяДлинаАдресаВКомментарии = 100;

	КоличествоURL = ОписаниеЗапроса.АдресаРесурсов.Количество();
	НомерЗапроса = 0;

	Для Каждого ОписаниеРесурса Из ОписаниеЗапроса.АдресаРесурсов Цикл
		
		НомерЗапроса = НомерЗапроса + 1;
		СтруктураURL = Новый ПарсерURL(ОписаниеРесурса.URL);
		ВызванМетодПоТекущемуURL = Ложь;

		Конструктор.ДобавитьПустуюСтроку();

		Если КоличествоURL > 1 Тогда
			Конструктор.ДобавитьКомментарий(
				"{t(Текст.Запрос)} %1. %2", 
				НомерЗапроса, 
				Лев(ОписаниеРесурса.URL, МаксимальнаяДлинаАдресаВКомментарии)
			);
		КонецЕсли;

		Если ОбщийНаборИнструментов.ЭтоHTTP(СтруктураURL.Схема) Тогда

			ДобавитьHTTPСоединение(СтруктураURL);
			ДобавитьПоследовательнуюОтправкуФайлов(ОписаниеРесурса);

			Если Не ВызванМетодПоТекущемуURL Тогда
				ДобавитьHTTPЗапрос(СтруктураURL);
				ДобавитьУстановкуТелаЗапроса(ОписаниеРесурса);				
				ДобавитьВызовHTTPМетода(ОписаниеРесурса);
				ДобавитьЧтениеОтветаJSON();
			КонецЕсли;

		ИначеЕсли ОбщийНаборИнструментов.ЭтоFTP(СтруктураURL.Схема) Тогда

			ДобавитьFTPСоединение(СтруктураURL);
			ДобавитьВызовFTPМетода(ОписаниеРесурса, СтруктураURL);

		Иначе

			ТекстОшибки = СтрШаблон("Протокол ""%1"" не поддерживается", СтруктураURL.Схема);
			ИсходящиеОшибки.Добавить(ОбщийНаборИнструментов.НоваяКритичнаяОшибка(ТекстОшибки));

		КонецЕсли;

		Если ОбщийНаборИнструментов.ЕстьКритичныеОшибки(ИсходящиеОшибки) Тогда
			Конструктор.Очистить();
			Возврат;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьПоследовательнуюОтправкуФайлов(ОписаниеРесурса)

	Если ОписаниеЗапроса.ОтправлятьКакMultipartFormData Тогда
		Возврат;
	КонецЕсли;

	ДлинаИмениФайлаВКомментарии = 100;

	ПередаваемыеФайлы = ОписаниеЗапроса.ФайлыОтправляемыеОтдельно(ОписаниеРесурса);

	КоличествоФайлов = ПередаваемыеФайлы.Количество();
	НомерФайла = 0;
	Для Каждого ПередаваемыйФайл Из ПередаваемыеФайлы Цикл

		НомерФайла = НомерФайла + 1;

		Если КоличествоФайлов > 1 Тогда
			ИмяФайла = Лев(ПередаваемыйФайл.ПолноеИмяФайла, ДлинаИмениФайлаВКомментарии);
			Конструктор
				.ДобавитьПустуюСтроку()
				.ДобавитьКомментарий("{t(Текст.ПередачаФайла)} %1. %2",
					НомерФайла,
					ИмяФайла
				);
		КонецЕсли;

		СтруктураURL = Новый ПарсерURL(ОписаниеРесурса.URL);
		Если ПередаваемыйФайл.ДобавлятьИмяФайлаКURL Тогда
			СтруктураURL.Путь = ОбщийНаборИнструментов.ДополнитьИменемФайлаПутьURL(ПередаваемыйФайл.ПолноеИмяФайла, СтруктураURL.Путь);
		КонецЕсли;

		ДобавитьHTTPЗапрос(СтруктураURL);

		Конструктор.ДобавитьСтроку(
			"%1.УстановитьИмяФайлаТела(%2);", 
			ИмяПараметраHTTPЗапрос, 
			Конструктор.ПараметрВСтроку(ПередаваемыйФайл.ПолноеИмяФайла)
		);

		ДобавитьВызовHTTPМетода(ОписаниеРесурса);

	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьHTTPСоединение(СтруктураURL)

	Таймаут = 0;
	Если ЗначениеЗаполнено(ОписаниеЗапроса.Таймаут) И ЗначениеЗаполнено(ОписаниеЗапроса.ТаймаутСоединения) Тогда
		Таймаут = ОписаниеЗапроса.Таймаут + ОписаниеЗапроса.ТаймаутСоединения;
	КонецЕсли;

	ИспользуетсяЗащищенноеСоединение = ИспользуетсяЗащищенноеСоединение(СтруктураURL);
	ИспользоватьАутентификациюОС = ОписаниеЗапроса.ТипАутентификации = ТипыАутентификации.NTLM 
		Или ОписаниеЗапроса.ТипАутентификации = ТипыАутентификации.Negotiate;

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(СтруктураURL.Сервер));
	ПараметрыФункции.Добавить(Конструктор.НеобязательныйПараметрВСтроку(ПолучитьПорт(СтруктураURL)));
	ПараметрыФункции.Добавить(Конструктор.НеобязательныйПараметрВСтроку(ОписаниеЗапроса.ИмяПользователя));
	ПараметрыФункции.Добавить(Конструктор.НеобязательныйПараметрВСтроку(ОписаниеЗапроса.ПарольПользователя));
	ПараметрыФункции.Добавить(?(ОписаниеЗапроса.ИспользуетсяПрокси(), ИмяПараметраПрокси, ""));
	ПараметрыФункции.Добавить(Конструктор.НеобязательныйПараметрВСтроку(Таймаут));
	ПараметрыФункции.Добавить(?(ИспользуетсяЗащищенноеСоединение, ИмяПараметраЗащищенноеСоединение, ""));
	ПараметрыФункции.Добавить(?(ИспользоватьАутентификациюОС, ИспользоватьАутентификациюОС, ""));

	Конструктор.ДобавитьСтроку(
		"%1 = Новый HTTPСоединение(%2);",
		ИмяПараметраСоединение,
		Конструктор.ПараметрыФункцииВСтроку(ПараметрыФункции)
	);

КонецПроцедуры

Процедура ДобавитьHTTPЗапрос(СтруктураURL)

	ПараметрыФункции = Новый Массив;
	
	АдресРесурсаКод = ЛокальныйГенераторКода.АдресРесурса(
		СтруктураURL, 
		ОписаниеЗапроса.ОтправляемыеТекстовыеДанные, 
		ПрочитанныеФайлы
	);

	Если ПустаяСтрока(АдресРесурсаКод) Тогда

		ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку("/"));

	ИначеЕсли СтрЧислоСтрок(АдресРесурсаКод) > 1 Тогда

		Конструктор
			.ДобавитьПустуюСтроку()
			.ДобавитьСтроку("АдресРесурса = %1;", АдресРесурсаКод);
			
		ПараметрыФункции.Добавить("АдресРесурса");

	Иначе

		ПараметрыФункции.Добавить(АдресРесурсаКод);

	КонецЕсли;

	Если ИнициализированыЗаголовки Тогда
		ПараметрыФункции.Добавить(ИмяПараметраЗаголовки);
	КонецЕсли;

	Конструктор.ДобавитьСтроку(
		"%1 = Новый HTTPЗапрос(%2);", 
		ИмяПараметраHTTPЗапрос,
		Конструктор.ПараметрыФункцииВСтроку(ПараметрыФункции)
	);

КонецПроцедуры

Процедура ДобавитьВызовHTTPМетода(ОписаниеРесурса)

	ДобавитьСозданиеКаталога(ОписаниеРесурса);

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(ОписаниеРесурса.Метод));
	ПараметрыФункции.Добавить(ИмяПараметраHTTPЗапрос);
	ПараметрыФункции.Добавить(Конструктор.НеобязательныйПараметрВСтроку(ОписаниеРесурса.ИмяВыходногоФайла));

	Конструктор
		.ДобавитьПустуюСтроку()
		.ДобавитьСтроку(
			"%1 = %2.ВызватьHTTPМетод(%3);", 
			ИмяПараметраHTTPОтвет,
			ИмяПараметраСоединение,
			Конструктор.ПараметрыФункцииВСтроку(ПараметрыФункции)
		);

	ВызванМетодПоТекущемуURL = Истина;

КонецПроцедуры

Процедура ДобавитьСозданиеКаталога(ОписаниеРесурса)

	Если Не ЗначениеЗаполнено(ОписаниеРесурса.ИмяВыходногоФайла) 
		Или Не ОписаниеЗапроса.СоздатьКаталогСохраненияФайлов Тогда
		Возврат;
	КонецЕсли;

	Каталог = ОбщийНаборИнструментов.КаталогФайла(ОписаниеРесурса.ИмяВыходногоФайла);

	Если Не ПустаяСтрока(Каталог) Тогда

		КодСозданияКаталога = "// {t(Создание каталога по необходимости)}
		|Каталог = Новый Файл(""%1"");
		|Если Не Каталог.Существует() Тогда
		|	СоздатьКаталог(Каталог.ПолноеИмя);
		|КонецЕсли;";

		Конструктор
			.ДобавитьПустуюСтроку()
			.ДобавитьСтроку(КодСозданияКаталога, Каталог);

	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьУстановкуТелаЗапроса(ОписаниеРесурса)

	ДобавитьУстановкуТелаЗапросаТекстовымиДанными();
	ДобавитьУстановкуТелаЗапросаИзФайла(ОписаниеРесурса);
	ДобавитьЗаписьДанныхВПотокMultipart();

КонецПроцедуры

Процедура ДобавитьУстановкуТелаЗапросаТекстовымиДанными()
	
	Если Не МетодУстановкиТелаЗапроса = "Строка" Тогда
		Возврат;
	КонецЕсли;

	Конструктор.ДобавитьСтроку(
		"%1.УстановитьТелоИзСтроки(%2);",
		ИмяПараметраHTTPЗапрос,
		?(ЗначениеЗаполнено(ТелоЗапросаСтрока), ТелоЗапросаСтрока, ИмяПараметраТелоЗапросаСтрока)
	);

КонецПроцедуры

Процедура ДобавитьУстановкуТелаЗапросаИзФайла(ОписаниеРесурса)

	Если Не МетодУстановкиТелаЗапроса = "Файл" Тогда
		Возврат;
	КонецЕсли;

	Файлы = Новый Массив();
	ОбщийНаборИнструментов.ДополнитьМассив(Файлы, ОписаниеЗапроса.Файлы);
	ОбщийНаборИнструментов.ДополнитьМассив(Файлы, ОписаниеРесурса.Файлы);

	ЭтоПервыйФайл = Истина;
	Для Каждого ПередаваемыйФайл Из Файлы Цикл

		Если ПередаваемыйФайл.ОтправлятьОтдельно
			Или Не ПередаваемыйФайл.Назначение = НазначенияПередаваемыхДанных.ТелоЗапроса
			Или ПередаваемыйФайлПрочитан(ПередаваемыйФайл) Тогда
			Продолжить;
		КонецЕсли;

		Конструктор.ДобавитьСтроку(
			"%1%2.УстановитьИмяФайлаТела(%3);", 
			?(ЭтоПервыйФайл, "", "// "),
			ИмяПараметраHTTPЗапрос, 
			Конструктор.ПараметрВСтроку(ПередаваемыйФайл.ПолноеИмяФайла)
		);

		ЭтоПервыйФайл = Ложь;

	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьЗаписьДанныхВПотокMultipart()
	
	Если Не ОписаниеЗапроса.ОтправлятьКакMultipartFormData Тогда
		Возврат;
	КонецЕсли;

	КонструкторЗаписиДанных = Новый КонструкторПрограммногоКода();

	ДобавитьДанныеФормыВЗаписьДанныхMultipart(КонструкторЗаписиДанных);
	ДобавитьДанныеФормыИзФайловВЗаписьДанныхMultipart(КонструкторЗаписиДанных);
	ДобавитьФайлыВЗаписьДанныхMultipart(КонструкторЗаписиДанных);

	Если КонструкторЗаписиДанных.Пустой() Тогда
		Возврат;
	КонецЕсли;

	Конструктор
		.ДобавитьСтроку("Поток = %1.ПолучитьТелоКакПоток();", ИмяПараметраHTTPЗапрос)
		.ДобавитьПустуюСтроку()
		.ДобавитьСтроку("РазделительСтрок = Символы.ВК + Символы.ПС;")
		.ДобавитьСтроку("ЗаписьДанных = Новый ЗаписьДанных(Поток, , , """", """");")
		.ДобавитьСтроку(КонструкторЗаписиДанных.ПолучитьРезультат())
		.ДобавитьСтроку(
			"ЗаписьДанных.ЗаписатьСтроку(""--"" + %1 + ""--"" + РазделительСтрок);",
			ИмяПараметраРазделительДанныхMultipart
		)
		.ДобавитьСтроку("ЗаписьДанных.Закрыть();");

КонецПроцедуры

Процедура ДобавитьДанныеФормыВЗаписьДанныхMultipart(КонструкторЗаписиДанных)
	
	ИмяПараметраРазделитель = ИмяПараметраРазделительДанныхMultipart;
	
	Для Каждого ПередаваемыйТекст Из ОписаниеЗапроса.ОтправляемыеТекстовыеДанные Цикл

		Если Не ПередаваемыйТекст.Назначение = НазначенияПередаваемыхДанных.ТелоЗапроса Тогда
			Продолжить;
		КонецЕсли;

		ContentDisposition = ОбщийНаборИнструментов.НайтиВСоответствииПоКлючуБезУчетаРегистра(
			ПередаваемыйТекст.Заголовки,
			"Content-Disposition");
		ContentDisposition = ?(ContentDisposition = Неопределено, "form-data", ContentDisposition);

		КонструкторЗаписиДанных
			.ДобавитьКомментарий(
				"{t(Текст.Начало)} %1",
				ПередаваемыйТекст.ИмяПоля
			)
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(""--"" + %1 + РазделительСтрок);",
				ИмяПараметраРазделитель
			)
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(""Content-Disposition: %1; name=""%2"""" + РазделительСтрок);", 
				ContentDisposition,
				Конструктор.ПараметрВСтроку(ПередаваемыйТекст.ИмяПоля)
			);

		Если ЗначениеЗаполнено(ПередаваемыйТекст.ТипMIME) Тогда
			КонструкторЗаписиДанных.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(""Content-Type: %1"" + РазделительСтрок);", 
				ПередаваемыйТекст.ТипMIME
			);
		КонецЕсли;

		ДобавитьЗаголовкиВЗаписьДанныхMultipart(КонструкторЗаписиДанных, ПередаваемыйТекст.Заголовки);

		КонструкторЗаписиДанных
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(РазделительСтрок);"
			)
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(%1 + РазделительСтрок);",
				Конструктор.ПараметрВСтроку(ПередаваемыйТекст.Значение)
			)
			.ДобавитьКомментарий(
				"{t(Текст.Конец)} %1",
				ПередаваемыйТекст.ИмяПоля
			);

	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьДанныеФормыИзФайловВЗаписьДанныхMultipart(КонструкторЗаписиДанных)
	
	ИмяПараметраРазделитель = ИмяПараметраРазделительДанныхMultipart;
	
	Для Каждого ПрочитанныйФайл Из ПрочитанныеФайлы Цикл

		ПередаваемыйФайл = ПрочитанныйФайл.ПередаваемыйФайл;
	
		Если Не ПередаваемыйФайл.Назначение = НазначенияПередаваемыхДанных.ТелоЗапроса Тогда
			Продолжить;
		КонецЕсли;

		ContentDisposition = ОбщийНаборИнструментов.НайтиВСоответствииПоКлючуБезУчетаРегистра(
			ПередаваемыйФайл.Заголовки,
			"Content-Disposition");
		ContentDisposition = ?(ContentDisposition = Неопределено, "form-data", ContentDisposition);

		КонструкторЗаписиДанных
			.ДобавитьКомментарий(
				"{t(Текст.Начало)} %1", ПередаваемыйФайл.ИмяПоля
			)
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(""--"" + %1 + РазделительСтрок);",
				ИмяПараметраРазделитель
			)
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(""Content-Disposition: %1; name=""""%2"""""" + РазделительСтрок);", 
				ContentDisposition,
				ПередаваемыйФайл.ИмяПоля
			);

		Если ЗначениеЗаполнено(ПередаваемыйФайл.ТипMIME) Тогда
			КонструкторЗаписиДанных.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(""Content-Type: %1"" + РазделительСтрок);", 
				ПередаваемыйФайл.ТипMIME
			);
		КонецЕсли;

		ДобавитьЗаголовкиВЗаписьДанныхMultipart(КонструкторЗаписиДанных, ПередаваемыйФайл.Заголовки);

		КонструкторЗаписиДанных
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(РазделительСтрок);"
			)
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(%1 + РазделительСтрок);",
				ПрочитанныйФайл.ИмяПеременной
			)			
			.ДобавитьКомментарий(
				"{t(Текст.Конец)} %1",
				ПередаваемыйФайл.ИмяПоля
			);		
	
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьФайлыВЗаписьДанныхMultipart(КонструкторЗаписиДанных)
	
	ИмяПараметраРазделитель = ИмяПараметраРазделительДанныхMultipart;
	
	Для Каждого ПередаваемыйФайл Из ОписаниеЗапроса.Файлы Цикл

		Если Не ПередаваемыйФайл.Назначение = НазначенияПередаваемыхДанных.ТелоЗапроса
			Или ПередаваемыйФайл.ПрочитатьСодержимое Тогда
			Продолжить;
		КонецЕсли;

		ContentDisposition = ОбщийНаборИнструментов.НайтиВСоответствииПоКлючуБезУчетаРегистра(
			ПередаваемыйФайл.Заголовки,
			"Content-Disposition");
		ContentDisposition = ?(ContentDisposition = Неопределено, "form-data", ContentDisposition);

		КонструкторЗаписиДанных
			.ДобавитьКомментарий(
				"{t(Текст.Начало)} %1",
				ПередаваемыйФайл.ИмяПоля
			)
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(""--"" + %1 + РазделительСтрок);",
				ИмяПараметраРазделитель
			)
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(""Content-Disposition: %1; name=""""%2""""; filename=""""%3"""""" + РазделительСтрок);",
				ContentDisposition,
				ПередаваемыйФайл.ИмяПоля,
				ПередаваемыйФайл.ИмяФайла
			)
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(""Content-Type: %1"" + РазделительСтрок);", 
				?(ЗначениеЗаполнено(ПередаваемыйФайл.ТипMIME), ПередаваемыйФайл.ТипMIME, "application/octet-stream")
			);
				
		ДобавитьЗаголовкиВЗаписьДанныхMultipart(КонструкторЗаписиДанных, ПередаваемыйФайл.Заголовки);

		КонструкторЗаписиДанных
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(РазделительСтрок);"
			)
			.ДобавитьСтроку(
				"ЗаписьДанных.Записать(Новый ДвоичныеДанные(""%1""));",
				ПередаваемыйФайл.ПолноеИмяФайла
			)
			.ДобавитьСтроку(
				"ЗаписьДанных.ЗаписатьСтроку(РазделительСтрок);"
			)
			.ДобавитьКомментарий(
				"{t(Текст.Конец)} %1",
				ПередаваемыйФайл.ИмяПоля
			);
	
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьЗаголовкиВЗаписьДанныхMultipart(КонструкторЗаписиДанных, Заголовки)

	Для Каждого Заголовок Из Заголовки Цикл

		Если НРег(Заголовок.Ключ) = "content-disposition" Тогда
			Продолжить;
		КонецЕсли;

		КонструкторЗаписиДанных.ДобавитьСтроку(
			"ЗаписьДанных.ЗаписатьСтроку(""%1: %2"" + РазделительСтрок);",
			Заголовок.Ключ, 
			Заголовок.Значение
		);

	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьЧтениеОтветаJSON()

	Если Не ДесериализоватьОтветИзJSON Тогда
		Возврат;
	КонецЕсли;

	Конструктор
		.ДобавитьПустуюСтроку()
		.ДобавитьКомментарий(ПакетРесурсов.ПолучитьРесурс("Десериализация JSON"))
		.ДобавитьСтроку("Поток = %1.{t(HTTPОтвет.ПолучитьТелоКакПоток)}();", ИмяПараметраHTTPОтвет)
		.ДобавитьСтроку("ЧтениеJSON = Новый ЧтениеJSON();")
		.ДобавитьСтроку("ЧтениеJSON.ОткрытьПоток(Поток);")
		.ДобавитьСтроку("%1 = ПрочитатьJSON(ЧтениеJSON, Истина);", ИмяПараметраРезультат)
		.ДобавитьСтроку("Поток.{t(Поток.Закрыть)}();");
	
КонецПроцедуры

Процедура ДобавитьFTPСоединение(СтруктураURL)

	Если ЗначениеЗаполнено(ОписаниеЗапроса.FTPАдресОбратногоСоединения)
		И Не ОписаниеЗапроса.FTPАдресОбратногоСоединения = "-" Тогда
		ИсходящиеОшибки.Добавить(ОбщийНаборИнструментов.НоваяОшибка("Адрес из опции -P, --ftp-port было проигнорировано"));
	КонецЕсли;

	Таймаут = 0;
	Если ЗначениеЗаполнено(ОписаниеЗапроса.Таймаут) И ЗначениеЗаполнено(ОписаниеЗапроса.ТаймаутСоединения) Тогда
		Таймаут = ОписаниеЗапроса.Таймаут + ОписаниеЗапроса.ТаймаутСоединения;
	КонецЕсли;

	ИспользуетсяЗащищенноеСоединение = ИспользуетсяЗащищенноеСоединение(СтруктураURL);

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(СтруктураURL.Сервер));
	ПараметрыФункции.Добавить(Конструктор.НеобязательныйПараметрВСтроку(ПолучитьПорт(СтруктураURL)));
	ПараметрыФункции.Добавить(Конструктор.НеобязательныйПараметрВСтроку(ОписаниеЗапроса.ИмяПользователя));
	ПараметрыФункции.Добавить(Конструктор.НеобязательныйПараметрВСтроку(ОписаниеЗапроса.ПарольПользователя));
	ПараметрыФункции.Добавить(?(ОписаниеЗапроса.ИспользуетсяПрокси(), ИмяПараметраПрокси, ""));
	ПараметрыФункции.Добавить(?(ОписаниеЗапроса.FTPПассивныйРежимСоединения, Истина, ""));
	ПараметрыФункции.Добавить(Конструктор.НеобязательныйПараметрВСтроку(Таймаут));
	ПараметрыФункции.Добавить(?(ИспользуетсяЗащищенноеСоединение, ИмяПараметраЗащищенноеСоединение, ""));

	Конструктор.ДобавитьСтроку(
		"%1 = Новый FTPСоединение(%2);", 
		ИмяПараметраСоединение,
		Конструктор.ПараметрыФункцииВСтроку(ПараметрыФункции)
	);

КонецПроцедуры

Процедура ДобавитьВызовFTPМетода(ОписаниеРесурса, СтруктураURL)

	Конструктор.ДобавитьПустуюСтроку();

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

		ИсходящиеОшибки.Добавить(ОбщийНаборИнструментов.НоваяКритичнаяОшибка(ТекстОшибки));
	КонецЕсли;

КонецПроцедуры

Процедура ВывестиВызовПолученияФайлаFTP(ОписаниеРесурса, СтруктураURL)

	ИмяВыходногоФайла = ?(ЗначениеЗаполнено(ОписаниеРесурса.ИмяВыходногоФайла), 
		ОписаниеРесурса.ИмяВыходногоФайла, 
		"path/to/file"
	);

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(СтруктураURL.Путь));
	ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(ИмяВыходногоФайла));

	Конструктор.ДобавитьСтроку(
		"%1.Получить(%2);", 
		ИмяПараметраСоединение,
		Конструктор.ПараметрыФункцииВСтроку(ПараметрыФункции)
	);

КонецПроцедуры

Процедура ВывестиВызовОтправкиФайлаFTP(ОписаниеРесурса, СтруктураURL)

	Для Каждого ПередаваемыйФайл Из ОписаниеРесурса.Файлы Цикл

		Если Не ПередаваемыйФайл.ОтправлятьОтдельно Тогда
			Продолжить;
		КонецЕсли;

		Если ПередаваемыйФайл.ДобавлятьИмяФайлаКURL Тогда
			АдресРесурса = ОбщийНаборИнструментов.ДополнитьИменемФайлаПутьURL(ПередаваемыйФайл.ПолноеИмяФайла, СтруктураURL.Путь);
		Иначе
			АдресРесурса = СтруктураURL.Путь;
		КонецЕсли;

		ПараметрыФункции = Новый Массив;
		ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(ПередаваемыйФайл.ПолноеИмяФайла));
		ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(АдресРесурса));

		Конструктор.ДобавитьСтроку(
			"%1.Записать(%2);", 
			ИмяПараметраСоединение,
			Конструктор.ПараметрыФункцииВСтроку(ПараметрыФункции)
		);

	КонецЦикла;

КонецПроцедуры

Процедура ВывестиПолучениеСпискаФайловВДиректорииFTP(СтруктураURL)

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(СтруктураURL.Путь));
	ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку("*"));

	Конструктор.ДобавитьСтроку(
		"Файлы = %1.НайтиФайлы(%2);", 
		ИмяПараметраСоединение,
		Конструктор.ПараметрыФункцииВСтроку(ПараметрыФункции)
	);

КонецПроцедуры

Процедура ВывестиПолучениеЗаголовковФайлаFTP(СтруктураURL)

	ПараметрыФункции = Новый Массив;
	ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(СтруктураURL.Путь));

	Конструктор.ДобавитьСтроку(
		"Файл = %1.НайтиФайлы(%2)[0];", 
		ИмяПараметраСоединение,
		Конструктор.ПараметрыФункцииВСтроку(ПараметрыФункции)
	);

КонецПроцедуры

Функция ИспользуетсяЗащищенноеСоединение(СтруктураURL)

	Возврат СтруктураURL.Схема = ПротоколыURL.HTTPS 
		Или СтруктураURL.Схема = ПротоколыURL.FTPS
		Или ЗначениеЗаполнено(ОписаниеЗапроса.ИмяФайлаСертификатаКлиента);

КонецФункции

Функция ПередаваемыйФайлПрочитан(ПередаваемыйФайл)

	Если Не ПередаваемыйФайл.ПрочитатьСодержимое Тогда
		Возврат Ложь;
	КонецЕсли;

	Для Каждого ПрочитанныйФайл Из ПрочитанныеФайлы Цикл
		Если ПрочитанныйФайл.ПередаваемыйФайл = ПередаваемыйФайл Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;

	Возврат Ложь;
	
КонецФункции

Процедура ОпределитьМетодУстановкиТелаЗапроса()

	КоличествоФайлов = 0;
	Для Каждого ПередаваемыйФайл Из ОписаниеЗапроса.Файлы Цикл
		Если ПередаваемыйФайл.ПрочитатьСодержимое 
			И ПередаваемыйФайл.Назначение = НазначенияПередаваемыхДанных.ТелоЗапроса Тогда
			КоличествоФайлов = КоличествоФайлов + 1;
		КонецЕсли;
	КонецЦикла;
	
	ЕстьТекстовоеТелоЗапроса = Ложь;
	Для Каждого ПередаваемыйТекст Из ОписаниеЗапроса.ОтправляемыеТекстовыеДанные Цикл
		Если ПередаваемыйТекст.Назначение = НазначенияПередаваемыхДанных.ТелоЗапроса Тогда
			ЕстьТекстовоеТелоЗапроса = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ОписаниеЗапроса.ОтправлятьКакMultipartFormData Тогда
		МетодУстановкиТелаЗапроса = "Поток";
	ИначеЕсли КоличествоФайлов > 1 Или ЕстьТекстовоеТелоЗапроса Тогда
		МетодУстановкиТелаЗапроса = "Строка";
	ИначеЕсли КоличествоФайлов = 1 И Не ЕстьТекстовоеТелоЗапроса Тогда
		МетодУстановкиТелаЗапроса = "Файл";
	Иначе
		МетодУстановкиТелаЗапроса = "";
	КонецЕсли;

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

	Возврат Порт;

КонецФункции

#КонецОбласти