declare l_SysMD dwh.TSRPSysMD := dwh.TSRPSysMD('SysMD');
l_SQLQuery dwh.TBCLSQLQuery := dwh.TBCLSQLQuery(-1);
l_id dwh.ud.Id;
begin
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
      l_SQLQuery.ModifyParamDesc(p_ParamCode     => 'P_DT',

                               p_Name => 'Дата',
                 p_IsMandatory => 0);
    l_SQLQuery.ModifyParamDomain (p_ParamCode => 'P_DT',  
                                      p_DomainCode => 'ExactDate');
    l_SQLQuery.SetIdColInHrh ( p_IDColumnCode => 'id_obj');
    l_SQLQuery.SetParentColInHrh ( p_ParentColumnCode => '');
                                                                   
      commit;
    end;
end;