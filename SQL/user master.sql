/* bulk dump of user information to help match other data */

select u.pk1, u.user_id, u.student_id, u.firstname, u.lastname, u.email, u.row_status
from users u