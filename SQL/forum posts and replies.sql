SELECT      cm.COURSE_ID as Subject,
            concat(u.LASTNAME, ', ', u.FIRSTNAME) AS Poster,
            concat(InReplyTo.LASTNAME, ', ' ,InReplyTo.FIRSTNAME) AS InReplyTo,
			u.PK1 AS MsgFrom,
			InReplyTo.PK1 AS MsgTo,
            COUNT(1) AS Strength
FROM  FORUM_MAIN fm INNER JOIN MSG_MAIN mm ON fm.PK1 = mm.FORUMMAIN_PK1
			INNER JOIN USERS u ON mm.USERS_PK1 = u.PK1
			INNER JOIN CONFERENCE_MAIN cfm ON fm.CONFMAIN_PK1 = cfm.PK1
			INNER JOIN COURSE_MAIN cm ON cfm.CRSMAIN_PK1 = cm.PK1
			INNER JOIN COURSE_USERS cu ON cm.PK1 = cu.CRSMAIN_PK1
			LEFT OUTER JOIN MSG_MAIN AS MsgMainReplyTo ON mm.MSGMAIN_PK1 = MsgMainReplyTo.PK1
			LEFT OUTER JOIN USERS AS InReplyTo ON MsgMainReplyTo.USERS_PK1 = InReplyTo.PK1
WHERE       (cm.COURSE_ID LIKE 'S-PSY203_%' OR
			cm.COURSE_ID LIKE 'S-PSY208_%' OR
			cm.COURSE_ID LIKE 'S-PSY453_%' OR
			cm.COURSE_ID LIKE 'S-PSY458_%')
AND         cu.USERS_PK1 = u.PK1
AND         cu.AVAILABLE_IND = 'Y'
--AND         cu.ROW_STATUS = 0  -- possibly worth excluding to include un-enrolling students?
GROUP BY    cm.COURSE_ID,
            concat(u.LASTNAME, ', ', u.FIRSTNAME),
            concat(InReplyTo.LASTNAME,  ', ', InReplyTo.FIRSTNAME),
			u.PK1,
			InReplyTo.PK1
ORDER BY    cm.COURSE_ID,
						concat(u.LASTNAME, ', ', u.FIRSTNAME),
            concat(InReplyTo.LASTNAME, ', ' ,InReplyTo.FIRSTNAME)