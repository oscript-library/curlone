#Использовать "../../internal"

Перем Конструктор; // см. КонструкторПрограммногоКода
Перем ИсходящиеОшибки; // Массив из Структура:
                       //   * Текст - Строка - Текст ошибки
                       //   * КритичнаяОшибка - Булево - Признак критичиной ошибки 
Перем ОписаниеЗапроса; // см. ОписаниеЗапроса

Перем Состояние; // см. НовоеСостояние
Перем ПрочитанныеФайлы; // Массив из Структура:
                        //   - ПередаваемыйФайл - см. ПередаваемыйФайл
                        //   - ИмяПеременной - Строка
Перем ДанныеЗапросаСборка; // Строка
Перем URLСборка; // Строка

Перем ИмяПараметраЗаголовки;  // Строка
Перем ИмяПараметраАутентификация; // Строка
Перем ИмяПараметраПрокси; // Строка
Перем ИмяПараметраДополнительныеПараметры; // Строка
Перем ИмяПараметраДанныеЗапроса; // Строка
Перем ИмяПараметраПараметрыЗапроса; // Строка
Перем ИмяПараметраURL; // Строка

#Область ПрограммныйИнтерфейс

// Генерирует программный код для коннектора из переданного описания запроса
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
	Состояние = НовоеСостояние();
	
	ПрочитанныеФайлы.Очистить();
	
	ДобавитьЗаголовки();
	ДобавитьАутентификацию();
	ДобавитьПрокси();
	ДобавитьЧтениеФайлов();
	ДобавитьДанныеЗапроса();
	ДобавитьПараметрыЗапроса();
	ДобавитьЗапросы();

	Возврат Конструктор.ПолучитьРезультат();

КонецФункции

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
	|oauth2-bearer";

	Возврат СтрРазделить(ПоддерживаемыеОпции, Символы.ПС, Ложь);

КонецФункции

Функция ПоддерживаемыеПротоколы() Экспорт
	Протоколы = Новый Массив();
	Протоколы.Добавить(ПротоколыURL.HTTP);
	Протоколы.Добавить(ПротоколыURL.HTTPS);
	Возврат Протоколы;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриСозданииОбъекта()
	
	ИмяПараметраЗаголовки = "Заголовки";
	ИмяПараметраАутентификация = "Аутентификация";
	ИмяПараметраПрокси = "Прокси";
	ИмяПараметраДополнительныеПараметры = "ДополнительныеПараметры";
	ИмяПараметраДанныеЗапроса = "Данные";
	ИмяПараметраПараметрыЗапроса = "ПараметрыЗапроса";
	ИмяПараметраURL = "URL";

	ПрочитанныеФайлы = Новый Массив();

КонецПроцедуры

Процедура ДобавитьЗаголовки()
	
	Заголовки = ПередаваемыеЗаголовки();
	Если Заголовки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Состояние.ЕстьЗаголовки = Истина;

	Конструктор.ДобавитьСтроку("%1 = Новый Соответствие();", ИмяПараметраЗаголовки);

	Для Каждого Заголовок Из ОписаниеЗапроса.Заголовки Цикл

		Если Не ПередаватьЗаголовок(Заголовок) Тогда
			Продолжить;
		КонецЕсли;

		ПараметрыФункции = Новый Массив();
		ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(Заголовок.Ключ));
		ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(Заголовок.Значение));

		Конструктор.ДобавитьСтроку("%1.Вставить(%2);",
			ИмяПараметраЗаголовки, 
			Конструктор.ПараметрыФункцииВСтроку(ПараметрыФункции));

	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьЧтениеФайлов()

	ФайлыДляЧтения = Новый Массив();
	Для Каждого ПередаваемыйФайл Из ОписаниеЗапроса.Файлы Цикл

		Если Не (ПередаваемыйФайл.ПрочитатьСодержимое 
			Или ПередаваемыйФайл.Назначение = НазначенияПередаваемыхДанных.СтрокаЗапроса) Тогда
			Продолжить;
		КонецЕсли;

		ФайлыДляЧтения.Добавить(ПередаваемыйФайл);

	КонецЦикла;

	Код = УниверсальныеБлокиКода.ЧтениеТекстовыхФайлов(ФайлыДляЧтения, ПрочитанныеФайлы);

	Если Не ПустаяСтрока(Код) Тогда
		Конструктор
			.ДобавитьПустуюСтроку()
			.ДобавитьСтроку(Код);
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьДанныеЗапроса()

	ДанныеЗапросаСборка = "";

	Если Не Состояние.ПереданоТелоЗапроса Тогда
		Возврат;
	КонецЕсли;

	НазначениеДанных = НазначенияПередаваемыхДанных.ТелоЗапроса;

	Если ВозможнаПередачаДанныхЧерезСоответствие(НазначениеДанных) Тогда
	
		ДобавитьТекстовыеДанныеЗапросаЧерезСоответствие(НазначениеДанных, ИмяПараметраДанныеЗапроса);
		ДанныеЗапросаСборка = ИмяПараметраДанныеЗапроса;

	Иначе

		ДобавитьТекстовыеДанныеЗапросаЧерезСтроку(НазначениеДанных, ИмяПараметраДанныеЗапроса, ДанныеЗапросаСборка);

	КонецЕсли;	

