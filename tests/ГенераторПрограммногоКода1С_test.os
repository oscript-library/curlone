#Использовать asserts
#Использовать ".."

Перем юТест;

Функция ПолучитьСписокТестов(Знач Тестирование) Экспорт

	юТест = Тестирование;
	
	СписокТестов = Новый Массив;
	
	СписокТестов.Добавить("ТестДолжен_ПроверитьЗаголовки");
	СписокТестов.Добавить("ТестДолжен_ПроверитьПередачуМетода");
	СписокТестов.Добавить("ТестДолжен_ПроверитьПередачуПользователя");
	СписокТестов.Добавить("ТестДолжен_ПроверитьПередачуТекстовыхДанных");
	СписокТестов.Добавить("ТестДолжен_ПроверитьПередачуТекстовыхДанныхСКодированием");
	СписокТестов.Добавить("ТестДолжен_ПроверитьПередачуДвоичныхДанныхDataBinary");
	СписокТестов.Добавить("ТестДолжен_ПроверитьПередачуДвоичныхДанныхUploadFile");
	СписокТестов.Добавить("ТестДолжен_ПроверитьНеизменностьПереданногоЗаголовкаContentType");
	СписокТестов.Добавить("ТестДолжен_ПроверитьМножественноеИспользованиеUrl");
	СписокТестов.Добавить("ТестДолжен_ПроверитьПередачуОтправляемыхДанныхВСтрокуЗапроса");
	СписокТестов.Добавить("ТестДолжен_ПроверитьПередачуОтправляемыхДанныхВСтрокуЗапросаИзФайла");
	СписокТестов.Добавить("ТестДолжен_ПроверитьВставкуОтправляемыхДанныхВСтрокуЗапроса");
	СписокТестов.Добавить("ТестДолжен_ПроверитьHTTPМетодHEAD");
	СписокТестов.Добавить("ТестДолжен_ПроверитьОбработкуНесколькихКоманд");
	СписокТестов.Добавить("ТестДолжен_ПроверитьОтсутствиеИспользованияЗащищенногоСоединения");
	СписокТестов.Добавить("ТестДолжен_ПроверитьНаличиеИспользованияЗащищенногоСоединения");	
	СписокТестов.Добавить("ТестДолжен_ПроверитьИспользованиеСертификатаКлиентаСПаролем");
	СписокТестов.Добавить("ТестДолжен_ПроверитьИспользованиеСертификатаКлиентаБезПароля");
	СписокТестов.Добавить("ТестДолжен_ПроверитьИспользованиеСертификатаКлиентаИСертификатыУЦИзОС");
	СписокТестов.Добавить("ТестДолжен_ПроверитьИспользованиеСертификатаКлиентаИСертификатыУЦИзФайла");
	СписокТестов.Добавить("ТестДолжен_ПроверитьПередачуПараметровЗапроса");
	СписокТестов.Добавить("ТестДолжен_ПроверитьПередачуПараметровЗапросаТолькоИзФайла");
	СписокТестов.Добавить("ТестДолжен_ПроверитьПереданноеИмяВыходногоФайла");
	СписокТестов.Добавить("ТестДолжен_ПроверитьПереданныеИменаВыходныхФайлов");
	СписокТестов.Добавить("ТестДолжен_ПроверитьИзвлечениеИмениВыходногоФайлаИзURL");
	СписокТестов.Добавить("ТестДолжен_ПроверитьИзвлечениеИмениВыходногоФайлаДляВсехURL");
	СписокТестов.Добавить("ТестДолжен_ПроверитьВыбрасываниеИсключенияПриИзвлеченииИмениВыходногоФайлаИзURL");
	СписокТестов.Добавить("ТестДолжен_ПроверитьКаталогСохраненияФайловИПереданноеИмяФайла");
	СписокТестов.Добавить("ТестДолжен_ПроверитьКаталогСохраненияФайловИИзвлеченноеИмяФайлаИзURL");
	
	Возврат СписокТестов;
	
КонецФункции

