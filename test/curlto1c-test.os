#Использовать logos
#Использовать asserts
#Использовать ".."

Перем юТест;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт

	юТест = Тестирование;
	
	СписокТестов = Новый Массив;
	
	СписокТестов.Добавить("ТестДолжен_ПолучитьПрограммныйКод");

	Возврат СписокТестов;
	
КонецФункции

Процедура ПередЗапускомТеста() Экспорт
	
	Лог = Логирование.ПолучитьЛог("oscript.lib.curlto1c");
	Лог.УстановитьУровень(УровниЛога.Информация);
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
	юТест.УдалитьВременныеФайлы();
	Лог = Неопределено;

КонецПроцедуры

Процедура ТестДолжен_ПолучитьПрограммныйКод() Экспорт

	КоманднаяСтрока = "curl ^""https://curl.se/^"" ^
	| -H ^""accept: text/html^"" ^
	| -H ^""accept-language: ru,en-US;q=0.9,en;q=0.8^""";
	ПрограммныйКод = "...";

	Конвертор = Новый КонвертерКоманднойСтрокиCURL(КоманднаяСтрока);
	Результат = Конвертор.ПолучитьПрограммныйКод();

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры
