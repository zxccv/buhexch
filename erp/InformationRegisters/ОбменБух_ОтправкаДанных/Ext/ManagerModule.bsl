Процедура СоздатьЗаписьРегистра(СтруктураНовойЗаписи) Экспорт
	
	ЗаписьРегистра = РегистрыСведений.ОбменБух_ОтправкаДанных.СоздатьМенеджерЗаписи(); 
	ЗаполнитьЗначенияСвойств(ЗаписьРегистра, СтруктураНовойЗаписи);
	ЗаписьРегистра.Записать();
	
КонецПроцедуры