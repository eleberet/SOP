declare
  l_SysPSR   dwh.TSRPSysPSR := dwh.TSRPSysPSR('SysPSR');
  l_Group dwh.TPSRGroupRules := dwh.TPSRGroupRules(-1);
  l_Block    dwh.TPSRBlockRules := dwh.TPSRBlockRules(-1);
  l_Rule     dwh.TPSRRule := dwh.TPSRRule(-1);
  l_id       dwh.ud.Id;
  l_tmpid    dwh.ud.Id;
  l_idd      dwh.ud.id;
  l_idobj    dwh.ud.id;
  l_Idb      dwh.ud.id;
  l_Idr      dwh.ud.id;
  l_idf      dwh.ud.id;
  
begin
  -- создание группы блоков правил 
    select id_object into l_idobj from srp_obj
  where upper(code) like Upper('SOPAutotestDataset');

      l_Id :=  l_SysPSR.AddGroupRules(p_Code            => 'SOPAutotestBlock',
                                      p_Name            => 'SOPAutotestBlock',
                                      p_Note            => 'Группа блоков правил на основе ХЗ SOPAutotestDataset',
                                      p_DataSetId       => l_idobj,
                                      p_DtParam => 'P_DT');
                                      
     -- Добавление блока RuleBlock1 в группу блоков

      l_Group := dwh.TPSRGroupRules(l_Id);     
      l_Id := l_Group.AddBlockRules(p_DimHrcCode => 'SOPAutotestDim',
                                    p_Name => 'RuleBlock1',
                                    p_Status => '1',
                                    p_DefaultValue => 0, -- id 'Default' rule
                                    p_DimRole => 'RuleBlock1');
     -- Добавление правила в блок

          l_Block := dwh.TpsrBlockRules(l_Id);                           
          l_Id := l_Block.AddExceptionRule (p_RULETHEN => 1,
                                            p_CASEEXTENDED => '<ROWS><ROW COL="account_number" OPER="4" VAL="3" STATUS="1"></ROW></ROWS>'
                                           );
          l_Id := l_Block.AddExceptionRule (p_RULETHEN     => 2,
                                            p_CASEEXTENDED => '<ROWS><ROW COL="balance_code" OPER="2" VAL="4" STATUS="1"></ROW></ROWS>'
                                          );       
      commit;
    end;
end;