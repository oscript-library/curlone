#Использовать "../../lexer"

Перем Спек;

Перем Опции; // Структура Ключ - Значение (Структура описание опции)
Перем Аргументы; // Структура  

Перем ОпцииИндекс; // Соответствие
Перем АргументыИндекс; // Соответствие

Перем ТокеныПарсера;

Перем ТекущаяПозиция;
Перем НайденныйТокен;

Перем СкинутьОпции;
Перем ТипыТокенов;

Перем ОбработчикВыборкиПути;

Перем Лог;

Процедура ПриСозданииОбъекта(Знач ТокеныСпек, Знач ПараметрыПарсера)

	ТокеныПарсера = ТокеныСпек;
	Опции = ПараметрыПарсера.Опции;
	Аргументы = ПараметрыПарсера.Аргументы;
	ОпцииИндекс = ПараметрыПарсера.ОпцииИндекс;
	АргументыИндекс = ПараметрыПарсера.АргументыИндекс;
	Спек = ПараметрыПарсера.Спек;
	
	Лог.Отладка("Спек %1", Спек);
	Лог.Отладка("Количество опций: %1", Опции.Количество());
	
	ТекущаяПозиция = 0;

	СкинутьОпции = Ложь;

	ТипыТокенов = Токены.ТипыТокенов();
	
	ОбработчикВыборкиПути = Новый ВыборСовпадений();
	
КонецПроцедуры

// Выполняет чтение аргументов строки
//
//  Возвращаемое значение:
//   Объект - ссылка на класс "Совпадение"
//
Функция Прочитать() Экспорт

	Лог.Отладка("Начинаю чтение спека %1", Спек);
	Лог.Отладка("Количество токенов %1", ТокеныПарсера.Количество());

	Результат = ПрочитатьРекурсивно(Ложь, Истина);
		
	Если Не КонецТокенов() Тогда
		ВызватьИсключение "Косяк ппц что делать";
	КонецЕсли;

	НачальноеСостояние = Результат.НачальноеСостояние;
	КонечноеСостояние = Результат.КонечноеСостояние;
	
	КонечноеСостояние.Завершено = Истина;
	НачальноеСостояние.Подготовить();
	
	Возврат НачальноеСостояние;

КонецФункции

Функция ПрочитатьРекурсивно(Требуется, Обязательное)

	Лог.Отладка("Рекурсивное чтение %1", Требуется);
	
	НачальноеСостояние = ОбработчикВыборкиПути.НовоеСостояние();
	КонечноеСостояние = НачальноеСостояние;

	Если Требуется Тогда

		Результат = ТокенВыбора(Обязательное);
		
		Для каждого Соединение Из Результат.НачальноеСостояние.МассивСоединений Цикл
			КонечноеСостояние.Т(Соединение.Парсер, Соединение.СледующееСостояние, Соединение.Обязательное);
		КонецЦикла;
	
		КонечноеСостояние = Результат.КонечноеСостояние;
	
	КонецЕсли;

	Пока МогуПрочитать() Цикл

		РезультатВЦикле = ТокенВыбора(Обязательное);
		
		Для каждого Соединение Из РезультатВЦикле.НачальноеСостояние.МассивСоединений Цикл
			КонечноеСостояние.Т(Соединение.Парсер, Соединение.СледующееСостояние, Соединение.Обязательное);
		КонецЦикла;
	
		КонечноеСостояние = РезультатВЦикле.КонечноеСостояние;

	КонецЦикла;

	Возврат Новый Структура("НачальноеСостояние, КонечноеСостояние", НачальноеСостояние, КонечноеСостояние);
		
КонецФункции

