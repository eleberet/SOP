create or replace function AddRuleToBlock(p_RULEID     in number,
                                          p_RULETYPE   in number,
                                          p_RULESTATUS in number,
                                          p_RULETHEN   in number,
                                          p_OID_OBJ    in number,
                                          p_VID_OBJ    in number) 
/*
    p_RULETYPE    Тип правила: 1-основное, 2-исключение (dim RuleType)
    p_RULESTATUS  Состояние: 1-вкл 2-откл (dim RuleStatus)
    p_RULETHEN    Значение выбора: ID значения выбора(записи измерения) 
    p_OID_OBJ     Вид операнда: (dim RuleOperand) 
                    Ид Операнд  
                    1 > 
                    2 >=  
                    3 < 
                    4 <=  
                    5 = 
                    6 !=  
                    7 in  
                    8 not in  
                    9 like  
                    10  is null 
                    11  is not null 
                    12  between 
                    13  not like  
    p_VID_OBJ     Значение сравнения
  */
 return varchar2 is
  l_param string(3000);
  PResult varchar2(32);
  l_Obj dwh.TPSRRule := dwh.TPSRRule(p_RULEID); -- ид блока
begin
  -- Формирование параметров правила
  l_param := '<?xml version="1.0"?><ROW>
<TPARAM><NAME>ID_RULE</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>RULETYPE</NAME><VALUE>'||p_RULETYPE||'</VALUE></TPARAM>
<TPARAM><NAME>RULESTATUS</NAME><VALUE>'||p_RULESTATUS||'</VALUE></TPARAM>
<TPARAM><NAME>RULETHEN</NAME><VALUE>'||p_RULETHEN||'</VALUE></TPARAM>
<TPARAM><NAME>DT_OPEN</NAME><VALUE>19010101</VALUE></TPARAM>
<TPARAM><NAME>DT_CLOSE</NAME><VALUE>30010101</VALUE></TPARAM>
<TPARAM><NAME>OID_OBJ</NAME><VALUE>'||p_OID_OBJ||'</VALUE></TPARAM>
<TPARAM><NAME>VID_OBJ</NAME><VALUE>'||p_VID_OBJ||'</VALUE></TPARAM>
<TPARAM><NAME>OACCOUNT_NUMBER</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>VACCOUNT_NUMBER</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>OACCOUNT_NAME</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>VACCOUNT_NAME</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>OIS_INCONSOLIDATE</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>VIS_INCONSOLIDATE</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>OBALANCE_CODE</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>VBALANCE_CODE</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>OBALANCE_NAME</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>VBALANCE_NAME</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>OCURR_CODE_TXT</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>VCURR_CODE_TXT</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>OCURR_CODE_NUM</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>VCURR_CODE_NUM</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>OINN</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>VINN</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>OFINSTR_CODE</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>VFINSTR_CODE</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>OFINSTR_NAME</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>VFINSTR_NAME</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>ORDERNUM</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>RULENOTE</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>RULE_MODIFIER</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>RULE_LASTMODIFIED</NAME><VALUE></VALUE></TPARAM>
<TPARAM><NAME>IS_RESULT</NAME><VALUE>0</VALUE></TPARAM></ROW>';

  -- Добавление правила в блок
    PResult := l_Obj.InsertRow(p_ColumnValues => l_param);
    return PResult; -- возвращает rowid добавленой строки
    commit;
  
exception
  when others then
    raise_application_error(-20001,
                            'An error was encountered - ' || SQLCODE ||
                            ' -ERROR- ' || SQLERRM);
end;
