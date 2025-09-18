-- 添加"我的签到"菜单项
insert into sys_menu values('2000', '我的签到', '1', '10', 'mySignin', 'system/mySignin/index', '', '', 1, 0, 'C', '0', '0', 'system:mysignin:list', 'form', 'admin', sysdate(), '', null, '我的签到菜单');

-- 添加按钮权限
insert into sys_menu values('2001', '我的签到查询', '2000', '1', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:mysignin:query', '#', 'admin', sysdate(), '', null, '');
insert into sys_menu values('2002', '我的签到操作', '2000', '2', '#', '', '', '', 1, 0, 'F', '0', '0', 'system:mysignin:sign', '#', 'admin', sysdate(), '', null, '');