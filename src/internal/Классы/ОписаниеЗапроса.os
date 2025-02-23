// BSLLS:ExportVariables-off

Перем АдресаРесурсов Экспорт; // Массив из Структура
                              //   - URL - Строка - Адрес ресурса
                              //   - Метод - Строка - Метод
                              //   - ИмяВыходногоФайла - Строка - Имя выходного файла
                              //   - Файлы - Массив из см. ПередаваемыйФайл - Файлы для HTTP PUT или FTP
Перем Заголовки Экспорт; // Соответствие из КлючИЗначение
Перем ТипАутентификации Экспорт; // см. ТипыАутентификации
Перем ИмяПользователя Экспорт; // Строка
Перем ПарольПользователя Экспорт; // Строка
Перем ОтправляемыеТекстовыеДанные Экспорт; // Массив из ПередаваемыйТекст
Перем Файлы Экспорт; // Массив из см. ПередаваемыйФайл
Перем ИмяФайлаСертификатаКлиента Экспорт; // Строка
Перем ПарольСертификатаКлиента Экспорт; // Строка
Перем ИспользоватьСертификатыУЦИзХранилищаОС Экспорт; // Булево
Перем ИмяФайлаСертификатовУЦ Экспорт; // Строка
Перем ПроксиПротокол Экспорт; // Строка
Перем ПроксиСервер Экспорт; // Строка
Перем ПроксиПорт Экспорт; // Число
Перем ПроксиПользователь Экспорт; // Строка
Перем ПроксиПароль Экспорт; // Строка
Перем ТипАутентификацииПрокси Экспорт; // см. ТипыАутентификации
Перем FTPПассивныйРежимСоединения Экспорт; // Булево
Перем FTPАдресОбратногоСоединения Экспорт; // Строка
Перем РазрешитьПеренаправление Экспорт; // Булево
Перем ЗапретитьПеренаправление Экспорт; // Булево
Перем МаксимальноеКоличествоПовторов Экспорт; // Число
Перем МаксимальноеВремяПовторов Экспорт; // Число
Перем ОтправлятьКакMultipartFormData Экспорт; // Булево
Перем AWS4 Экспорт; // Структура
Перем ТокенBearer Экспорт; // Строка
Перем СоздатьКаталогСохраненияФайлов Экспорт; // Булево

// Максимальное время ожидания на выполнение запроса
Перем Таймаут Экспорт; // Число

// Максимальное время ожидания на попытку соединения к хосту
Перем ТаймаутСоединения Экспорт; // Число

#Область ПрограммныйИнтерфейс

Процедура ДобавитьАдресРесурса(URL, ИмяВыходногоФайла = "") Экспорт
	ОписаниеРесурса = НовоеОписаниеРесурса();
	ОписаниеРесурса.URL = URL;
	ОписаниеРесурса.ИмяВыходногоФайла = ИмяВыходногоФайла;
	АдресаРесурсов.Добавить(ОписаниеРесурса);
КонецПроцедуры

Процедура ДобавитьЗаголовок(Имя, Значение) Экспорт
	Заголовки.Вставить(Имя, Значение);
КонецПроцедуры

Функция ЗначениеЗаголовка(Имя) Экспорт

	Значение = Заголовки[Имя];
	Если Не Значение = Неопределено Тогда
		Возврат Значение;
	КонецЕсли;

	Возврат ОбщегоНазначения.НайтиВСоответствииПоКлючуБезУчетаРегистра(Заголовки, Имя);
	
КонецФункции

Функция ИспользуетсяПрокси() Экспорт
	Возврат ЗначениеЗаполнено(ПроксиСервер); 
КонецФункции

Функция ПереданоТелоЗапроса() Экспорт
	Возврат ЕстьДанныеПоНазначению(НазначенияПередаваемыхДанных.ТелоЗапроса);
КонецФункции

Функция ПереданаСтрокаЗапроса() Экспорт
	Возврат ЕстьДанныеПоНазначению(НазначенияПередаваемыхДанных.СтрокаЗапроса);
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПриСозданииОбъекта()
	АдресаРесурсов = Новый Массив;
	Заголовки = Новый Соответствие();
	ТипАутентификации = "";
	ИмяПользователя = "";
	ПарольПользователя = "";
	ОтправляемыеТекстовыеДанные = Новый Массив;
	Файлы = Новый Массив;
	ИмяФайлаСертификатаКлиента = "";
	ПарольСертификатаКлиента = "";
	ИспользоватьСертификатыУЦИзХранилищаОС = Ложь;
	ИмяФайлаСертификатовУЦ = "";
	ПроксиПротокол = "";
	ПроксиСервер = "";
	ПроксиПорт = 0;
	ПроксиПользователь = "";
	ПроксиПароль = "";
	ТипАутентификацииПрокси = "";
	Таймаут = 0;
	ТаймаутСоединения = 0;
	FTPПассивныйРежимСоединения = Ложь;
	FTPАдресОбратногоСоединения = "";
	РазрешитьПеренаправление = Ложь;
	ЗапретитьПеренаправление = Ложь;
	МаксимальноеКоличествоПовторов = 0;
	МаксимальноеВремяПовторов = 0;
	ОтправлятьКакMultipartFormData = Ложь;
	AWS4 = НовыйAWS4();
	ТокенBearer = "";
	СоздатьКаталогСохраненияФайлов = Ложь;
КонецПроцедуры

Функция ЕстьДанныеПоНазначению(Назначение) Экспорт

	Для Каждого ПередаваемыйТекст Из ОтправляемыеТекстовыеДанные Цикл
		Если ПередаваемыйТекст.Назначение = Назначение Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;

	Для Каждого ПередаваемыйФайл Из Файлы Цикл
		Если ПередаваемыйФайл.Назначение = Назначение Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;

	Возврат Ложь;

КонецФункции

Функция НовоеОписаниеРесурса()
	Описание = Новый Структура();
	Описание.Вставить("URL", "");
	Описание.Вставить("Метод", "");
	Описание.Вставить("ИмяВыходногоФайла", "");
	Описание.Вставить("Файлы", Новый Массив());
	Возврат Описание;
КонецФункции

Функция НовыйAWS4()	
	Результат = Новый Структура;
	Результат.Вставить("КлючДоступа", "");
	Результат.Вставить("СекретныйКлюч", "");
	Результат.Вставить("Сервис", "");
	Результат.Вставить("Регион", "");
	Возврат Результат;
КонецФункции

#КонецОбласти