КонецПроцедуры

Процедура ДобавитьПараметрыЗапроса()

	НазначениеДанных = НазначенияПередаваемыхДанных.СтрокаЗапроса;
	
	Если Не Состояние.ПереданаСтрокаЗапроса
		Или Не ВозможнаПередачаДанныхЧерезСоответствие(НазначениеДанных) Тогда
		Возврат;
	КонецЕсли;

	ДобавитьТекстовыеДанныеЗапросаЧерезСоответствие(НазначениеДанных, ИмяПараметраПараметрыЗапроса);

КонецПроцедуры

Процедура ДобавитьТекстовыеДанныеЗапросаЧерезСоответствие(Назначение, ИмяПараметра)

	РазделительКлючаИЗначения = "=";

	Конструктор
		.ДобавитьПустуюСтроку()
		.ДобавитьСтроку("%1 = Новый Соответствие();", ИмяПараметра);

	Для Каждого ПередаваемыйТекст Из ОписаниеЗапроса.ОтправляемыеТекстовыеДанные Цикл
		
		Если Не ПередаваемыйТекст.Назначение = Назначение Тогда
			Продолжить;
		КонецЕсли;

		ИндексРазделителя = СтрНайти(ПередаваемыйТекст.Значение, РазделительКлючаИЗначения);
		
		Если ИндексРазделителя > 0 Тогда
			Ключ = Сред(ПередаваемыйТекст.Значение, 1, ИндексРазделителя - 1);
			Значение = Сред(ПередаваемыйТекст.Значение, ИндексРазделителя + 1);
		Иначе
			Ключ = ПередаваемыйТекст.Значение;
			Значение = Неопределено;
		КонецЕсли;

		ПараметрыМетода = Новый Массив();
		ПараметрыМетода.Добавить(Конструктор.ПараметрВСтроку(Ключ));
		ПараметрыМетода.Добавить(Конструктор.НеобязательныйПараметрВСтроку(Значение));

		Конструктор.ДобавитьСтроку("%1.Вставить(%2);", 
			ИмяПараметра,
			Конструктор.ПараметрыФункцииВСтроку(ПараметрыМетода));
		
	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьТекстовыеДанныеЗапросаЧерезСтроку(НазначениеДанных, ИмяПараметра, РезультатСборка)

	Сборка = УниверсальныеБлокиКода.СборкаДанныхЗапросаВСтроку(
		НазначениеДанных,
		ОписаниеЗапроса.ОтправляемыеТекстовыеДанные, 
		ПрочитанныеФайлы);

	Если ЗначениеЗаполнено(Сборка) Тогда
		Если СтрЧислоСтрок(Сборка) = 1 Тогда
			РезультатСборка = Сборка;
		Иначе
			Конструктор
				.ДобавитьПустуюСтроку()
				.ДобавитьСтроку("%1 = %2;", ИмяПараметра, Сборка);

			РезультатСборка = ИмяПараметра;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьПоследовательнуюОтправкуДвоичныхДанныхРесурса(ОписаниеРесурса)

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
			Конструктор
				.ДобавитьПустуюСтроку()
				.ДобавитьКомментарий("Передача файла %1. %2", НомерФайла, ИмяФайла);
		КонецЕсли;

		СтруктураURL = Новый ПарсерURL(ОписаниеРесурса.URL);
		Если ПередаваемыйФайл.ДобавлятьИмяФайлаКURL Тогда
			СтруктураURL.Путь = ОбщегоНазначения.ДополнитьИменемФайлаПутьURL(ПередаваемыйФайл.ИмяФайла, СтруктураURL.Путь);
		КонецЕсли;

		Конструктор.ДобавитьСтроку("%1 = Новый ДвоичныеДанные(%2);", 
			ИмяПараметраДанныеЗапроса, 
			Конструктор.ПараметрВСтроку(ПередаваемыйФайл.ИмяФайла));

		ДобавитьВызовМетода(ОписаниеРесурса, СтруктураURL, ИмяПараметраДанныеЗапроса);

	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьАутентификацию()

	ДобавитьАутентификациюBasic();
	ДобавитьАутентификациюBearer();

