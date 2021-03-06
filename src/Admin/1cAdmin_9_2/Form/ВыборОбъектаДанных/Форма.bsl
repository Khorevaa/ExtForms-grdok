﻿ Д.хТипМД;
	хВидМД = ВыбранныйОбъектМД.хВидМД;
	
	Если хТипМД = "Справочник" Тогда
		мдТип = Метаданные.Справочники[хВидМД];
	ИначеЕсли хТипМД = "Документ" Тогда
		мдТип = Метаданные.Документы[хВидМД];
	ИначеЕсли хТипМД = "ПланВидовХарактеристик" Тогда
		мдТип = Метаданные.ПланыВидовХарактеристик[хВидМД];
	ИначеЕсли хТипМД = "ПланСчетов" Тогда
		мдТип = Метаданные.ПланыСчетов[хВидМД];
	ИначеЕсли хТипМД = "ПланВидовРасчета" Тогда
		мдТип = Метаданные.ПланыВидовРасчета[хВидМД];
	ИначеЕсли хТипМД = "ПланОбмена" Тогда
		мдТип = Метаданные.ПланыОбмена[хВидМД];
	ИначеЕсли хТипМД = "БизнесПроцесс" Тогда
		мдТип = Метаданные.БизнесПроцессы[хВидМД];
	ИначеЕсли хТипМД = "Задача" Тогда
		мдТип = Метаданные.Задачи[хВидМД];
	Иначе
		Сообщить("Выбор типа данных """ + хТипМД + """ не поддерживается.");
		Возврат;
	КонецЕсли;
	
	ЭтаФорма.Заголовок = "Выбор: " + мдТип.Синоним;
	
	ДобавитьДинамическийСписокНаФорму(мдТип, хТипМД, хВидМД);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьДинамическийСписокНаФорму(мдТип, хТипМД, хВидМД)
	
	ИмяРеквизитаФормы = "ДинамическийСписок";
	ДинамическийСписок = Новый РеквизитФормы(ИмяРеквизитаФормы, Новый ОписаниеТипов("ДинамическийСписок"), , мдТип.Имя + ?(ПустаяСтрока(мдТип.Синоним), "", " (" + мдТип.Синоним + ")"), Ложь);
	
	ДобавляемыеРеквизиты = Новый Массив;
	ДобавляемыеРеквизиты.Добавить(ДинамическийСписок);
	
	ЭтаФорма.ИзменитьРеквизиты(ДобавляемыеРеквизиты);
	
	ЭтаФорма[ИмяРеквизитаФормы].ОсновнаяТаблица = хТипМД + "." + хВидМД;
	
	ЭлементФормы = ЭтаФорма.Элементы.Добавить(ИмяРеквизитаФормы, Тип("ТаблицаФормы"));
	ЭлементФормы.ПутьКДанным = ИмяРеквизитаФормы;
	ЭлементФормы.РежимВыбора = Истина;
	ЭлементФормы.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.ГруппыИЭлементы;
	ЭлементФормы.РежимВыделения = РежимВыделенияТаблицы.Одиночный;
	ЭлементФормы.ТекущаяСтрока = ЭтаФорма.ВыбранныйОбъектИБ;
	ЭлементФормы.УстановитьДействие("ВыборЗначения", "ОповеститьОВыбореЗначения");
	ЭлементФормы.Подсказка = мдТип.Комментарий;
	
	Для Каждого мдРеквизита ИЗ мдТип.СтандартныеРеквизиты Цикл
		Если мдРеквизита.Имя = "Код" ИЛИ мдРеквизита.Имя = "Ссылка" ИЛИ мдРеквизита.Имя = "ПометкаУдаления" Тогда
			Колонка = ЭтаФорма.Элементы.Добавить(ЭлементФормы.Имя + мдРеквизита.Имя, Тип("ПолеФормы"), ЭлементФормы);
			Колонка.Вид = ?(мдРеквизита.Тип.Типы().Количество() = 1 И мдРеквизита.Тип.Типы()[0] = Тип("Булево"), ВидПоляФормы.ПолеФлажка, ВидПоляФормы.ПолеНадписи);
			Колонка.ПутьКДанным = ИмяРеквизитаФормы + "." + мдРеквизита.Имя;
			Колонка.Подсказка = мдРеквизита.Синоним;
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьОВыбореЗначения(Элемент, ВыбранноеЗначение, Поле, СтандартнаяОбработка)
	ОповеститьОВыборе(ВыбранноеЗначение);
КонецПроцедуры
