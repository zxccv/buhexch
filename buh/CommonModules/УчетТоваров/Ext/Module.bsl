﻿
&ИзменениеИКонтроль("ПодготовитьТаблицыСписанныеТоварыИВыпущеннаяПродукция")
Функция ОбменERP_ПодготовитьТаблицыСписанныеТоварыИВыпущеннаяПродукция(ТаблицаТовары, ТаблицаРеквизиты, Отказ)
	
#Вставка
	Если ТаблицаРеквизиты <> Неопределено Тогда
		Для Каждого стрРеквизит Из ТаблицаРеквизиты Цикл
			стрРеквизит.Подразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();	
		КонецЦикла;
	КонецЕсли;
#КонецВставки	
	МатериалыДляОценкиСтоимости = Новый Структура("СписанныеТовары", ТаблицаТовары);

	МатериалыСОценкойСтоимости = ПодготовитьТаблицыСписанныеТовары(
	МатериалыДляОценкиСтоимости,
	ТаблицаРеквизиты,
	Отказ);

	Если МатериалыСОценкойСтоимости.Свойство("ВыпущеннаяПродукция") Тогда
		ВыпущеннаяПродукция = МатериалыСОценкойСтоимости.ВыпущеннаяПродукция;
	Иначе
		ВыпущеннаяПродукция = УчетПроизводства.НовыйТаблицаВыпущеннойПродукции();
	КонецЕсли;

	ТаблицыСписанныеТоварыИВыпущеннаяПродукция = Новый Структура;
	ТаблицыСписанныеТоварыИВыпущеннаяПродукция.Вставить("СписанныеТовары", МатериалыСОценкойСтоимости.СписанныеТовары);
	ТаблицыСписанныеТоварыИВыпущеннаяПродукция.Вставить("ВыпущеннаяПродукция", ВыпущеннаяПродукция);

	Возврат ТаблицыСписанныеТоварыИВыпущеннаяПродукция;

КонецФункции

&ИзменениеИКонтроль("ПодготовитьТаблицуСписанныеТовары")
Функция ОбменERP_ПодготовитьТаблицуСписанныеТовары(ТаблицаТовары, ТаблицаРеквизиты, Отказ)
	
#Вставка
	Если ТаблицаРеквизиты <> Неопределено Тогда
		Для Каждого стрРеквизит Из ТаблицаРеквизиты Цикл
			стрРеквизит.Подразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		КонецЦикла;
	КонецЕсли;
#КонецВставки
	МатериалыДляОценкиСтоимости = Новый Структура("СписанныеТовары", ТаблицаТовары);

	МатериалыСОценкойСтоимости = ПодготовитьТаблицыСписанныеТовары(
	МатериалыДляОценкиСтоимости,
	ТаблицаРеквизиты,
	Отказ);

	Возврат МатериалыСОценкойСтоимости.СписанныеТовары;

КонецФункции

&ИзменениеИКонтроль("ПодготовитьТаблицуВозвращенныеСписанныеТовары")
Функция ОбменERP_ПодготовитьТаблицуВозвращенныеСписанныеТовары(ТаблицаТовары, ТаблицаСчетаУчетаТоваров, ТаблицаСписокНоменклатуры, ТаблицаРеквизиты, Отказ)
	
#Вставка
	Если ТаблицаРеквизиты <> Неопределено Тогда
		Для Каждого стрРеквизит Из ТаблицаРеквизиты Цикл
			стрРеквизит.Подразделение = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();	
		КонецЦикла;
	КонецЕсли;