Функция ЧтениеДалее(Обязательное)
	
	Лог.Отладка("Вызов <ЧтениеДалее>");

	НачальноеСостояние = ОбработчикВыборкиПути.НовоеСостояние();
	КонечноеСостояние = Неопределено;

	Если КонецТокенов() Тогда
		ВызватьИсключение "Не правильная строка использования";

	ИначеЕсли НашлиТокен(ТипыТокенов.TTArg) Тогда

		Имя = НайденныйТокен.Значение;

		КлассОпции = АргументыИндекс[Имя];
		Если КлассОпции = Неопределено Тогда
			Назад();
			ВызватьИсключение "Нашли не объявленный аргумент";
		КонецЕсли;

		КонечноеСостояние = НачальноеСостояние.Т(Новый АргументыПарсера(КлассОпции), 
												 ОбработчикВыборкиПути.НовоеСостояние(),
												 Обязательное);
		
	ИначеЕсли НашлиТокен(ТипыТокенов.TTOptions) Тогда

		Если СкинутьОпции Тогда
			Назад();
			Сообщить("нет опций после --");
			ВызватьИсключение "нет опций после --";
		КонецЕсли;
		КонечноеСостояние = ОбработчикВыборкиПути.НовоеСостояние();
		НачальноеСостояние.Т(Новый ВсеОпцииПарсера(Опции, ОпцииИндекс), КонечноеСостояние, Ложь);
	ИначеЕсли НашлиТокен(ТипыТокенов.TTAny) Тогда

		Если СкинутьОпции Тогда
			Назад();
			Сообщить("нет опций после --");
			ВызватьИсключение "нет опций после --";
		КонецЕсли;
		КонечноеСостояние = ОбработчикВыборкиПути.НовоеСостояние();
		НачальноеСостояние.Т(Новый ВсеОпцииИАргументыПарсера(Опции, ОпцииИндекс, Аргументы, АргументыИндекс), КонечноеСостояние, Ложь);
	ИначеЕсли НашлиТокен(ТипыТокенов.TTShortOpt)
		ИЛИ НашлиТокен(ТипыТокенов.TTLongOpt) Тогда

		Лог.Отладка("Обрабатываю токен: %1", НайденныйТокен.Тип);
		Если СкинутьОпции Тогда
			Назад();
			Сообщить("нет опций после --");
			ВызватьИсключение "нет опций после --";
		КонецЕсли;

		Имя = НайденныйТокен.Значение;
		КлассОпции = ОпцииИндекс[Имя];
		Лог.Отладка("		>> Имя токен: %1", НайденныйТокен.Значение);
		Лог.Отладка("		>> класс опции: %1", КлассОпции.Имя);
	
		Если КлассОпции = Неопределено Тогда
			Назад();
			Сообщить("Нашли не объявленную опцию");
			ВызватьИсключение "Ошибка";
		КонецЕсли;

		КонечноеСостояние = НачальноеСостояние.Т(Новый ОпцияПарсера(КлассОпции, ОпцииИндекс),
												 ОбработчикВыборкиПути.НовоеСостояние(),
												 Обязательное);
		Лог.Отладка("		>> НачальноеСостояние.МассивСоединений: %1", НачальноеСостояние.МассивСоединений.Количество());
		
		НашлиТокен(ТипыТокенов.TTOptValue); // Пропуск значение после "=" 

	ИначеЕсли НашлиТокен(ТипыТокенов.TTOptSeq) Тогда

		Если СкинутьОпции Тогда
			Назад();
			Сообщить("нет опций после --");
			ВызватьИсключение "нет опций после --";
		КонецЕсли;

		КонечноеСостояние = ОбработчикВыборкиПути.НовоеСостояние();

		ДоступныеОпции = НайденныйТокен.Значение;
		Если СтрНачинаетсяС(ДоступныеОпции, "-") Тогда
			ДоступныеОпции = Прав(ДоступныеОпции, СтрДлина(ДоступныеОпции) - 1);
		КонецЕсли;
		МассивДоступныхОпций  = Новый Соответствие;
		ДлинаОпций = СтрДлина(ДоступныеОпции);
		Для ИИ = 1 По ДлинаОпций Цикл
			
			ИмяОпции = Сред(ДоступныеОпции, ИИ, 1);
			
			КлассОпции = ОпцииИндекс["-" + ИмяОпции];
			
			Если КлассОпции = Неопределено Тогда
				Назад();
				Сообщить("Нашли не объявленную опцию");
				ВызватьИсключение "Ошибка Нашли не объявленную опцию";
			КонецЕсли;
	
			МассивДоступныхОпций.Вставить(КлассОпции, КлассОпции);

		КонецЦикла;		

		НачальноеСостояние.Т(Новый ВсеОпцииПарсера(МассивДоступныхОпций, ОпцииИндекс), КонечноеСостояние, Ложь);

	ИначеЕсли НашлиТокен(ТипыТокенов.TTOpenPar) Тогда

		РезультатЧтения = ПрочитатьРекурсивно(Истина, Истина);

		НачальноеСостояние = РезультатЧтения.НачальноеСостояние;
		КонечноеСостояние = РезультатЧтения.КонечноеСостояние;

		ОжидаюТокен(ТипыТокенов.TTClosePar);

	ИначеЕсли НашлиТокен(ТипыТокенов.TTOpenSq) Тогда

		РезультатЧтения = ПрочитатьРекурсивно(Истина, Ложь);
		
		НачальноеСостояние = РезультатЧтения.НачальноеСостояние;
		КонечноеСостояние = РезультатЧтения.КонечноеСостояние;
		НачальноеСостояние.Т(Новый ЛюбойСимвол(), КонечноеСостояние, Ложь);

		ОжидаюТокен(ТипыТокенов.TTCloseSq);

	ИначеЕсли НашлиТокен(ТипыТокенов.TTDoubleDash) Тогда
		
		СкинутьОпции = Истина;
		КонечноеСостояние = НачальноеСостояние.Т(Новый ОпцииЗавершениеПарсера(), 
			ОбработчикВыборкиПути.НовоеСостояние(), Ложь);
		
		Возврат Новый Структура("НачальноеСостояние, КонечноеСостояние", НачальноеСостояние, КонечноеСостояние);
	Иначе
		ВызватьИсключение "Все плохо сэр. Паника";
	КонецЕсли;

	Если НашлиТокен(ТипыТокенов.TTRep) Тогда
		КонечноеСостояние.Т(Новый ЛюбойСимвол(), НачальноеСостояние, Ложь);
	
	КонецЕсли;

	Если КонечноеСостояние = Неопределено Тогда
		ВызватьИсключение "Не могу правильно построить маршрут";
	КонецЕсли;
	
	Возврат Новый Структура("НачальноеСостояние, КонечноеСостояние", НачальноеСостояние, КонечноеСостояние);
	
