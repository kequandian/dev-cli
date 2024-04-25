#!/bin/sh
## INFO FORMART = 'ip@port@user@password'
########################################################
export TEST_ENV='localhost@3306@root@root'
export PROD_ENV='localhost@3306@root@root'
export OUT_PUT_1='./file1'
export OUT_PUT_2='./file2'
########################################################
if [ $# -ne 2 ];then
    echo ''
    echo 'Usage: db-diff <test-database>:<prod-database> <table>'
    echo 'e.g. db-diff test:cinema cr_issue_task'
    echo ''
    exit
fi
TEST_ARG=(${TEST_ENV//@/ })
PROD_ARG=(${PROD_ENV//@/ })
db=$1
db=(${db//:/ })
mysqldump -h ${TEST_ARG[0]} -P ${TEST_ARG[1]} -u${TEST_ARG[2]} -p${TEST_ARG[3]} ${db[0]} $2 --compact --add-drop-table --no-data > ${OUT_PUT_1} 2>/dev/null
mysqldump -h ${PROD_ARG[0]} -P ${PROD_ARG[1]} -u${PROD_ARG[2]} -p${PROD_ARG[3]} ${db[1]} $2 --compact --add-drop-table --no-data > ${OUT_PUT_2} 2>/dev/null
diff $OUT_PUT_1 $OUT_PUT_2
rm -rf $OUT_PUT_1
rm -rf $OUT_PUT_2