КонецПроцедуры

Процедура ДобавитьАутентификациюBasic()

	Если Не Состояние.ТипАутентификации = ТипАутентификацииBasic() Тогда
		Возврат;
	КонецЕсли;

	ПараметрыМетода = Новый Массив();
	ПараметрыМетода.Добавить(Конструктор.ПараметрВСтроку(ОписаниеЗапроса.ИмяПользователя));
	ПараметрыМетода.Добавить(Конструктор.НеобязательныйПараметрВСтроку(ОписаниеЗапроса.ПарольПользователя));

	Конструктор
		.ДобавитьПустуюСтроку()
		.ДобавитьСтроку("%1 = Новый Структура(""Пользователь, Пароль"", %2, %3);", 
			ИмяПараметраАутентификация,
			Конструктор.ПараметрВСтроку(ОписаниеЗапроса.ИмяПользователя),
			Конструктор.ПараметрВСтроку(ОписаниеЗапроса.ПарольПользователя));

КонецПроцедуры

Процедура ДобавитьАутентификациюBearer()

	Если Не Состояние.ТипАутентификации = ТипАутентификацииBearer() Тогда
		Возврат;
	КонецЕсли;

	Конструктор
		.ДобавитьПустуюСтроку()
		.ДобавитьСтроку("%1 = Новый Структура(""Токен, Тип"", %2, ""Bearer"");", 
			ИмяПараметраАутентификация,
			Конструктор.ПараметрВСтроку(ПолучитьТокенBearer()));

КонецПроцедуры

Процедура ДобавитьПрокси()

	Если Не ОписаниеЗапроса.ИспользуетсяПрокси() Тогда
		Возврат;
	КонецЕсли;

	Если Не ОбщегоНазначения.ПротоколПроксиПоддерживатся(ОписаниеЗапроса.ПроксиПротокол) Тогда
		ТекстОшибки = СтрШаблон("Прокси протокол %1 не поддерживается", ОписаниеЗапроса.ПроксиПротокол);
		ИсходящиеОшибки.Добавить(ОбщегоНазначения.НоваяКритичнаяОшибка(ТекстОшибки));
		Возврат;
	КонецЕсли;

	Конструктор
		.ДобавитьПустуюСтроку()
		.ДобавитьСтроку(УниверсальныеБлокиКода.СозданиеИнтернетПрокси(ОписаниеЗапроса, ИмяПараметраПрокси));

КонецПроцедуры

