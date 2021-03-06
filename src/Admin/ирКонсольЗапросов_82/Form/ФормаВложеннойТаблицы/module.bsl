﻿
// Обработка выбора значения в таблице
//
Процедура ВложеннаяТаблицаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
    СодержимоеЯчейки = ВыбраннаяСтрока[Колонка.Имя];
	ОткрытьЗначение(СодержимоеЯчейки);

КонецПроцедуры // ВложеннаяТаблицаВыбор

Процедура КоманднаяПанельВложеннаяТаблицаПустые(Кнопка)
	
	Кнопка.Пометка = Не Кнопка.Пометка;
	ЭлементыФормы.ВложеннаяТаблица.ОбновитьСтроки();
	
КонецПроцедуры

Процедура КоманднаяПанельВложеннаяТаблицаКолонки(Кнопка)
	
	Обработки.ирИсследовательОбъектов.Создать().ИсследоватьКоллекцию(ВложеннаяТаблица.Колонки);
	
КонецПроцедуры

Процедура КоманднаяПанельВложеннаяТаблицаСжатьКолонки(Кнопка)
	
	ЛксСжатьКолонкиТабличногоПоля(ЭлементыФормы.ВложеннаяТаблица);
	
КонецПроцедуры

Процедура КоманднаяПанельВложеннаяТаблицаШиринаКолонок(Кнопка)
	
	ЛксВвестиИУстановитьШиринуКолонокТабличногоПоля(ЭлементыФормы.ВложеннаяТаблица);
	
КонецПроцедуры

Процедура ВложеннаяТаблицаПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры
