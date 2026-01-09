CREATE OR REPLACE FORCE VIEW V_SYS_AUTH
(
   SYS_ID,
   USER_ID,
   AUTH_TYPE,
   PROG_ID,
   TRAN_A,
   TRAN_C,
   TRAN_R,
   TRAN_U,
   TRAN_D,
   TRAN_P,
   TRAN_S,
   TRAN_1,
   TRAN_2,
   TRAN_3,
   TRAN_4,
   TRAN_5
)
AS
   SELECT   X.SYS_ID,
            X.USER_ID,
            DECODE (X.AUTH_TYPE,
                    '10.USER', 'USER',
                    '20.GROUP', 'GROUP',
                    'DEFAULT'),
            X.PROG_ID,
            X.TRAN_A,
            X.TRAN_C,
            X.TRAN_R,
            X.TRAN_U,
            X.TRAN_D,
            X.TRAN_P,
            X.TRAN_S,
            X.TRAN_1,
            X.TRAN_2,
            X.TRAN_3,
            X.TRAN_4,
            X.TRAN_5
     FROM   (SELECT   A.*
               FROM   (SELECT   ROW_NUMBER ()
                                   OVER (
                                      PARTITION BY A.SYS_ID,
                                                   A.USER_ID,
                                                   A.PROG_ID
                                      ORDER BY A.SYS_ID,
                                               A.USER_ID,
                                               A.PROG_ID,
                                               A.AUTH_TYPE
                                   )
                                   AUTH_SEQ,
                                A.*
                         FROM   (SELECT   A.SYS_ID,
                                          A.USER_ID,
                                          '10.USER' AUTH_TYPE,
                                          A.PROG_ID,
                                          A.TRAN_A,
                                          A.TRAN_C,
                                          A.TRAN_R,
                                          A.TRAN_U,
                                          A.TRAN_D,
                                          A.TRAN_P,
                                          A.TRAN_S,
                                          A.TRAN_1,
                                          A.TRAN_2,
                                          A.TRAN_3,
                                          A.TRAN_4,
                                          A.TRAN_5
                                   FROM   SYS_UPGM A
                                 UNION
                                   SELECT   A.SYS_ID,
                                            B.USER_ID,
                                            '20.GROUP' AUTH_TYPE,
                                            A.PROG_ID,
                                            MAX (A.TRAN_A),
                                            MAX (A.TRAN_C),
                                            MAX (A.TRAN_R),
                                            MAX (A.TRAN_U),
                                            MAX (A.TRAN_D),
                                            MAX (A.TRAN_P),
                                            MAX (A.TRAN_S),
                                            MAX (A.TRAN_1),
                                            MAX (A.TRAN_2),
                                            MAX (A.TRAN_3),
                                            MAX (A.TRAN_4),
                                            MAX (A.TRAN_5)
                                     FROM   SYS_GPGM A, SYS_UGRP B
                                    WHERE   A.SYS_ID = B.SYS_ID
                                            AND A.GROUP_ID = B.GROUP_ID
                                 GROUP BY   A.SYS_ID, B.USER_ID, A.PROG_ID
                                 UNION
                                 SELECT   A.SYS_ID,
                                          B.USER_ID,
                                          '30.DEFAULT' AUTH_TYPE,
                                          A.PROG_ID,
                                          '0' TRAN_A,
                                          '0' TRAN_C,
                                          '0' TRAN_R,
                                          '0' TRAN_U,
                                          '0' TRAN_D,
                                          '0' TRAN_P,
                                          '0' TRAN_S,
                                          '0' TRAN_1,
                                          '0' TRAN_2,
                                          '0' TRAN_3,
                                          '0' TRAN_4,
                                          '0' TRAN_5
                                   FROM   SYS_PROG A, SYS_USER B
                                  WHERE   A.SYS_ID = B.SYS_ID) A) A
              WHERE   A.AUTH_SEQ = 1) X;

