A = load '/usr/deploy/jmmq/logs/pluginlog_2012_12_02_*' using PigStorage('\t');
B = filter A by $5 MATCHES  'adpic/P_.*(png|jpg|jpeg|gif)';
C = foreach B generate $3 as status, $4 as imei, $5 as img, $7 as ip;
D = group C by (img, status);
E = FOREACH D {F = DISTINCT C.imei; G = DISTINCT C.ip; GENERATE group, COUNT(F) as imei_count, COUNT(G) as ip_count;};
H = order E by imei_count desc;
STORE H INTO 'output/detail';


