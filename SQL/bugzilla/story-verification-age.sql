SELECT DISTINCT
    bugs.bugs.bug_id,
    bugs.bugs_activity.bug_when,
    bugs.profiles.realname,
    bugs.bugs.short_desc,
    bugs.keyworddefs.name,
    bugs.bugs_activity.added,
    bugs.bugs.priority,
    bugs.bugs.bug_severity,
    bugs.bugs.bug_status,
--    bugs.bugs.resolution,
    DATE(bugs.bugs_activity.bug_when)                  AS assigned_to_verify,
    DATEDIFF(CURRENT_DATE,bugs.bugs_activity.bug_when) AS Verification_Age
FROM
    bugs.bugs_activity
INNER JOIN
    bugs.bugs
ON
    (
        bugs.bugs_activity.bug_id = bugs.bugs.bug_id)
INNER JOIN
    bugs.keywords
ON
    (
        bugs.bugs.bug_id = bugs.keywords.bug_id)
INNER JOIN
    bugs.keyworddefs
ON
    (
        bugs.keywords.keywordid = bugs.keyworddefs.id)
INNER JOIN
    bugs.profiles
ON
    (
        bugs.bugs.qa_contact = bugs.profiles.userid)
WHERE
    bugs.keyworddefs.name = 'story'
AND bugs.bugs_activity.added = 'VERIFY'
AND bugs.bugs.bug_status IN ('VERIFY',
                             'QA_IN_PROGRESS',
                             'TESTED')
AND bugs.bugs.resolution NOT IN ('DEFERRED')
ORDER BY
    priority,Verification_Age DESC ;