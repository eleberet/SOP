-- Создание настроечной тбл для заполнения блоков правил
-- Create table
create table AT_AUTOTEST_SOP_RULE
(
  groupid    NUMBER(16) not null,
  blockid    NUMBER(16) not null,
  ruletype   NUMBER(1) not null,
  rulestatus NUMBER(1) not null,
  rulethen   NUMBER(16) not null,
  oid_obj    NUMBER(2) not null,
  vid_obj    NUMBER(16) not null

)
tablespace RSDH_KERNEL_TAB
  pctfree 10
  initrans 1
  maxtrans 255;
-- Add comments to the table 
comment on table AT_AUTOTEST_SOP_RULE
  is 'Настроечная тбл для заполнения блоков правил';
-- Add comments to the columns 
comment on column AT_AUTOTEST_SOP_RULE.ruletype
  is 'Тип правила: 1-основное, 2-исключение (dim RuleType)';
comment on column AT_AUTOTEST_SOP_RULE.rulestatus
  is 'Состояние: 1-вкл 2-откл (dim RuleStatus)';
comment on column AT_AUTOTEST_SOP_RULE.rulethen
  is 'Значение выбора: ID значения выбора(записи измерения) ';
comment on column AT_AUTOTEST_SOP_RULE.oid_obj
  is 'Вид операнда: (dim RuleOperand) ';
comment on column AT_AUTOTEST_SOP_RULE.vid_obj
  is 'Значение сравнения';
comment on column AT_AUTOTEST_SOP_RULE.groupid
  is 'ID Группы правил';
comment on column AT_AUTOTEST_SOP_RULE.blockid
  is 'ID Блока правил';
-- Create/Recreate check constraints 
alter table AT_AUTOTEST_SOP_RULE
  add constraint OID_OBJ_CHK
  check (OID_OBJ in (1,2,3,4,5,6,7,8,9,10,11,12,13));
alter table AT_AUTOTEST_SOP_RULE
  add constraint RULESTATUS_CHK
  check (RULESTATUS in (1,2));
alter table AT_AUTOTEST_SOP_RULE
  add constraint RULETYPE_CHK
  check (RULETYPE in (1,2));
