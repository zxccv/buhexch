﻿
&Вместо("ОтразитьДоходыРасходыНеУчитываемыеВНалоговомУчете")
Процедура ОбменERP_ОтразитьДоходыРасходыНеУчитываемыеВНалоговомУчете(Проводки)
	СчетДоходыНеУчитываемые                   = ПланыСчетов.Хозрасчетный.ДоходыНеУчитываемые;                   // НЕ.04
	СчетРасчетыСПерсоналомПоОплатеТруда       = ПланыСчетов.Хозрасчетный.РасчетыСПерсоналомПоОплатеТруда;       // 70      
	СчетВнереализационныеРасходыНеУчитываемые = ПланыСчетов.Хозрасчетный.ВнереализационныеРасходыНеУчитываемые; // НЕ.03
	СчетВыплатыВпользуФизЛицПоП_1_48          = ПланыСчетов.Хозрасчетный.ВыплатыВпользуФизЛицПоП_1_48;          // НЕ.01.1
	СчетДругиеВыплатыПоП_1_48                 = ПланыСчетов.Хозрасчетный.ДругиеВыплатыПоП_1_48;                 // НЕ.01.9
	
	ПустойСчет     = ПланыСчетов.Хозрасчетный.ПустаяСсылка();
	ПустойПрочийДР = Справочники.ПрочиеДоходыИРасходы.ПустаяСсылка();
	ТипПрочиеДоходыИРасходы = Тип("СправочникСсылка.ПрочиеДоходыИРасходы");
	СчетаСтроительствоОбъектовОсновныхСредств = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.СтроительствоОбъектовОсновныхСредств); // 08.03
	СчетаПрочиеДоходы = БухгалтерскийУчетПовтИсп.СчетаВИерархии(ПланыСчетов.Хозрасчетный.ПрочиеДоходы); // 91.01
	ВидСубконтоПрочиеДоходыИРасходы = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ПрочиеДоходыИРасходы;
	ВидСубконтоСтатьиЗатрат = ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.СтатьиЗатрат;
	
	ПрочиеДоходыИРасходыВнереализационные = Неопределено;
	
	// Удалим проводки по забалансовым счетам учета доходов и расходов
	ПроводкиКУдалению = Новый Массив;
	//Для Каждого Проводка Из Проводки Цикл
	//	
	//	Если Проводка.СчетКт = СчетДоходыНеУчитываемые
	//		Или Проводка.СчетДт = СчетВнереализационныеРасходыНеУчитываемые
	//		//--
	//		//Притула
	//		//Или Проводка.СчетДт = СчетВыплатыВпользуФизЛицПоП_1_48
	//		//Или Проводка.СчетДт = СчетДругиеВыплатыПоП_1_48 
	//		//--
	//		Тогда
	//		// Такие проводки формируем только в этой процедуре
	//		ПроводкиКУдалению.Добавить(Проводка);
	//	КонецЕсли;
	//	
	//КонецЦикла;
	
	Для Каждого Проводка Из ПроводкиКУдалению Цикл
		Проводки.Удалить(Проводка);
	КонецЦикла;
	
	// Найдем проводки по доходам и расходам, не учитываемым в налоговом учете
	
	ПроводкиПоДоходам = Новый Массив;
	ПроводкиПоРасходам = Новый Массив;
	
	КэшУчетнойПолитики = Неопределено; // См. ДанныеУчетнойПолитики()
	
	Для Каждого Проводка Из ЭтотОбъект Цикл
		
		ДанныеУчетнойПолитики = ДанныеУчетнойПолитики(Проводка.Организация, Проводка.Период, КэшУчетнойПолитики);
	
		Если НЕ ДанныеУчетнойПолитики.ПлательщикНалогаНаПрибыль Тогда
			Продолжить;
		КонецЕсли;
		
		АнализируемыйСчет     = Проводка.СчетКт;
		АнализируемыеСубконто = Проводка.СубконтоКт;
		ЭтоПроводкаДоходыНеУчитываемыеДляНалогаНаПрибыль = Ложь;
		Если ЗначениеЗаполнено(АнализируемыйСчет)
		   И БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(АнализируемыйСчет).НалоговыйУчет
		   И АнализируемыеСубконто.Количество() <> 0
		   И СчетаПрочиеДоходы.Найти(АнализируемыйСчет) <> Неопределено Тогда
		   
			Для Каждого Субконто Из АнализируемыеСубконто Цикл
				Если Субконто.Ключ = ВидСубконтоПрочиеДоходыИРасходы Тогда 
					
					Если НЕ НалоговыйУчетПовтИсп.ВидДоходовРасходовУчитывается(Субконто.Значение) Тогда
						ПроводкиПоДоходам.Добавить(Проводка);
						ЭтоПроводкаДоходыНеУчитываемыеДляНалогаНаПрибыль = Истина;
						Прервать;
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
		   
		КонецЕсли;
		
		АнализируемыйСчет     = Проводка.СчетДт;
		АнализируемыеСубконто = Проводка.СубконтоДт;
		Если Не ЭтоПроводкаДоходыНеУчитываемыеДляНалогаНаПрибыль
		   И ЗначениеЗаполнено(АнализируемыйСчет)
		   И БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(АнализируемыйСчет).НалоговыйУчет
		   И АнализируемыеСубконто.Количество() <> 0
		   И СчетаСтроительствоОбъектовОсновныхСредств.Найти(АнализируемыйСчет) = Неопределено Тогда
		   
			Для Каждого Субконто Из АнализируемыеСубконто Цикл
				Если Субконто.Ключ = ВидСубконтоПрочиеДоходыИРасходы Тогда 
					
					Если Не НалоговыйУчетПовтИсп.ВидДоходовРасходовУчитывается(Субконто.Значение) Тогда
						ПроводкиПоРасходам.Добавить(Проводка);
						Прервать;
					КонецЕсли;
					
				ИначеЕсли Субконто.Ключ = ВидСубконтоСтатьиЗатрат Тогда 
					
					Если Не НалоговыйУчетПовтИсп.СтатьяЗатратУчитывается(Субконто.Значение) Тогда
						ПроводкиПоРасходам.Добавить(Проводка);
						Прервать;
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
		   
		КонецЕсли;
		
	КонецЦикла;
	
	// Обработаем не учитываемые доходы:
	// - обеспечим, чтобы они не отражались в налоговом учете
	// - добавим проводки по забалансовому учету
	
	Для Каждого Проводка Из ПроводкиПоДоходам Цикл
		
		ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаНУКт, Проводка.СуммаПРКт);
		
		СуммаНеУчитываемыхДоходов = Проводка.Сумма 
			- ?(Проводка.СуммаВРДт = NULL, 0, Проводка.СуммаВРДт)
			- ?(Проводка.СуммаПРДт = NULL, 0, Проводка.СуммаПРДт);
		
		Если СуммаНеУчитываемыхДоходов = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяПроводка = Проводки.Добавить();
		НоваяПроводка.Организация = Проводка.Организация;
		НоваяПроводка.Период      = Проводка.Период;
		НоваяПроводка.Содержание  = Проводка.Содержание;
		НоваяПроводка.СчетКт      = СчетДоходыНеУчитываемые;
		НоваяПроводка.СуммаНУКт   = СуммаНеУчитываемыхДоходов;
		
	КонецЦикла;
		
	// Обработаем не учитываемые расходы (также, как и доходы)
	Для Каждого Проводка Из ПроводкиПоРасходам Цикл
		
		ОчиститьСуммуЕслиЗаполнена(Проводка.СуммаНУДт, Проводка.СуммаПРДт);
		
		СуммаНеУчитываемыхРасходов = Проводка.Сумма 
			- ?(Проводка.СуммаВРКт = NULL, 0, Проводка.СуммаВРКт)
			- ?(Проводка.СуммаПРКт = NULL, 0, Проводка.СуммаПРКт);
		
		Если СуммаНеУчитываемыхРасходов = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		// анализируем проводку на принадлежность к внереализационным доходам и расходам
		ЭтоВнереализационныеДоходыРасходы = Ложь;
		Если Проводка.СчетКт <> ПустойСчет 
		   И СчетаПрочиеДоходы.Найти(Проводка.СчетКт) <> Неопределено Тогда
		   
			Для Каждого Субконто Из Проводка.СубконтоКт Цикл
				Если ТипЗнч(Субконто.Значение) = ТипПрочиеДоходыИРасходы Тогда
					
					Если ПрочиеДоходыИРасходыВнереализационные = Неопределено Тогда
						ПрочиеДоходыИРасходыВнереализационные = ПолучитьПрочиеДоходыИРасходыВнереализационные();
					КонецЕсли;
					Если ПрочиеДоходыИРасходыВнереализационные[Субконто.Значение] = Истина Тогда
						ЭтоВнереализационныеДоходыРасходы = Истина;
						Прервать;
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
			
		Иначе
			
			Для Каждого Субконто Из Проводка.СубконтоДт Цикл
				Если ТипЗнч(Субконто.Значение) = ТипПрочиеДоходыИРасходы Тогда
					
					Если ПрочиеДоходыИРасходыВнереализационные = Неопределено Тогда
						ПрочиеДоходыИРасходыВнереализационные = ПолучитьПрочиеДоходыИРасходыВнереализационные();
					КонецЕсли;
					Если ПрочиеДоходыИРасходыВнереализационные[Субконто.Значение] = Истина Тогда
						ЭтоВнереализационныеДоходыРасходы = Истина;
						Прервать;
					КонецЕсли;
					
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		Если ЭтоВнереализационныеДоходыРасходы Тогда
			СчетЗабалансовогоУчета = СчетВнереализационныеРасходыНеУчитываемые;
		ИначеЕсли СчетРасчетыСПерсоналомПоОплатеТруда = Проводка.СчетДт
		 Или СчетРасчетыСПерсоналомПоОплатеТруда = Проводка.СчетКт Тогда
			СчетЗабалансовогоУчета = СчетВыплатыВпользуФизЛицПоП_1_48;
		Иначе
			СчетЗабалансовогоУчета = СчетДругиеВыплатыПоП_1_48;
		КонецЕсли;
		
		НоваяПроводка = Проводки.Добавить();
		НоваяПроводка.Организация = Проводка.Организация;
		НоваяПроводка.Период      = Проводка.Период;
		НоваяПроводка.Содержание  = Проводка.Содержание;
		НоваяПроводка.СчетДт      = СчетЗабалансовогоУчета;
		НоваяПроводка.СуммаНУДт   = СуммаНеУчитываемыхРасходов;
		
	КонецЦикла;
