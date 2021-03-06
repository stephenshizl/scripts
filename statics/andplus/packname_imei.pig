A = load '$logfile' using PigStorage(' ');
--A = load '/usr/deploy/jmmq/logs/pluginlog_20121203_00' using PigStorage('\t');
C = foreach A generate $9 as packname, $4 as imei;
D = distinct C;
E =  group D by packname;
F = foreach E generate group, COUNT(D.packname) as mycount;
G = order F by mycount desc;
STORE G INTO '$out_dir';
