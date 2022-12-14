
&После("ОбработкаПроведения")
Процедура ОбменERP_ОбработкаПроведения(Отказ, РежимПроведения)
	
	//Делаем дополнительное движение по себестоимости для загруженных документов "Порча товаров"
	Если ЭтотОбъект.ВидОперации = Перечисления.ВидыОперацийКомплектацияНоменклатуры.Разукомплектация
		И ЭтотОбъект.Комплектующие.Количество() = 1
		И ЭтотОбъект.Комплектующие[0].Себестоимость <> 0 
		И ЭтотОбъект.Движения.Хозрасчетный.Количество() = 1 Тогда
		
		новДвижение = ЭтотОбъект.Движения.Хозрасчетный.Добавить();
		ЗаполнитьЗначенияСвойств(новДвижение,ЭтотОбъект.Движения.Хозрасчетный[0]);
		новДвижение.СчетДт = ПланыСчетов.Хозрасчетный.НедостачиИПотериОтПорчиЦенностей;
		новДвижение.СубконтоДт.Очистить();
		новДвижение.ПодразделениеДт = ЭтотОбъект.ПодразделениеОрганизации;
		новДвижение.Сумма = ЭтотОбъект.Движения.Хозрасчетный[0].Сумма - ЭтотОбъект.Комплектующие[0].Себестоимость; 
		новДвижение.КоличествоДт = 0;
		новДвижение.КоличествоКт = 0;
		новДвижение.СуммаНУДт = новДвижение.Сумма;
		новДвижение.СуммаНУКт = новДвижение.Сумма;
		
		ЭтотОбъект.Движения.Хозрасчетный.Записать();
		
	КонецЕсли;
	
	
КонецПроцедуры
