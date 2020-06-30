/* session data by user */
select s.timestamp, s.session_id, s.user_id, u.student_id,
       s.md5, s.one_time_token, s.flags
from sessions s
    inner join users u on u.user_id = s.user_id -- If larger than 2, then this is a mobile login. If odd then this is a new session folder, whatever that means
where u.lastname like 'Byrne'