Процедура ТестДолжен_ПроверитьЗаголовки() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' \
	|  -H 'accept: text/html' \
	|  -H 'accept-language: ru,en-US;q=0.9,en;q=0.8' \
	|  -H 'user-agent: curl'";

	ПрограммныйКод = "Заголовки = Новый Соответствие();
	|Заголовки.Вставить(""accept"", ""text/html"");
	|Заголовки.Вставить(""accept-language"", ""ru,en-US;q=0.9,en;q=0.8"");
	|Заголовки.Вставить(""user-agent"", ""curl"");
	|
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"", Заголовки);
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПередачуМетода() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' -X 'POST'";

	ПрограммныйКод = "ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""POST"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПередачуПользователя() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' -u user:secret";

	ПрограммныйКод = "ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, ""user"", ""secret"", , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПередачуТекстовыхДанных() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' \
	|	-d param1=value1 \
	|	--data-ascii 'парам2=значение2' \
	|	--data 'param3=value3' \
	|	--data @path-to-file1 \
	|	--data @path-to-file2 \
	|	--data-raw '@at@at@'";

	ПрограммныйКод = "Заголовки = Новый Соответствие();
	|Заголовки.Вставить(""Content-Type"", ""application/x-www-form-urlencoded"");
	|
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|ТекстовыйДокумент = Новый ТекстовыйДокумент();
	|ТекстовыйДокумент.Прочитать(""path-to-file1"");
	|ТекстовыеДанныеИзФайла_1 = ТекстовыйДокумент.ПолучитьТекст();
	|ТекстовыеДанныеИзФайла_1 = СтрЗаменить(ТекстовыеДанныеИзФайла_1, Символы.ПС, """");
	|ТекстовыеДанныеИзФайла_1 = СтрЗаменить(ТекстовыеДанныеИзФайла_1, Символы.ВК, """");
	|
	|ТекстовыйДокумент = Новый ТекстовыйДокумент();
	|ТекстовыйДокумент.Прочитать(""path-to-file2"");
	|ТекстовыеДанныеИзФайла_2 = ТекстовыйДокумент.ПолучитьТекст();
	|ТекстовыеДанныеИзФайла_2 = СтрЗаменить(ТекстовыеДанныеИзФайла_2, Символы.ПС, """");
	|ТекстовыеДанныеИзФайла_2 = СтрЗаменить(ТекстовыеДанныеИзФайла_2, Символы.ВК, """");
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"", Заголовки);
	|
	|ТелоЗапроса = ""param1=value1&парам2=значение2&param3=value3&@at@at@""
	|	+ ""&"" + ТекстовыеДанныеИзФайла_1
	|	+ ""&"" + ТекстовыеДанныеИзФайла_2;
	|
	|HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""POST"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПередачуДвоичныхДанныхDataBinary() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' \
	|	--data-binary @path-to-file1 \
	|	--data-binary @path-to-file2";

	ПрограммныйКод = "Заголовки = Новый Соответствие();
	|Заголовки.Вставить(""Content-Type"", ""application/x-www-form-urlencoded"");
	|
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"", Заголовки);
	|HTTPЗапрос.УстановитьИмяФайлаТела(""path-to-file1"");
	|// HTTPЗапрос.УстановитьИмяФайлаТела(""path-to-file2"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""POST"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПередачуДвоичныхДанныхUploadFile() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' --upload-file path-to-file";

	ПрограммныйКод = "ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPЗапрос.УстановитьИмяФайлаТела(""path-to-file"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""PUT"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьНеизменностьПереданногоЗаголовкаContentType() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' \
	|	-H 'Content-Type: application/octet-stream' \
	|	--data-binary @path-to-file";

	ПрограммныйКод = "Заголовки = Новый Соответствие();
	|Заголовки.Вставить(""Content-Type"", ""application/octet-stream"");
	|
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"", Заголовки);
	|HTTPЗапрос.УстановитьИмяФайлаТела(""path-to-file"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""POST"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПередачуТекстовыхДанныхСКодированием() Экспорт

	КонсольнаяКоманда = "curl 'http://example.com' \
	|	--data-urlencode name=val \
	|	--data-urlencode =encodethis& \
	|	--data-urlencode name@file \
	|	--data-urlencode @fileonly";

	ПрограммныйКод = "Заголовки = Новый Соответствие();
	|Заголовки.Вставить(""Content-Type"", ""application/x-www-form-urlencoded"");
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|ТекстовыйДокумент = Новый ТекстовыйДокумент();
	|ТекстовыйДокумент.Прочитать(""file"");
	|ТекстовыеДанныеИзФайла_1 = ТекстовыйДокумент.ПолучитьТекст();
	|ТекстовыеДанныеИзФайла_1 = КодироватьСтроку(ТекстовыеДанныеИзФайла_1, СпособКодированияСтроки.URLВКодировкеURL);
	|ТекстовыеДанныеИзФайла_1 = ""name="" + ТекстовыеДанныеИзФайла_1;
	|
	|ТекстовыйДокумент = Новый ТекстовыйДокумент();
	|ТекстовыйДокумент.Прочитать(""fileonly"");
	|ТекстовыеДанныеИзФайла_2 = ТекстовыйДокумент.ПолучитьТекст();
	|ТекстовыеДанныеИзФайла_2 = КодироватьСтроку(ТекстовыеДанныеИзФайла_2, СпособКодированияСтроки.URLВКодировкеURL);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"", Заголовки);
	|
	|ТелоЗапроса = ""name=val&encodethis%26""
	|	+ ""&"" + ТекстовыеДанныеИзФайла_1
	|	+ ""&"" + ТекстовыеДанныеИзФайла_2;
	|
	|HTTPЗапрос.УстановитьТелоИзСтроки(ТелоЗапроса);
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""POST"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьМножественноеИспользованиеUrl() Экспорт

	КонсольнаяКоманда = "curl https://example1.com \
	|	https://example2.com \
	|	--url https://example3.com \
	|	--url https://example4.com";

	ПрограммныйКод = "ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example1.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);
	|
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example2.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);
	|
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example3.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);
	|
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example4.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПередачуОтправляемыхДанныхВСтрокуЗапроса() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' \
	|	--get \
	|	-d 'param1=value' \
	|	--data 'param2=value2' \
	|	--data @path-to-file";

	ПрограммныйКод = "ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|ТекстовыйДокумент = Новый ТекстовыйДокумент();
	|ТекстовыйДокумент.Прочитать(""path-to-file"");
	|ТекстовыеДанныеИзФайла_1 = ТекстовыйДокумент.ПолучитьТекст();
	|ТекстовыеДанныеИзФайла_1 = СтрЗаменить(ТекстовыеДанныеИзФайла_1, Символы.ПС, """");
	|ТекстовыеДанныеИзФайла_1 = СтрЗаменить(ТекстовыеДанныеИзФайла_1, Символы.ВК, """");
	|
	|АдресРесурса = ""/?param1=value&param2=value2""
	|	+ ""&"" + ТекстовыеДанныеИзФайла_1;
	|
	|HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса);
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПередачуОтправляемыхДанныхВСтрокуЗапросаИзФайла() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' \
	|	--get \
	|	--data @path-to-file";

	ПрограммныйКод = "ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|ТекстовыйДокумент = Новый ТекстовыйДокумент();
	|ТекстовыйДокумент.Прочитать(""path-to-file"");
	|ТекстовыеДанныеИзФайла_1 = ТекстовыйДокумент.ПолучитьТекст();
	|ТекстовыеДанныеИзФайла_1 = СтрЗаменить(ТекстовыеДанныеИзФайла_1, Символы.ПС, """");
	|ТекстовыеДанныеИзФайла_1 = СтрЗаменить(ТекстовыеДанныеИзФайла_1, Символы.ВК, """");
	|
	|АдресРесурса = ""/?""
	|	+ ТекстовыеДанныеИзФайла_1;
	|
	|HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса);
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьВставкуОтправляемыхДанныхВСтрокуЗапроса() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com?param3=value3#page-1' \
	|	--get \
	|	-d 'param1=value' \
	|	--data 'param2=value2' \
	|	--data @path-to-file";

	ПрограммныйКод = "ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|ТекстовыйДокумент = Новый ТекстовыйДокумент();
	|ТекстовыйДокумент.Прочитать(""path-to-file"");
	|ТекстовыеДанныеИзФайла_1 = ТекстовыйДокумент.ПолучитьТекст();
	|ТекстовыеДанныеИзФайла_1 = СтрЗаменить(ТекстовыеДанныеИзФайла_1, Символы.ПС, """");
	|ТекстовыеДанныеИзФайла_1 = СтрЗаменить(ТекстовыеДанныеИзФайла_1, Символы.ВК, """");
	|
	|АдресРесурса = ""/?param3=value3&param1=value&param2=value2""
	|	+ ""&"" + ТекстовыеДанныеИзФайла_1 
	|	+ ""#page-1"";
	|
	|HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса);
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьHTTPМетодHEAD() Экспорт

	КонсольнаяКоманда = "
	|curl 'https://example1.com' --head
	|curl 'https://example2.com' -X HEAD";

	ПрограммныйКод = "ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example1.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""HEAD"", HTTPЗапрос);
	|
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example2.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""HEAD"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьОбработкуНесколькихКоманд() Экспорт

	КонсольнаяКоманда = "curl 'https://example1.com' & curl 'https://example2.com'";

	ПрограммныйКод = "ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example1.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);
	|
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example2.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьОтсутствиеИспользованияЗащищенногоСоединения() Экспорт

	КонсольнаяКоманда = "curl 'http://example.com'";

	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьНаличиеИспользованияЗащищенногоСоединения() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com'";

	ПрограммныйКод = "ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL();
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьИспользованиеСертификатаКлиентаСПаролем() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' -E certfile.pem:secret";

	ПрограммныйКод = "СертификатКлиента = Новый СертификатКлиентаФайл(""certfile.pem"", ""secret"");
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL(СертификатКлиента);
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьИспользованиеСертификатаКлиентаБезПароля() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' --cert certfile.pem";

	ПрограммныйКод = "СертификатКлиента = Новый СертификатКлиентаФайл(""certfile.pem"");
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL(СертификатКлиента);
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьИспользованиеСертификатаКлиентаИСертификатыУЦИзОС() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' --cert certfile.pem --ca-native";

	ПрограммныйКод = "СертификатКлиента = Новый СертификатКлиентаФайл(""certfile.pem"");
	|СертификатыУдостоверяющихЦентров = Новый СертификатыУдостоверяющихЦентровОС();
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL(СертификатКлиента, СертификатыУдостоверяющихЦентров);
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры


