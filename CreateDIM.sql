declare
  l_SysMD dwh.TSRPSysMD := dwh.TSRPSysMD('SysMD');
  l_id    dwh.ud.Id;
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