#КонецВставки
	Если Не ЗначениеЗаполнено(ТаблицаТовары)
		Или Не ЗначениеЗаполнено(ТаблицаРеквизиты) Тогда
		Возврат Неопределено;
	КонецЕсли;

	ТаблицаРезультата = ПолучитьПустуюТаблицуСписанныеТовары();

	Реквизиты = ТаблицаРеквизиты[0];

	Если Не Реквизиты.УказанДокументОтгрузки
		Или Не ЗначениеЗаполнено(ТаблицаСчетаУчетаТоваров) Тогда
		ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаТовары, ТаблицаРезультата);
		Возврат ТаблицаРезультата;
	КонецЕсли;

	СтруктураСчетовДляЗапроса = РазделитьСчетаУчетаПоПартионномуУчету(ТаблицаСчетаУчетаТоваров);
	ЕстьСчетаПартионные   = СтруктураСчетовДляЗапроса.СчетаПартионные.Количество() <> 0;
	ЕстьСчетаНеПартионные = СтруктураСчетовДляЗапроса.СчетаНеПартионные.Количество() <> 0;
	Если Не ЕстьСчетаПартионные И Не ЕстьСчетаНеПартионные Тогда
		ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаТовары, ТаблицаРезультата);
		Возврат ТаблицаРезультата;
	КонецЕсли;

	Параметры = ПодготовитьПараметрыТаблицыВозвращенныеСписанныеТовары(ТаблицаТовары, ТаблицаСчетаУчетаТоваров, ТаблицаСписокНоменклатуры, ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];

	ДатаДокументаРеализации = Реквизиты.ДатаДокументаРеализации;

	Если НачалоДня(Реквизиты.Период) < НачалоДня(ДатаДокументаРеализации) Тогда

		ТекстСообщения = НСтр("ru = 'Возврат по документу ""%1"" не может быть раньше %2 г.'");
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		ТекстСообщения,
		СокрЛП(Реквизиты.Сделка),
		Формат(ДатаДокументаРеализации, "ДФ=дд.MM.yyyy"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		ТекстСообщения,
		Реквизиты.Регистратор,
		"Дата",
		"Объект",
		Отказ);

		ОбщегоНазначенияБПВызовСервера.ЗагрузитьВТаблицуЗначений(ТаблицаТовары, ТаблицаРезультата);
		Возврат ТаблицаРезультата;

	Иначе

		ВозвратПрошлогоМесяца = НачалоМесяца(Реквизиты.Период) <> НачалоМесяца(ДатаДокументаРеализации);

	КонецЕсли; 


	ВедетсяСуммовойУчетПоСкладам = БухгалтерскийУчет.ВедетсяСуммовойУчетПоСкладам(ПланыСчетов.Хозрасчетный.ТоварыНаСкладах);

	МетаданныеСделки = Реквизиты.Сделка.Метаданные();
	ЕстьСкладОтгрузки = ОбщегоНазначения.ЕстьРеквизитОбъекта("Склад", МетаданныеСделки);
	ЕстьПодразделениеОтгрузки = БухгалтерскийУчетПереопределяемый.ВестиУчетПоПодразделениям()
	И ОбщегоНазначения.ЕстьРеквизитОбъекта("ПодразделениеОрганизации", МетаданныеСделки);

	РеквизитыСделки = Новый Структура();
	Если ЕстьСкладОтгрузки Тогда
		РеквизитыСделки.Вставить("Склад");
	КонецЕсли;
	Если ЕстьПодразделениеОтгрузки Тогда
		РеквизитыСделки.Вставить("ПодразделениеОрганизации");
	КонецЕсли;

	Если РеквизитыСделки.Количество() > 0 Тогда
		РеквизитыСделки = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Реквизиты.Сделка, РеквизитыСделки);
	КонецЕсли;

	Если ЕстьСкладОтгрузки Тогда
		СкладОтгрузки = РеквизитыСделки.Склад;
	КонецЕсли;
	Если ЕстьПодразделениеОтгрузки Тогда
		ПодразделениеОтгрузки = РеквизитыСделки.ПодразделениеОрганизации;
#Вставка
		ПодразделениеОтгрузки = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();	