КонецПроцедуры

&После("ПередЗаписью")
Процедура ОбменERP_ПередЗаписью(Отказ, РежимЗаписи)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если Запись.СчетДт = ПланыСчетов.Хозрасчетный.ТоварыНаСкладах
			ИЛИ Запись.СчетДт = ПланыСчетов.Хозрасчетный.ПрочиеМатериалы
			ИЛИ Запись.СчетДт = ПланыСчетов.Хозрасчетный.ИнвентарьИХозяйственныеПринадлежности Тогда
			Запись.ПодразделениеДт = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		КонецЕсли;
		
		Если Запись.Сумма < 0 И
			(Запись.СчетКт = ПланыСчетов.Хозрасчетный.ТоварыНаСкладах
			ИЛИ Запись.СчетКт = ПланыСчетов.Хозрасчетный.ПрочиеМатериалы
			ИЛИ Запись.СчетКт = ПланыСчетов.Хозрасчетный.ИнвентарьИХозяйственныеПринадлежности) Тогда
			Запись.ПодразделениеКт = Справочники.ПодразделенияОрганизаций.ПустаяСсылка();
		КонецЕсли;
		
		Если Запись.СчетДт.Родитель = ПланыСчетов.Хозрасчетный.РасчетыСПоставщикамиИПодрядчиками
			ИЛИ Запись.СчетДт.Родитель = ПланыСчетов.Хозрасчетный.РасчетыСПокупателямиИЗаказчиками Тогда
			Запись.СубконтоДт[ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами] = Неопределено;	
		КонецЕсли;
		
		Если Запись.СчетКт.Родитель = ПланыСчетов.Хозрасчетный.РасчетыСПоставщикамиИПодрядчиками
			ИЛИ Запись.СчетКт.Родитель = ПланыСчетов.Хозрасчетный.РасчетыСПокупателямиИЗаказчиками Тогда
			Запись.СубконтоКт[ПланыВидовХарактеристик.ВидыСубконтоХозрасчетные.ДокументыРасчетовСКонтрагентами] = Неопределено;	
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
