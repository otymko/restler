
#Использовать json
#Использовать logos
#Использовать strings

Перем мСоединение;
Перем мЗаголовки;
Перем мДопустимыйКодСостояния;

Перем Лог;

Процедура ИспользоватьСоединение(Знач Соединение) Экспорт
	мСоединение = Соединение;
КонецПроцедуры

Функция Получить(Знач Ресурс, Знач ПараметрыЗапроса = Неопределено) Экспорт

	Ресурс = ДобавитьПараметрыЗапросаВРесурсЗапроса(Ресурс, ПараметрыЗапроса);
	Лог.Отладка("Выполняю get-запрос: %1/%2", мСоединение.Сервер, Ресурс);
	Ответ = мСоединение.Получить(ПолучитьHTTPЗапрос(Ресурс));
	Возврат ПрочитатьОтветЗапроса(Ответ);

КонецФункции

Функция Отправить(Знач Ресурс, Знач ПараметрыЗапроса = Неопределено) Экспорт

	Ресурс = ДобавитьПараметрыЗапросаВРесурсЗапроса(Ресурс, ПараметрыЗапроса);
	Лог.Отладка("Выполняю get-запрос: %1", Ресурс);
	Ответ = мСоединение.ОтправитьДляОбработки(ПолучитьHTTPЗапрос(Ресурс));
	Возврат ПрочитатьОтветЗапроса(Ответ);

КонецФункции

Процедура УстановитьЗаголовки(Знач Заголовки) Экспорт
	мЗаголовки = Заголовки;
КонецПроцедуры

Процедура УстановитьДопустимыйКодСостояния(Знач КодСостояния) Экспорт
	мДопустимыйКодСостояния = КодСостояния;
КонецПроцедуры

Функция ПолучитьHTTPЗапрос(Знач Ресурс) Экспорт
	Возврат Новый HTTPЗапрос(Ресурс, мЗаголовки);
КонецФункции

/////////////////////////////////////////////////////////

Функция ПрочитатьОтветЗапроса(Знач Ответ)

	ТелоОтвета = Ответ.ПолучитьТелоКакСтроку();
	Лог.Отладка("Код состояния: %1", Ответ.КодСостояния);
	Лог.Отладка("Тело ответа: 
				|%1", ТелоОтвета);

	Если Ответ.КодСостояния <> мДопустимыйКодСостояния Тогда
		ТекстСообщения = СтрШаблон(
			"Получен код возврата: %1
			|Тело ответа: %2", 
			Ответ.КодСостояния,
			ТелоОтвета
		);
		ИнфИсключение = Новый ИнформацияОбОшибке(ТекстСообщения, Ответ);
		ВызватьИсключение ИнфИсключение;
	КонецЕсли;

	Результат = Неопределено;
	Если ЗначениеЗаполнено(ТелоОтвета) Тогда
		Парсер = Новый ПарсерJSON;
		Результат = Парсер.ПрочитатьJSON(ТелоОтвета);
	КонецЕсли;

	Возврат Результат;

КонецФункции

Функция ДобавитьПараметрыЗапросаВРесурсЗапроса(Знач Ресурс, Знач ПараметрыЗапроса)
	Если НЕ ТипЗнч(ПараметрыЗапроса) = Тип("Структура") Тогда
		Возврат Ресурс;
	КонецЕсли;

	Если ПараметрыЗапроса.Количество() = 0 Тогда
		Возврат Ресурс;
	КонецЕсли;

	Ресурс = Ресурс + "?";

	Для Каждого КлючИЗначение Из ПараметрыЗапроса Цикл
		Ресурс = Ресурс + КлючИЗначение.Ключ + "=" + КлючИЗначение.Значение + "&";
	КонецЦикла;

	СтроковыеФункции.УдалитьПоследнийСимволВСтроке(Ресурс);

	Возврат Ресурс;

КонецФункции

/////////////////////////////////////////////////////////
мЗаголовки = Новый Соответствие;
мДопустимыйКодСостояния = 200;
Лог = Логирование.ПолучитьЛог("oscript.lib.restler");