#КонецВставки
	КонецЕсли;

	ИспользоватьОтборПоСкладуОтгрузки = ВедетсяСуммовойУчетПоСкладам И ЕстьСкладОтгрузки;

	Если ВозвратПрошлогоМесяца Тогда
		ТекстЗапроса = ТекстЗапросаВозвращенныеСписанныеТоварыПрошлогоМесяца(
		ЕстьСчетаНеПартионные,
		ЕстьСчетаПартионные,
		ИспользоватьОтборПоСкладуОтгрузки,
		ЕстьПодразделениеОтгрузки);
	Иначе
		ТекстЗапроса = ТекстЗапросаВозвращенныеСписанныеТоварыТекущегоМесяца(ЕстьСчетаНеПартионные, ЕстьСчетаПартионные);
	КонецЕсли;

	ТекстЗапроса = ТекстЗапроса + 
	"ВЫБРАТЬ
	|	ВТ_СписанныеТовары.Номенклатура КАК Номенклатура,
	|	ВТ_СписанныеТовары.Партия КАК Партия,
	|	ВТ_СписанныеТовары.СчетУчета КАК СчетУчета,
	|	ВТ_СписанныеТовары.Период КАК Период,
	|	ЕСТЬNULL(РеквизитыДокументаПартии.ДатаРегистратора, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПартии,
	|	СУММА(ВТ_СписанныеТовары.Сумма) КАК Сумма,
	|	СУММА(ВТ_СписанныеТовары.СуммаНУ) КАК СуммаНУ,
	|	СУММА(ВТ_СписанныеТовары.СуммаПР) КАК СуммаПР,
	|	СУММА(ВТ_СписанныеТовары.СуммаВР) КАК СуммаВР,
	|	СУММА(ВТ_СписанныеТовары.Количество) КАК Количество,
	|	СУММА(ВТ_СписанныеТовары.КоличествоОтгружено) КАК КоличествоОтгружено,
	|	НАЧАЛОПЕРИОДА(ВТ_СписанныеТовары.Период, МЕСЯЦ) < &НачТекущегоМесяца КАК ВозвратПрошлогоМесяца
	|ИЗ
	|	ВТ_СписанныеТовары КАК ВТ_СписанныеТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПервичныхДокументов КАК РеквизитыДокументаПартии
	|		ПО (РеквизитыДокументаПартии.Организация = &Организация)
	|			И ВТ_СписанныеТовары.Партия = РеквизитыДокументаПартии.Документ
	|ГДЕ
	|	ВТ_СписанныеТовары.Номенклатура В(&Товары)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_СписанныеТовары.Номенклатура,
	|	ВТ_СписанныеТовары.СчетУчета,
	|	ВТ_СписанныеТовары.Период,
	|	ВТ_СписанныеТовары.Партия,
	|	ЕСТЬNULL(РеквизитыДокументаПартии.ДатаРегистратора, ДАТАВРЕМЯ(1, 1, 1)),
	|	НАЧАЛОПЕРИОДА(ВТ_СписанныеТовары.Период, МЕСЯЦ) < &НачТекущегоМесяца
	|
	|ИМЕЮЩИЕ
	|	СУММА(ВТ_СписанныеТовары.Количество) > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВТ_СписанныеТовары.Номенклатура,
	|	ДатаПартии УБЫВ,
	|	ВТ_СписанныеТовары.Период
	|ИТОГИ ПО
	|	Номенклатура,
	|	СчетУчета,
	|	Партия";

	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Организация",        Реквизиты.Организация);
	Запрос.УстановитьПараметр("Регистратор",        Реквизиты.Сделка);
	Запрос.УстановитьПараметр("СчетКтПартионный",   СтруктураСчетовДляЗапроса.СчетаПартионные);
	Запрос.УстановитьПараметр("СчетКтНеПартионный", СтруктураСчетовДляЗапроса.СчетаНеПартионные);
	Запрос.УстановитьПараметр("НачТекущегоМесяца",  НачалоМесяца(Реквизиты.Период));
	Запрос.УстановитьПараметр("КонДата",            Реквизиты.Период);
	Запрос.УстановитьПараметр("НачМесяцаРеализации",НачалоМесяца(ДатаДокументаРеализации));	
	Запрос.УстановитьПараметр("КонМесяцаРеализации",КонецМесяца(ДатаДокументаРеализации));
	Запрос.УстановитьПараметр("Товары",             Параметры.СписокНоменклатуры.ВыгрузитьКолонку("Номенклатура"));
	Запрос.УстановитьПараметр("СкладОтгрузки",      СкладОтгрузки);
	Запрос.УстановитьПараметр("ПодразделениеОтгрузки",ПодразделениеОтгрузки);

	// Виды субконто при отсутствии партионного учета.
	ВидыСубконтоБезПартий = Новый Массив;
	ВидыСубконтоБезПартий.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	Если ИспользоватьОтборПоСкладуОтгрузки Тогда
		ВидыСубконтоБезПартий.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	КонецЕсли;
	Запрос.УстановитьПараметр("ВидыСубконтоБезПартий", ВидыСубконтоБезПартий);

	// Виды субконто при количественном учете по складам.
	ВидыСубконтоБезПартийСклады = Новый Массив;
	ВидыСубконтоБезПартийСклады.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ВидыСубконтоБезПартийСклады.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	Запрос.УстановитьПараметр("ВидыСубконтоБезПартийСклады", ВидыСубконтоБезПартий);

	// Виды субконто с учетом партий.
	ВидыСубконтоПартий = Новый Массив;
	ВидыСубконтоПартий.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ВидыСубконтоПартий.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии);
	Если ИспользоватьОтборПоСкладуОтгрузки Тогда
		ВидыСубконтоПартий.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	КонецЕсли;
	Запрос.УстановитьПараметр("ВидыСубконтоПартий", ВидыСубконтоПартий);

	// Всегда 3 вида субконто.
	ВидыСубконтоПартийСклады = Новый Массив;
	ВидыСубконтоПартийСклады.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Номенклатура);
	ВидыСубконтоПартийСклады.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии);
	ВидыСубконтоПартийСклады.Добавить(ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Склады);
	Запрос.УстановитьПараметр("ВидыСубконтоПартийСклады", ВидыСубконтоПартийСклады);

	Запрос.УстановитьПараметр("ЭтотВозврат", Реквизиты.Регистратор);

	ТипКоличество = Метаданные.РегистрыБухгалтерии.Хозрасчетный.Ресурсы.Количество.Тип;
	ТипСумма      = Метаданные.РегистрыБухгалтерии.Хозрасчетный.Ресурсы.Сумма.Тип;

	ТипПартия = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии.Метаданные().Тип;

	ТаблицаОтгрузок = Новый ТаблицаЗначений;
	ТаблицаОтгрузок.Колонки.Добавить("Номенклатура",          Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаОтгрузок.Колонки.Добавить("Партия",                ТипПартия); 
	ТаблицаОтгрузок.Колонки.Добавить("СчетУчета",             Новый ОписаниеТипов("ПланСчетовСсылка.Хозрасчетный"));
	ТаблицаОтгрузок.Колонки.Добавить("ВозвратПрошлогоМесяца", Новый ОписаниеТипов("Булево")); // Признак корректировки с/с прошлого периода
	ТаблицаОтгрузок.Колонки.Добавить("Сумма",                 ТипСумма); // СуммаБУ для расчета с/с возврата за период реализации
	ТаблицаОтгрузок.Колонки.Добавить("СуммаНУ",               ТипСумма); 
	ТаблицаОтгрузок.Колонки.Добавить("СуммаПР",               ТипСумма);
	ТаблицаОтгрузок.Колонки.Добавить("СуммаВР",               ТипСумма);
	ТаблицаОтгрузок.Колонки.Добавить("Количество",            ТипКоличество); // Количество для расчета с/стоимости за период реализаци
	ТаблицаОтгрузок.Колонки.Добавить("КоличествоОтгружено",   ТипКоличество); // Количество товара который возможно вернуть по партии (отгружено - возвращено)

	ВыборкаНоменклатура = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаНоменклатура.Следующий() Цикл
		ВыборкаСчетУчета = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаСчетУчета.Следующий() Цикл
			ВыборкаПартия = ВыборкаСчетУчета.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПартия.Следующий() Цикл
				// Здесь обрабатываем сценарий когде по одной и тот же реализаии товары досписываются и возвращаются в разных периодах (корректировками реализации)
				// Количество реализованного товара "лежит" всегда в фактическом периоде списания, а возвращенного - в периоде первого документа цепочки (когда бы возврат ни произошел на самом деле)
				// поэтому, для определения периода из которого можно произвести фактический возврат рассчитаем отгрузку нарастающим итогом
				// тот период где КоличествоОтгружено > 0 и будет периодом из которого возвращаем товар, а в тех периодах где КоличествоОтгружено <= 0 - товары были полностью возвращены ранее
				КоличествоОтгружено = 0;
				ВыборкаПериод = ВыборкаПартия.Выбрать();
				Пока ВыборкаПериод.Следующий() Цикл
					КоличествоОтгружено = КоличествоОтгружено + ВыборкаПериод.КоличествоОтгружено;

					// Нечего возвращать в этом периоде
					Если КоличествоОтгружено <= 0 Тогда
						Продолжить;
					КонецЕсли;

					НоваяСтрока = ТаблицаОтгрузок.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПериод);
					НоваяСтрока.КоличествоОтгружено = КоличествоОтгружено;

					// Положительные остатки на след.месяц не переносятся
					КоличествоОтгружено = 0;

				КонецЦикла; 
			КонецЦикла; 
		КонецЦикла; 
	КонецЦикла; 

	Для каждого СтрокаВозврата Из Параметры.ТаблицаТовары Цикл

		КоличествоНеПодобраноПартии = СтрокаВозврата.Количество;

		ОтгруженныеПартии = ТаблицаОтгрузок.НайтиСтроки(Новый Структура("Номенклатура, СчетУчета", СтрокаВозврата.Номенклатура, СтрокаВозврата.СчетУчета));
		Для каждого СтрокаОтгрузки Из ОтгруженныеПартии Цикл

			// Весь товар по партии реализованный в исходном документе - возвращен
			Если СтрокаОтгрузки.КоличествоОтгружено <= 0 Тогда
				Продолжить;
			КонецЕсли; 

			НоваяСтрока = ТаблицаРезультата.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаВозврата);
			НоваяСтрока.Партия = СтрокаОтгрузки.Партия;
			НоваяСтрока.Сделка = Реквизиты.Сделка;

			КоличествоВозвращено = Мин(КоличествоНеПодобраноПартии, СтрокаОтгрузки.КоличествоОтгружено);

			Если КоличествоВозвращено >= СтрокаОтгрузки.Количество Тогда
				// Текущий возврат больше или равен остатку по партии (с учетом отгрузки и предыдущих возвратов), 
				// что привело к полному возврату всей партии.

				НоваяСтрока.Количество         = СтрокаОтгрузки.Количество;
				НоваяСтрока.СуммаСписания      = СтрокаОтгрузки.Сумма;
				НоваяСтрока.СуммаСписанияНУ    = СтрокаОтгрузки.СуммаНУ;
				НоваяСтрока.СуммаСписанияПР    = СтрокаОтгрузки.СуммаПР;
				НоваяСтрока.СуммаСписанияВР    = СтрокаОтгрузки.СуммаВР;
				НоваяСтрока.СуммаКорСписанияНУ = СтрокаОтгрузки.СуммаНУ;
				НоваяСтрока.СуммаКорСписанияПР = СтрокаОтгрузки.СуммаПР;
				НоваяСтрока.СуммаКорСписанияВР = СтрокаОтгрузки.СуммаВР;
			Иначе
				// Частичный возврат партии.
				НоваяСтрока.Количество         = КоличествоВозвращено;
				Коэфф                          = КоличествоВозвращено / СтрокаОтгрузки.Количество;
				НоваяСтрока.СуммаСписания      = Окр(СтрокаОтгрузки.Сумма   * Коэфф, 2);
				НоваяСтрока.СуммаСписанияНУ    = Окр(СтрокаОтгрузки.СуммаНУ * Коэфф, 2);
				НоваяСтрока.СуммаСписанияПР    = Окр(СтрокаОтгрузки.СуммаПР * Коэфф, 2);
				НоваяСтрока.СуммаСписанияВР    = Окр(СтрокаОтгрузки.СуммаВР * Коэфф, 2);
				НоваяСтрока.СуммаКорСписанияНУ = НоваяСтрока.СуммаСписанияНУ;
				НоваяСтрока.СуммаКорСписанияПР = НоваяСтрока.СуммаСписанияПР;
				НоваяСтрока.СуммаКорСписанияВР = НоваяСтрока.СуммаСписанияВР;
			КонецЕсли;

			// Запишем себестоимость чтобы она не корректировалась автоматически
			Если СтрокаОтгрузки.ВозвратПрошлогоМесяца Тогда
				НоваяСтрока.Себестоимость = Макс(НоваяСтрока.СуммаСписания, 0.01);
			КонецЕсли;

			КоличествоНеПодобраноПартии = КоличествоНеПодобраноПартии - НоваяСтрока.Количество;

			СтрокаОтгрузки.Количество 			= СтрокаОтгрузки.Количество - НоваяСтрока.Количество;
			СтрокаОтгрузки.КоличествоОтгружено 	= СтрокаОтгрузки.КоличествоОтгружено - НоваяСтрока.Количество;
			СтрокаОтгрузки.Сумма 				= СтрокаОтгрузки.Сумма - НоваяСтрока.СуммаСписания;
			СтрокаОтгрузки.СуммаНУ 				= СтрокаОтгрузки.СуммаНУ - НоваяСтрока.СуммаСписанияНУ;
			СтрокаОтгрузки.СуммаПР 				= СтрокаОтгрузки.СуммаПР - НоваяСтрока.СуммаСписанияПР;
			СтрокаОтгрузки.СуммаВР 				= СтрокаОтгрузки.СуммаВР - НоваяСтрока.СуммаСписанияВР;

			Если КоличествоНеПодобраноПартии = 0 Тогда
				Прервать;
			КонецЕсли;

		КонецЦикла;

		// Если в документе указан документ реализации по которому было отгружено больше,
		// чем возвращается, то эту разницу отнесем на пустую партию.
		Если КоличествоНеПодобраноПартии > 0 Тогда
			ТекстСообщения = НСтр("ru = 'Документом ""%1"" было реализовано ""%2"" на ""%3"" ед. меньше, чем возвращается.'");
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстСообщения,
			СокрЛП(Реквизиты.Сделка),
			СтрокаВозврата.Номенклатура,
			КоличествоНеПодобраноПартии);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстСообщения,
			Реквизиты.Регистратор,
			СтрокаВозврата.ИмяСписка+"[" + Формат(СтрокаВозврата.НомерСтроки - 1, "ЧН=0; ЧГ=")+"].Количество",
			"Объект",
			Отказ);
		КонецЕсли;

	КонецЦикла;

	Возврат ТаблицаРезультата;