КонецФункции

Функция ТокенВыбора(Обязательное)
	
	Лог.Отладка("Вызов <ТокенВыбора>");
		
	НачальноеСостояние = ОбработчикВыборкиПути.НовоеСостояние();
	КонечноеСостояние = ОбработчикВыборкиПути.НовоеСостояние();

	Результат = ЧтениеДалее(Обязательное);
	
	НачальноеСостояние.Т(Новый ЛюбойСимвол(), Результат.НачальноеСостояние);
	Результат.КонечноеСостояние.Т(Новый ЛюбойСимвол(), КонечноеСостояние);

	Пока НашлиТокен(ТипыТокенов.TTChoice) Цикл
		Лог.Отладка("Нашли токен %1", ТипыТокенов.TTChoice);
	
		РезультатВЦикле = ЧтениеДалее(Обязательное);
		
		НачальноеСостояние.Т(Новый ЛюбойСимвол(), РезультатВЦикле.НачальноеСостояние);
		РезультатВЦикле.КонечноеСостояние.Т(Новый ЛюбойСимвол(), КонечноеСостояние);
	
	КонецЦикла;
	
	Возврат Новый Структура("НачальноеСостояние, КонечноеСостояние", НачальноеСостояние, КонечноеСостояние);
	
КонецФункции

Процедура ОжидаюТокен(ТипТокена)

	Если НЕ НашлиТокен(ТипТокена) Тогда
		ВызватьИсключение "Не найден ожидаемый токен " + ТипТокена;
	КонецЕсли;
	
КонецПроцедуры

Функция КонецТокенов()

	Возврат ТекущаяПозиция >= ТокеныПарсера.Количество();
			
КонецФункции

Процедура Назад()
	
	ТекущаяПозиция = ТекущаяПозиция - 1;
			
КонецПроцедуры

Функция Токен()

	Если КонецТокенов() Тогда
		Возврат Неопределено;
	КонецЕсли;

	Возврат ТокеныПарсера[ТекущаяПозиция];
	
КонецФункции

Функция ЭтоТокен(Знач ТипТокена)

	Если КонецТокенов() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Токен().Тип = ТипТокена;
	
КонецФункции

Функция МогуПрочитать()

	Если ЭтоТокен(ТипыТокенов.TTArg)
		ИЛИ ЭтоТокен(ТипыТокенов.TTOptions)
		ИЛИ ЭтоТокен(ТипыТокенов.TTAny)
		ИЛИ ЭтоТокен(ТипыТокенов.TTShortOpt)
		ИЛИ ЭтоТокен(ТипыТокенов.TTLongOpt)
		ИЛИ ЭтоТокен(ТипыТокенов.TTOptSeq)
		ИЛИ ЭтоТокен(ТипыТокенов.TTOpenPar)
		ИЛИ ЭтоТокен(ТипыТокенов.TTOpenSq)
		ИЛИ ЭтоТокен(ТипыТокенов.TTDoubleDash)
		Тогда

		Возврат Истина;

	Иначе

		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

Функция НашлиТокен(Знач ТипТокена)

	Если ЭтоТокен(ТипТокена) Тогда

		Лог.Отладка("Нашли токен: %1", ТипТокена);
		НайденныйТокен = Токен();
		
		ТекущаяПозиция = ТекущаяПозиция + 1;

		ЛОг.Отладка("Текущая позиция: %1", ТекущаяПозиция);

		Возврат Истина;

	КонецЕсли;

	Возврат Ложь;

КонецФункции

Лог = Логирование.ПолучитьЛог("oscript.lib.spec_parse");