Процедура ТестДолжен_ПроверитьИспользованиеСертификатаКлиентаИСертификатыУЦИзФайла() Экспорт

	КонсольнаяКоманда = "curl 'https://example.com' --cert certfile.pem --cacert CA-file.txt";

	ПрограммныйКод = "СертификатКлиента = Новый СертификатКлиентаФайл(""certfile.pem"");
	|СертификатыУдостоверяющихЦентров = Новый СертификатыУдостоверяющихЦентровФайл(""CA-file.txt"");
	|ЗащищенноеСоединение = Новый ЗащищенноеСоединениеOpenSSL(СертификатКлиента, СертификатыУдостоверяющихЦентров);
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 443, , , , , ЗащищенноеСоединение);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПередачуПараметровЗапроса() Экспорт

	КонсольнаяКоманда = "curl http://example.com \
	|	--url-query name=val \
	|	--url-query =encodethis& \
	|	--url-query name@file \
	|	--url-query @fileonly \
	|	--url-query '+name=%20foo' \
	|	--url-query +@not-a-file";

	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|ТекстовыйДокумент = Новый ТекстовыйДокумент();
	|ТекстовыйДокумент.Прочитать(""file"");
	|ТекстовыеДанныеИзФайла_1 = ТекстовыйДокумент.ПолучитьТекст();
	|ТекстовыеДанныеИзФайла_1 = КодироватьСтроку(ТекстовыеДанныеИзФайла_1, СпособКодированияСтроки.URLВКодировкеURL);
	|ТекстовыеДанныеИзФайла_1 = ""name="" + ТекстовыеДанныеИзФайла_1;
	|
	|ТекстовыйДокумент = Новый ТекстовыйДокумент();
	|ТекстовыйДокумент.Прочитать(""fileonly"");
	|ТекстовыеДанныеИзФайла_2 = ТекстовыйДокумент.ПолучитьТекст();
	|ТекстовыеДанныеИзФайла_2 = КодироватьСтроку(ТекстовыеДанныеИзФайла_2, СпособКодированияСтроки.URLВКодировкеURL);
	|
	|АдресРесурса = ""/?name=val&encodethis%26&name=%20foo&@not-a-file""
	|	+ ""&"" + ТекстовыеДанныеИзФайла_1
	|	+ ""&"" + ТекстовыеДанныеИзФайла_2;
	|
	|HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса);
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПередачуПараметровЗапросаТолькоИзФайла() Экспорт

	КонсольнаяКоманда = "curl http://example.com --url-query @fileonly";

	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|ТекстовыйДокумент = Новый ТекстовыйДокумент();
	|ТекстовыйДокумент.Прочитать(""fileonly"");
	|ТекстовыеДанныеИзФайла_1 = ТекстовыйДокумент.ПолучитьТекст();
	|ТекстовыеДанныеИзФайла_1 = КодироватьСтроку(ТекстовыеДанныеИзФайла_1, СпособКодированияСтроки.URLВКодировкеURL);
	|
	|АдресРесурса = ""/?""
	|	+ ТекстовыеДанныеИзФайла_1;
	|
	|HTTPЗапрос = Новый HTTPЗапрос(АдресРесурса);
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПереданноеИмяВыходногоФайла() Экспорт

	КонсольнаяКоманда = "curl http://example.com -o file.html";

	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос, ""file.html"");";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьПереданныеИменаВыходныхФайлов() Экспорт

	КонсольнаяКоманда = "curl \
	|	http://example.com/page1.html -o page1.html \
	|	http://example.com/page2.html --output page2.html";

	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/page1.html"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос, ""page1.html"");
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/page2.html"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос, ""page2.html"");";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьИзвлечениеИмениВыходногоФайлаИзURL() Экспорт

	КонсольнаяКоманда = "curl \
	|	http://example.com/about.html -O \
	|	http://example.com/catalog/cars.html --remote-name \
	|	http://example.com/index.html";

	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/about.html"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос, ""about.html"");
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/catalog/cars.html"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос, ""cars.html"");
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/index.html"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос);";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьИзвлечениеИмениВыходногоФайлаДляВсехURL() Экспорт

	КонсольнаяКоманда = "curl --remote-name-all \
	|	http://example.com/about.html -o file.html \
	|	http://example.com/catalog/cars.html \
	|	http://example.com/index.html";

	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/about.html"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос, ""file.html"");
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/catalog/cars.html"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос, ""cars.html"");
	|
	|Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/index.html"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос, ""index.html"");";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьВыбрасываниеИсключенияПриИзвлеченииИмениВыходногоФайлаИзURL() Экспорт

	КонсольнаяКоманда = "curl http://example.com/ -O";

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();

	Параметры = Новый Массив;
	Параметры.Добавить(КонсольнаяКоманда);
	Параметры.Добавить(Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(КонвертерКомандыCURL)
           .Метод("Конвертировать", Параметры)
           .ВыбрасываетИсключение("Не удалось получить имя файла из URL");
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьКаталогСохраненияФайловИПереданноеИмяФайла() Экспорт

	КаталогСохраненияОС = СтрЗаменить("/some/path", "/", ПолучитьРазделительПути());

	КонсольнаяКоманда = "curl http://example.com/about.html -o file.html --output-dir '/some/path'";
	КонсольнаяКоманда = СтрЗаменить(КонсольнаяКоманда, "/some/path", КаталогСохраненияОС);

	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/about.html"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос, ""/some/path/file.html"");";
	ПрограммныйКод = СтрЗаменить(ПрограммныйКод, "/some/path/", КаталогСохраненияОС + ПолучитьРазделительПути());

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьКаталогСохраненияФайловИИзвлеченноеИмяФайлаИзURL() Экспорт

	КаталогСохраненияОС = СтрЗаменить("/some/path", "/", ПолучитьРазделительПути());

	КонсольнаяКоманда = "curl http://example.com/about.html -O --output-dir '/some/path'";
	КонсольнаяКоманда = СтрЗаменить(КонсольнаяКоманда, "/some/path", КаталогСохраненияОС);

	ПрограммныйКод = "Соединение = Новый HTTPСоединение(""example.com"", 80);
	|
	|HTTPЗапрос = Новый HTTPЗапрос(""/about.html"");
	|HTTPОтвет = Соединение.ВызватьHTTPМетод(""GET"", HTTPЗапрос, ""/some/path/about.html"");";
	ПрограммныйКод = СтрЗаменить(ПрограммныйКод, "/some/path/", КаталогСохраненияОС + ПолучитьРазделительПути());

	КонвертерКомандыCURL = Новый КонвертерКомандыCURL();
	Результат = КонвертерКомандыCURL.Конвертировать(КонсольнаяКоманда, Новый ГенераторПрограммногоКода1С());

	Ожидаем.Что(Результат).Равно(ПрограммныйКод);
	
КонецПроцедуры