КонецФункции

&ИзменениеИКонтроль("СформироватьДвиженияКомплектация")
Процедура ОбменERP_СформироватьДвиженияКомплектация(ТаблицаКомплектующие, ТаблицаРеквизиты, Движения, Отказ)

	Если Не ЗначениеЗаполнено(ТаблицаКомплектующие) Тогда
		Возврат;
	КонецЕсли;

	Параметры = ПодготовитьПараметрыКомплектация(ТаблицаКомплектующие, ТаблицаРеквизиты);
	Реквизиты = Параметры.Реквизиты[0];

	СпособОценкиМПЗ = УчетнаяПолитика.СпособОценкиМПЗ(Реквизиты.Организация, Реквизиты.Период);
	ВедетсяУчетПоПартиям = СпособОценкиМПЗ <> Перечисления.СпособыОценки.ПоСредней;
#Вставка
	ВедетсяУчетПоПартиям = Ложь;
#КонецВставки
	ПоддержкаПБУ18 = УчетнаяПолитика.ПоддержкаПБУ18(Реквизиты.Организация, Реквизиты.Период);
	ОтражатьВНалоговомУчете = УчетнаяПолитика.ПлательщикНалогаНаПрибыль(Реквизиты.Организация, Реквизиты.Период);

	Для каждого СтрокаПартии Из Параметры.ТаблицаКомплектующие Цикл

		Проводка = Движения.Хозрасчетный.Добавить();
		Проводка.Период      = Реквизиты.Период;
		Проводка.Организация = Реквизиты.Организация;
		Проводка.Содержание  = СокрЛП(Реквизиты.Содержание);

		Проводка.СчетКт = СтрокаПартии.СчетУчета;
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Номенклатура", СтрокаПартии.Номенклатура);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Склады", СтрокаПартии.Склад);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Партии", СтрокаПартии.Партия);
		БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетКт, Проводка.СубконтоКт, "Контрагенты", Реквизиты.Контрагент);

		СвойстваСчетаКт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(Проводка.СчетКт);

		Если СвойстваСчетаКт.УчетПоПодразделениям Тогда
			Проводка.ПодразделениеКт = СтрокаПартии.Подразделение;
		КонецЕсли;

		Если СвойстваСчетаКт.Количественный Тогда
			Проводка.КоличествоКт = СтрокаПартии.Количество;
		КонецЕсли;

		СвойстваСчетаДт = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(СтрокаПартии.КорСчетСписания);

		Если ВедетсяУчетПоПартиям Тогда
			Проводка.СубконтоДт.Партии = СтрокаПартии.Партия;
		КонецЕсли;

		Проводка.СчетДт = СтрокаПартии.КорСчетСписания;
		Для НомерСубконто = 1 По 3 Цикл
			ВидСубконто = СтрокаПартии["ВидКорСубконто" + НомерСубконто];
			Если НЕ ВедетсяУчетПоПартиям И ВидСубконто = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.Партии Тогда
				Продолжить;
			КонецЕсли;
			БухгалтерскийУчет.УстановитьСубконто(Проводка.СчетДт, Проводка.СубконтоДт,
			ВидСубконто, СтрокаПартии["КорСубконто" + НомерСубконто]);
		КонецЦикла;

		Если СвойстваСчетаДт.УчетПоПодразделениям Тогда
			Проводка.ПодразделениеДт = СтрокаПартии.КорПодразделение;
		КонецЕсли;

		Если СвойстваСчетаДт.Количественный Тогда
			Проводка.КоличествоДт = СтрокаПартии.КоличествоДт;
		КонецЕсли;

		Проводка.Сумма = СтрокаПартии.СуммаСписания;

		Если СвойстваСчетаДт.НалоговыйУчет Тогда
			Проводка.СуммаНУДт = СтрокаПартии.СуммаСписанияНУ;
			Если ПоддержкаПБУ18 Тогда
				Проводка.СуммаПРДт = СтрокаПартии.СуммаСписанияПР;
				Проводка.СуммаВРДт = СтрокаПартии.СуммаСписанияВР;
			КонецЕсли;
		КонецЕсли;

		Если СвойстваСчетаКт.НалоговыйУчет Тогда
			Проводка.СуммаНУКт = СтрокаПартии.СуммаСписанияНУ;
			Если ПоддержкаПБУ18 Тогда
				Проводка.СуммаПРКт = СтрокаПартии.СуммаСписанияПР;
				Проводка.СуммаВРКт = СтрокаПартии.СуммаСписанияВР;
			КонецЕсли;
		КонецЕсли;

		Проводка.НеКорректироватьСтоимостьАвтоматически = СтрокаПартии.Себестоимость <> 0;

	КонецЦикла;

	Движения.Хозрасчетный.Записывать = Истина;

КонецПроцедуры
