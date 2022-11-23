﻿
&ИзменениеИКонтроль("ОшибкаСоответствияСчетаВалютеДоговора")
Функция ОбменERP_ОшибкаСоответствияСчетаВалютеДоговора(Параметры)
#Вставка
	Возврат "";
#КонецВставки 
	
	Если Не ПроверятьСоответствиеСчетаВалютеДоговора(Параметры.Правило, Параметры.КешОбщихЗначений) Тогда
		Возврат "";
	КонецЕсли;
	
	УсловияРасчетов = ДанныеНастройкиЭлементаКоллекции(
	"УсловияРасчетов",
	Параметры.ПланВыполнения,
	Параметры.НастройкиЭлемента);
	Если УсловияРасчетов = Неопределено Тогда
		Возврат "";
	КонецЕсли;

	Если Не ЗначениеЗаполнено(УсловияРасчетов.ВалютаВзаиморасчетов) Тогда
		Возврат "";
	КонецЕсли;

	ВалютаРегламентированногоУчета = ОбщееЗначение(Параметры.КешОбщихЗначений, "ВалютаРегламентированногоУчета");
	ВалютныйДоговор = (УсловияРасчетов.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета);
	ВалютныйСчет    = Параметры.Элемент[Параметры.Правило.Реквизит].Валютный;

	Если Не ВалютныйДоговор Тогда
		// Вести расчеты в рублях на счетах, предназначенных для учета расчетов в валюте, не запрещено.
		Возврат "";
	КонецЕсли;

	Если ВалютныйСчет Тогда
		// Счет и договор соответствуют друг другу - оба валютные
		Возврат "";
	КонецЕсли;

	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	НСтр("ru = 'Для договора с расчетами в %1 указан счет, не предназначенный для учета расчетов в валюте.'"),
	УсловияРасчетов.ВалютаВзаиморасчетов);

КонецФункции