Процедура ДобавитьЗапросы()
	
	МаксимальнаяДлинаАдресаВКомментарии = 100;
		
	КоличествоURL = ОписаниеЗапроса.АдресаРесурсов.Количество();
	НомерЗапроса = 0;

	Для Каждого ОписаниеРесурса Из ОписаниеЗапроса.АдресаРесурсов Цикл
		
		НомерЗапроса = НомерЗапроса + 1;
		СтруктураURL = Новый ПарсерURL(ОписаниеРесурса.URL);
		Состояние.ВызванМетодПоТекущемуURL = Ложь;

		Если Не ОбщегоНазначения.ЭтоHTTP(СтруктураURL.Схема) Тогда
			ТекстОшибки = СтрШаблон("Протокол ""%1"" не поддерживается", СтруктураURL.Схема);
			ИсходящиеОшибки.Добавить(ОбщегоНазначения.НоваяКритичнаяОшибка(ТекстОшибки));
		КонецЕсли;
			
		Конструктор.ДобавитьПустуюСтроку();

		Если КоличествоURL > 1 Тогда	
			Конструктор.ДобавитьКомментарий("Запрос %1. %2", 
				НомерЗапроса, 
				Лев(ОписаниеРесурса.URL, МаксимальнаяДлинаАдресаВКомментарии));
		КонецЕсли;

		ДобавитьПоследовательнуюОтправкуДвоичныхДанныхРесурса(ОписаниеРесурса);

		Если Не Состояние.ВызванМетодПоТекущемуURL Тогда
			ДобавитьВызовМетода(ОписаниеРесурса);
		КонецЕсли;

		Если ОбщегоНазначения.ЕстьКритичныеОшибки(ИсходящиеОшибки) Тогда
			Конструктор.Очистить();
			Возврат;
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

Процедура ДобавитьВызовМетода(ОписаниеРесурса, Знач СтруктураURL = Неопределено, Знач ДанныеЗапроса = Неопределено)

	Если СтруктураURL = Неопределено Тогда
		СтруктураURL = Новый ПарсерURL(ОписаниеРесурса.URL);
	КонецЕсли;

	Если ДанныеЗапроса = Неопределено Тогда
		ДанныеЗапроса = ДанныеЗапросаСборка;
	КонецЕсли;

	ДобавитьURL(СтруктураURL);
	ДобавитьДополнительныеПараметры(ОписаниеРесурса, ДанныеЗапроса);

	ИмяФункции = ИмяФункцииБиблиотекиПоМетоду(ОписаниеРесурса.Метод);
	ПараметрыФункции = Новый Массив;

	Если ОписаниеРесурса.Метод = "GET" Тогда

		ПараметрПараметрыЗапроса = "";
		Если Состояние.ПереданаСтрокаЗапроса 
			И ВозможнаПередачаДанныхЧерезСоответствие(НазначенияПередаваемыхДанных.СтрокаЗапроса) Тогда
			ПараметрПараметрыЗапроса = ИмяПараметраПараметрыЗапроса;
		КонецЕсли;

		ПараметрыФункции.Добавить(URLСборка);
		ПараметрыФункции.Добавить(ПараметрПараметрыЗапроса);

	ИначеЕсли ВозможноПередатьДанныеЗапросаВПараметрыФункцииВызоваМетода(ОписаниеРесурса.Метод) Тогда

		ПараметрыФункции.Добавить(URLСборка);
		ПараметрыФункции.Добавить(ДанныеЗапроса);

	ИначеЕсли ОписаниеРесурса.Метод = "HEAD" Или ОписаниеРесурса.Метод = "OPTIONS" Тогда

		ПараметрыФункции.Добавить(URLСборка);
		
	Иначе

		ПараметрыФункции.Добавить(Конструктор.ПараметрВСтроку(ОписаниеРесурса.Метод));
		ПараметрыФункции.Добавить(URLСборка);

		ИмяФункции = "ВызватьМетод";

	КонецЕсли;

	Если Состояние.ЕстьДополнительныеПараметры Тогда
		ПараметрыФункции.Добавить(ИмяПараметраДополнительныеПараметры);
	КонецЕсли;

	Конструктор.ДобавитьСтроку("Результат = КоннекторHTTP.%1(%2);", 
		ИмяФункции,
		Конструктор.ПараметрыФункцииВСтроку(ПараметрыФункции));

	Состояние.ВызванМетодПоТекущемуURL = Истина;

