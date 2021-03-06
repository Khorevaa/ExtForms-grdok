﻿
&НаКлиенте
Процедура СвернутьРасчеты(Команда)
	ДокументСсылка = СвернутьРасчетыНаСервере();
	ПоказатьОповещениеПользователя("Создан документ", ПолучитьНавигационнуюСсылку(ДокументСсылка), Строка(ДокументСсылка));
КонецПроцедуры

&НаСервере
Функция СвернутьРасчетыНаСервере()
	
	Период        = '2016-01-01';
	ДатаДокумента = Период  -1;
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Организация", Объект.Организация);
	Запрос.Параметры.Вставить("Период",      Период);
	Запрос.Параметры.Вставить("Дата",        ДатаДокумента);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегОстатки.АналитикаУчетаПоПартнерам,
	|	РегОстатки.ЗаказКлиента,
	|	РегОстатки.Валюта,
	|	МАКСИМУМ(РегОстатки.РасчетныйДокумент) КАК РасчетныйДокумент
	|ПОМЕСТИТЬ ПустыеОстатки
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам.Остатки(&Период, АналитикаУчетаПоПартнерам.Организация = &Организация) КАК РегОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РегОстатки.АналитикаУчетаПоПартнерам,
	|	РегОстатки.ЗаказКлиента,
	|	РегОстатки.Валюта
	|
	|ИМЕЮЩИЕ
	|	СУММА(РегОстатки.КВозвратуОстаток) = 0 И
	|	СУММА(РегОстатки.ДолгОстаток) = 0 И
	|	СУММА(РегОстатки.ДолгРеглОстаток) = 0 И
	|	СУММА(РегОстатки.ПредоплатаОстаток) = 0 И
	|	СУММА(РегОстатки.ПредоплатаУпрОстаток) = 0 И
	|	СУММА(РегОстатки.ЗалогЗаТаруОстаток) = 0 И
	|	СУММА(РегОстатки.ЗалогЗаТаруРеглОстаток) = 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	&Дата КАК Период,
	|	РегОстатки.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
	|	РегОстатки.ЗаказКлиента КАК ЗаказКлиента,
	|	РегОстатки.РасчетныйДокумент КАК РасчетныйДокумент,
	|	РегОстатки.Валюта,
	|	РегОстатки.КВозвратуОстаток КАК КВозврату,
	|	РегОстатки.ДолгОстаток КАК Долг,
	|	РегОстатки.ДолгУпрОстаток КАК ДолгУпр,
	|	РегОстатки.ДолгРеглОстаток КАК ДолгРегл,
	|	РегОстатки.ПредоплатаОстаток КАК Предоплата,
	|	РегОстатки.ПредоплатаУпрОстаток КАК ПредоплатаУпр,
	|	РегОстатки.ПредоплатаРеглОстаток КАК ПредоплатаРегл,
	|	РегОстатки.ЗалогЗаТаруОстаток КАК ЗалогЗаТару,
	|	РегОстатки.ЗалогЗаТаруРеглОстаток КАК ЗалогЗаТаруРегл
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоДокументам.Остатки(
	|			&Период,
	|			(АналитикаУчетаПоПартнерам, Валюта, ЗаказКлиента) В
	|				(ВЫБРАТЬ
	|					Таб.АналитикаУчетаПоПартнерам,
	|					Таб.Валюта,
	|					Таб.ЗаказКлиента
	|				ИЗ
	|					ПустыеОстатки КАК Таб)) КАК РегОстатки
	|
	|УПОРЯДОЧИТЬ ПО
	|	АналитикаУчетаПоПартнерам,
	|	ЗаказКлиента,
	|	РасчетныйДокумент
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	ДокументОбъект =  НайтиДокументКорректировку("Сторно отрицательных остатков: РасчетыСКлиентамиПоДокументам", ДатаДокумента);
	ДокументОбъект.ПометкаУдаления = Ложь;
	
	ДокументОбъект.ТаблицаРегистров.Очистить();
	НоваяСтрока = ДокументОбъект.ТаблицаРегистров.Добавить();
	НоваяСтрока.Имя = "РасчетыСКлиентамиПоДокументам";
	
	Таблица = Запрос.Выполнить().Выгрузить();
	
	ДокументОбъект.Движения.РасчетыСКлиентамиПоДокументам.Загрузить(Таблица);
	ДокументОбъект.Записать();
	
	Возврат ДокументОбъект.Ссылка;
	
КонецФункции

&НаСервере
Функция НайтиДокументКорректировку(Комментарий, Дата = '2015-12-31')
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КорректировкаРегистров.Ссылка
	|ИЗ
	|	Документ.КорректировкаРегистров КАК КорректировкаРегистров
	|ГДЕ
	|	НАЧАЛОПЕРИОДА(КорректировкаРегистров.Дата, ДЕНЬ) = &Дата
	|	И КорректировкаРегистров.Комментарий ПОДОБНО &Комментарий";
	
	Запрос.Параметры.Вставить("Дата",        НачалоДня(Дата));
	Запрос.Параметры.Вставить("Комментарий", Комментарий);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		
		ДокументОбъект = Документы.КорректировкаРегистров.СоздатьДокумент();
		ДокументОбъект.Дата        = КонецДня(Дата);
		ДокументОбъект.Комментарий = Комментарий;
		
	Иначе
		
		ДокументОбъект = Результат.Выгрузить()[0][0].ПолучитьОбъект();
		ДокументОбъект.ПометкаУдаления = Ложь;
		
	КонецЕсли;	
	
	ДокументОбъект.Ответственный = Пользователи.ТекущийПользователь();
	
	Возврат ДокументОбъект;
	
КонецФункции	

