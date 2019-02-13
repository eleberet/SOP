create or replace procedure CreateAllSOPObj is
  l_SysMD    dwh.TSRPSysMD := dwh.TSRPSysMD('SysMD');
  l_id       dwh.ud.Id;
  l_SQLQuery dwh.TBCLSQLQuery := dwh.TBCLSQLQuery(-1);
  l_SysPSR   dwh.TSRPSysPSR := dwh.TSRPSysPSR('SysPSR');
  l_Group    dwh.TPSRGroupRules := dwh.TPSRGroupRules(-1);
  l_Block    dwh.TPSRBlockRules := dwh.TPSRBlockRules(-1);
  l_idobj    dwh.ud.id;

begin
	-- Создание набора данных (ХЗ) для СОП
  begin 
    l_id := l_SysMD.AddSQLQuery(p_Code    => 'SOPAutotestDataset',
                                p_Name    => 'Упрощенный набор для тестов СОП',
                                p_SQLText => 'select
    da.id_account as id_obj /*ID|ID|inv*/,
    da.account_number as account_number/*Лицевой счет|CODE*/,
    da.account_name as account_name/*Наименование лицевого счета|NAME*/,
    da.is_inconsolidate as is_inconsolidate/*Признак консолидации|BOOL*/,
    db.balance_code as balance_code/*Балансовый счет|CODE*/,
    db.balance_name as balance_name/*Наименования балансового счета|NAME*/,
    dc.curr_code_txt as curr_code_txt/*Валюта|CODE*/,
    dc.curr_code_num as curr_code_num/*Код валюты|CODE*/,
    ds.inn as inn/*ИНН|CODE*/,
    df.finstr_code as finstr_code/*Код фин.инструмента|CODE*/,
    df.finstr_name as finstr_name/*Наименование фин.инструмента|NAME*/
    --fd.code as code/*Код сделки|CODE*/,
    --fd.dealtype as dealtype/*Тип сделки|CODE*/

    from det_account da
    join det_balance db on da.id_balance = db.id_balance
    join det_currency dc on dc.id_currency = da.id_currency
    join det_subject ds on ds.id_subject = da.id_subject
    join det_finstr df on df.id_finstr = da.id_finstr
    --left join fct_deal fd on fd.id_subject = ds.id_subject

    where :p_dt between da.dt_open and da.dt_close',
                                p_Note    => '');
    commit;
  end;

  begin
    l_SQLQuery := dwh.TBCLSQLQuery(l_id);
    l_SQLQuery.ModifyParamDesc(p_ParamCode => 'P_DT',
                               
                               p_Name        => 'Дата',
                               p_IsMandatory => 0);
    l_SQLQuery.ModifyParamDomain(p_ParamCode  => 'P_DT',
                                 p_DomainCode => 'ExactDate');
    l_SQLQuery.SetIdColInHrh(p_IDColumnCode => 'id_obj');
    l_SQLQuery.SetParentColInHrh(p_ParentColumnCode => '');
  
    commit;
  end;

  
	-- Создание измерения результатов  
  begin
    l_id := l_SysMD.AddDimData(p_Code               => 'SOPAutotestDim',
                               p_Name               => 'SOPAutotestDim',
                               p_SQLText            => 'select
                                ''Default'' as value /*CODE|CODE*/
                                , 0 as id /*ID|ID|INV*/from dual
                                union select
                                ''Rule'' as value/*CODE|CODE*/
                                , 1 as id /*ID|ID|INV*/from dual
                                union select
                                ''Empty'' as value/*CODE|CODE*/
                                , 2 as id /*ID|ID|INV*/from dual
                                ',
                               p_Note               => '',
                               p_IPColumnCode       => 'id',
                               p_NameColumnCode     => 'value',
                               p_AKColumnCode       => 'id',
                               p_ParentIPColumnCode => '',
                               p_SliceDateParamCode => '');
    commit;
  end;

  begin
    -- создание группы блоков правил
    select id_object
      into l_idobj
      from srp_obj
     where upper(code) like Upper('SOPAutotestDataset');
  
    l_Id := l_SysPSR.AddGroupRules(p_Code      => 'SOPAutotestBlock',
                                   p_Name      => 'SOPAutotestBlock',
                                   p_Note      => 'Группа блоков правил на основе ХЗ SOPAutotestDataset',
                                   p_DataSetId => l_idobj,
                                   p_DtParam   => 'P_DT');
  
    -- Добавление блока RuleBlock1 в группу блоков
  
    l_Group := dwh.TPSRGroupRules(l_Id);
    l_Id    := l_Group.AddBlockRules(p_DimHrcCode   => 'SOPAutotestDim',
                                     p_Name         => 'RuleBlock1',
                                     p_Status       => '1',
                                     p_DefaultValue => 0, -- id 'Default' rule
                                     p_DimRole      => 'RuleBlock1');
    -- Добавление правила в блок
  
    l_Block := dwh.TpsrBlockRules(l_Id);
    l_Id    := l_Block.AddExceptionRule(p_RULETHEN     => 1,
                                        p_CASEEXTENDED => '<ROWS><ROW COL="account_number" OPER="4" VAL="3" STATUS="1"></ROW></ROWS>');
    l_Id    := l_Block.AddExceptionRule(p_RULETHEN     => 2,
                                        p_CASEEXTENDED => '<ROWS><ROW COL="balance_code" OPER="2" VAL="4" STATUS="1"></ROW></ROWS>');
    commit;
  end;

end;
