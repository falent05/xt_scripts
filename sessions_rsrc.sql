@inc/input_vars_init;
col username      format a20  heading USER;
col inst_id       format 9999;
col osuser        format a18;
col process       format a12;
col program       format a20;
col module        format a20;
col terminal      format a20;
col client_id     format a20;
col type          format a10;
col sql_id        format a13;
col action        format a17;
col event         format a30;
col wait_class    format a20;
col sql_exec_start format a19;
col objname       format a30;
select 
     s.sid,s.serial#
    ,s.inst_id
    ,s.username
    --,s.schemaname
    ,s.osuser
    ,substr(s.program,1,20) program
    ,s.module
    ,s.terminal
    ,s.sql_id
    ,s.event
    ,s.wait_class
    ,r.*
from gv$session s ,v$rsrc_session_info r
where 
  s.sid=r.sid
  and (
       (
           s.status='ACTIVE' 
       and s.wait_class!='Idle'
       and s.sid!=sys_context('userenv','sid')
       and nvl('&1','%') = '%'
       )
     or 
       ('&1' is not null 
         and (
                 s.username                like upper('%'||'&1'||'%') 
              or upper(osuser)             like upper('%'||'&1'||'%')
              or upper(module)             like upper('%'||'&1'||'%')
              or upper(terminal)           like upper('%'||'&1'||'%')
              or upper(action)             like upper('%'||'&1'||'%')
              or upper(client_identifier)  like upper('%'||'&1'||'%')
              or sql_id                    like      ('%'||'&1'||'%')
              )
         and ('&2' is null or (s.status='ACTIVE'  and s.wait_class!='Idle'))
       )
   )
order by s.type,s.osuser
/
col username      clear;
col inst_id       clear;
col osuser        clear;
col process       clear;
col module        clear;
col program       clear;
col terminal      clear;
col client_id     clear;
col type          clear;
--col sql_id        clear;
col action        clear;
col event         clear;
col wait_class    clear;
col sql_exec_start clear;
col objname       clear;
@inc/input_vars_undef;
