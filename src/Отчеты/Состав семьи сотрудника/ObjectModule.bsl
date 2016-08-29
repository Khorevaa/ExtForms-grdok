﻿
Функция СведенияОВнешнейОбработке() Экспорт
	
	РегистрационныеДанные = Новый Структура;
 	РегистрационныеДанные.Вставить("Вид", "ДополнительныйОтчет");
 	РегистрационныеДанные.Вставить("Наименование", "Состав семьи сотрудника");
 	РегистрационныеДанные.Вставить("Версия", "1.0");
 	РегистрационныеДанные.Вставить("БезопасныйРежим", Ложь);
 	РегистрационныеДанные.Вставить("Информация", "Состав семьи сотрудника");
	
	ТЗКоманды = Новый ТаблицаЗначений;
 	ТЗКоманды.Колонки.Добавить("Идентификатор");
 	ТЗКоманды.Колонки.Добавить("Представление");
 	ТЗКоманды.Колонки.Добавить("Модификатор");
 	ТЗКоманды.Колонки.Добавить("ПоказыватьОповещение");
 	ТЗКоманды.Колонки.Добавить("Использование");    
	
	СтрокаКоманды = ТЗКоманды.Добавить();
 	СтрокаКоманды.Представление = "Состав семьи сотрудника";
 	СтрокаКоманды.ПоказыватьОповещение = Ложь;
 	СтрокаКоманды.Использование = "ОткрытиеФормы";
 	СтрокаКоманды.Идентификатор = "Состав семьи сотрудника 2";    
 	РегистрационныеДанные.Вставить("Команды", ТЗКоманды);    
 	Возврат РегистрационныеДанные;
	
КонецФункции