КонецПроцедуры

Процедура ДобавитьURL(СтруктураURL)

	URLСборка = "";
	НазначениеДанных = НазначенияПередаваемыхДанных.СтрокаЗапроса;
	
	Если Состояние.ПереданаСтрокаЗапроса
		И ВозможнаПередачаДанныхЧерезСоответствие(НазначениеДанных) Тогда
		URLСборка = УниверсальныеБлокиКода.СборкаURL(СтруктураURL);
	Иначе
		URLСборка = УниверсальныеБлокиКода.СборкаURL(СтруктураURL,
			ОписаниеЗапроса.ОтправляемыеТекстовыеДанные, 
			ПрочитанныеФайлы);
	КонецЕсли;

	Если СтрЧислоСтрок(URLСборка) > 1 Тогда
		Конструктор
			.ДобавитьСтроку("%1 = %2;", ИмяПараметраURL, URLСборка)
			.ДобавитьПустуюСтроку();

		URLСборка = ИмяПараметраURL;
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьДополнительныеПараметры(ОписаниеРесурса, ДанныеЗапроса)

	Состояние.ЕстьДополнительныеПараметры = Ложь;

	КонструкторДопПараметров = Новый КонструкторПрограммногоКода();

	ДобавитьЗаголовкиВДополнительныеПараметры(КонструкторДопПараметров);
	ДобавитьАутентификациюВДополнительныеПараметры(КонструкторДопПараметров);
	ДобавитьПроксиВДополнительныеПараметры(КонструкторДопПараметров);
	ДобавитьСертификатыВДополнительныеПараметры(КонструкторДопПараметров);
	ДобавитьТаймаутВДополнительныеПараметры(КонструкторДопПараметров);
	ДобавитьПараметрыЗапросаВДополнительныеПараметры(КонструкторДопПараметров, ОписаниеРесурса);
	ДобавитьДанныеВДополнительныеПараметры(КонструкторДопПараметров, ОписаниеРесурса, ДанныеЗапроса);

	Если Не КонструкторДопПараметров.Пустой() Тогда
		Состояние.ЕстьДополнительныеПараметры = Истина;

		Конструктор
			.ДобавитьСтроку("%1 = Новый Структура();", ИмяПараметраДополнительныеПараметры)
			.ДобавитьСтроку(КонструкторДопПараметров.ПолучитьРезультат())
			.ДобавитьПустуюСтроку();
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьЗаголовкиВДополнительныеПараметры(КонструкторДопПараметров)

	Если Не Состояние.ЕстьЗаголовки Тогда
		Возврат;
	КонецЕсли;

	КонструкторДопПараметров.ДобавитьСтроку("%1.Вставить(""Заголовки"", %2);", 
		ИмяПараметраДополнительныеПараметры,
		ИмяПараметраЗаголовки);

КонецПроцедуры

Процедура ДобавитьПроксиВДополнительныеПараметры(КонструкторДопПараметров)
	
	Если Не ОписаниеЗапроса.ИспользуетсяПрокси() Тогда
		Возврат;
	КонецЕсли;

	КонструкторДопПараметров.ДобавитьСтроку("%1.Вставить(""Прокси"", %2);", 
		ИмяПараметраДополнительныеПараметры,
		ИмяПараметраПрокси);	

КонецПроцедуры

Процедура ДобавитьАутентификациюВДополнительныеПараметры(КонструкторДопПараметров)

	Если Не ЗначениеЗаполнено(Состояние.ТипАутентификации) Тогда
		Возврат;
	КонецЕсли;

	КонструкторДопПараметров.ДобавитьСтроку("%1.Вставить(""Аутентификация"", %2);", 
		ИмяПараметраДополнительныеПараметры,
		ИмяПараметраАутентификация);

КонецПроцедуры

Процедура ДобавитьТаймаутВДополнительныеПараметры(КонструкторДопПараметров)

	Таймаут = 0;
	Если ЗначениеЗаполнено(ОписаниеЗапроса.Таймаут) И ЗначениеЗаполнено(ОписаниеЗапроса.ТаймаутСоединения) Тогда
		Таймаут = ОписаниеЗапроса.Таймаут + ОписаниеЗапроса.ТаймаутСоединения;
	Иначе
		Возврат;
	КонецЕсли;

	КонструкторДопПараметров.ДобавитьСтроку("%1.Вставить(""Таймаут"", %2);", 
		ИмяПараметраДополнительныеПараметры,
		Конструктор.ПараметрВСтроку(Таймаут));

КонецПроцедуры

Процедура ДобавитьСертификатыВДополнительныеПараметры(КонструкторДопПараметров)
	
	// Сертификаты УЦ
	Если ЗначениеЗаполнено(ОписаниеЗапроса.ИмяФайлаСертификатовУЦ) Тогда
			
		КонструкторДопПараметров.ДобавитьСтроку(
			"%1.Вставить(""ПроверятьSSL"", Новый СертификатыУдостоверяющихЦентровФайл(%2));", 
			ИмяПараметраДополнительныеПараметры,
			Конструктор.ПараметрВСтроку(ОписаниеЗапроса.ИмяФайлаСертификатовУЦ));

	КонецЕсли;

	// Сертификат клиента
	Если ЗначениеЗаполнено(ОписаниеЗапроса.ИмяФайлаСертификатаКлиента) Тогда

		ПараметрыОбъекта = Новый Массив;
		ПараметрыОбъекта.Добавить(Конструктор.ПараметрВСтроку(ОписаниеЗапроса.ИмяФайлаСертификатаКлиента));
		ПараметрыОбъекта.Добавить(Конструктор.НеобязательныйПараметрВСтроку(ОписаниеЗапроса.ПарольСертификатаКлиента));
		
		КонструкторДопПараметров.ДобавитьСтроку(
			"%1.Вставить(""КлиентскийСертификатSSL"", Новый СертификатКлиентаФайл(%2));", 
			ИмяПараметраДополнительныеПараметры,
			КонструкторДопПараметров.ПараметрыФункцииВСтроку(ПараметрыОбъекта));

	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьПараметрыЗапросаВДополнительныеПараметры(КонструкторДопПараметров, ОписаниеРесурса)
	
	Если Состояние.ПереданаСтрокаЗапроса
		И ВозможнаПередачаДанныхЧерезСоответствие(НазначенияПередаваемыхДанных.СтрокаЗапроса)
		И Не ВозможноПередатьПараметрыЗапросаВПараметрыФункцииВызоваМетода(ОписаниеРесурса.Метод) Тогда
		КонструкторДопПараметров.ДобавитьСтроку("%1.Вставить(""ПараметрыЗапроса"", %2);", 
			ИмяПараметраДополнительныеПараметры,
			ИмяПараметраПараметрыЗапроса);
	КонецЕсли;

КонецПроцедуры

Процедура ДобавитьДанныеВДополнительныеПараметры(КонструкторДопПараметров, ОписаниеРесурса, ДанныеЗапроса)
	
	Если ЗначениеЗаполнено(ДанныеЗапроса)
		И Не ВозможноПередатьДанныеЗапросаВПараметрыФункцииВызоваМетода(ОписаниеРесурса.Метод) Тогда
		КонструкторДопПараметров.ДобавитьСтроку("%1.Вставить(""Данные"", %2);", 
			ИмяПараметраДополнительныеПараметры,
			ДанныеЗапроса);
	КонецЕсли;

КонецПроцедуры

Функция ВозможноПередатьДанныеЗапросаВПараметрыФункцииВызоваМетода(Метод)
	Возврат Метод = "POST" Или Метод = "PUT" Или Метод = "PATCH" Или Метод = "DELETE";
КонецФункции

