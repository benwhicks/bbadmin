select Count(*) from activity_accumulator aa
where aa.timestamp > '01-MAR-2018'
and aa.timestamp< '19-APR-2018'
and aa.data like '%Mobile Login%'