Функция ВозможноПередатьПараметрыЗапросаВПараметрыФункцииВызоваМетода(Метод)
	Возврат Метод = "GET";
КонецФункции

Функция ВозможнаПередачаДанныхЧерезСоответствие(Назначение)

	РазделительКлючаИЗначения = "=";

	Для Каждого ПередаваемыйТекст Из ОписаниеЗапроса.ОтправляемыеТекстовыеДанные Цикл
		Если Не ПередаваемыйТекст.Назначение = Назначение Тогда
			Продолжить;
		КонецЕсли;

		РазделительОтличенОтАмперсанда = Не ПередаваемыйТекст.РазделительТелаЗапроса = "&";
		ОтсутствуетИмяПараметра = Лев(ПередаваемыйТекст.Значение, 1) = РазделительКлючаИЗначения;

		Если РазделительОтличенОтАмперсанда Или ОтсутствуетИмяПараметра Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;

	Для Каждого ПрочитанныйФайл Из ПрочитанныеФайлы Цикл
		Если ПрочитанныйФайл.ПередаваемыйФайл.Назначение = Назначение Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЦикла;

	Возврат Истина;
	
КонецФункции

Функция ПередаваемыеЗаголовки()
	Заголовки = Новый Соответствие();
	Для Каждого Заголовок Из ОписаниеЗапроса.Заголовки Цикл
		Если ПередаватьЗаголовок(Заголовок) Тогда
			Заголовки.Вставить(Заголовок.Ключ, Заголовок.Значение);
		КонецЕсли;
	КонецЦикла;
	Возврат Заголовки;
КонецФункции

Функция ПередаватьЗаголовок(Заголовок)
	
	Имя = НРег(Заголовок.Ключ);
	Значение = НРег(Заголовок.Значение);

	Если Имя = "content-type" Тогда
		Если Состояние.ПереданоТелоЗапроса 
			И Значение = "application/x-www-form-urlencoded" Тогда
			Возврат Ложь;
		КонецЕсли;
	ИначеЕсли Имя = "authorization" И СтрНачинаетсяС(Значение, "bearer ") Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;

КонецФункции

Функция ПолучитьТокенBearer()

	ЗначениеAuthorization = ОписаниеЗапроса.ЗначениеЗаголовка("Authorization");	
	Подстрока = "bearer ";

	Если СтрНачинаетсяС(НРег(ЗначениеAuthorization), Подстрока) Тогда
		Возврат СокрЛП(Сред(ЗначениеAuthorization, СтрДлина(Подстрока) + 1));
	КонецЕсли;

КонецФункции

Функция ПолучитьТипАутентификации()

	Если ЗначениеЗаполнено(ОписаниеЗапроса.ИмяПользователя) Тогда
		Возврат ТипАутентификацииBasic();
	ИначеЕсли Не ПолучитьТокенBearer() = Неопределено Тогда
		Возврат ТипАутентификацииBearer();
	КонецЕсли;

КонецФункции

Функция ТипАутентификацииBasic()
	Возврат "basic";
КонецФункции

Функция ТипАутентификацииBearer()
	Возврат "bearer";
КонецФункции

Функция НовоеСостояние()
	Результат = Новый Структура();
	
	Результат.Вставить("ПереданоТелоЗапроса", ОписаниеЗапроса.ПереданоТелоЗапроса());
	Результат.Вставить("ПереданаСтрокаЗапроса", ОписаниеЗапроса.ПереданаСтрокаЗапроса());
	Результат.Вставить("ЕстьЗаголовки", Ложь);
	Результат.Вставить("ЕстьДополнительныеПараметры", Ложь);
	Результат.Вставить("ВызванМетодПоТекущемуURL", Ложь);
	Результат.Вставить("ТипАутентификации", ПолучитьТипАутентификации());
	
	Возврат Результат;
КонецФункции

Функция ИмяФункцииБиблиотекиПоМетоду(Метод)
	Возврат Лев(Метод, 1) + НРег(Сред(Метод, 2));
КонецФункции

#КонецОбласти