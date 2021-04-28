
/*1. How many users completed an exercise in their first month per monthly cohort?*/
SELECT 
	strftime('%Y', exercises.completion_date) as Yr, 
	strftime('%m', exercises.completion_date) as Mth, 
	COUNT(strftime('%m', exercises.completion_date)) AS totalExercises, 
	(SELECT count(exercises.completion_date) FROM users
		LEFT JOIN exercises ON users.user_id = exercises.user_id
		WHERE exercises.completion_date > users.created_at AND exercises.completion_date < DATE(created_at, '+1 month')
		GROUP BY strftime('%Y', created_at), strftime('%m', created_at))*100 / COUNT(strftime('%m', exercises.completion_date))
     AS pctCompleted 
FROM users
LEFT JOIN exercises ON users.user_id = exercises.user_id
GROUP BY strftime('%Y', exercises.completion_date), strftime('%m', exercises.completion_date);

/*2. How many users completed a given amount of exercises?*/
SELECT COUNT(ec.cnt) AS numUsers, ec.cnt AS numActivities
FROM (SELECT users.user_id, COUNT(DISTINCT exercises.exercise_id) AS cnt FROM users
		INNER JOIN exercises ON users.user_id = exercises.user_id
		GROUP BY users.user_id) ec
GROUP BY ec.cnt;


/*3. Which organizations have the most severe patient population?*/
SELECT Providers.organization_id, AVG(Phq9.score) AS meanScore
FROM Providers 
LEFT JOIN Phq9 ON Providers.provider_id = Phq9.provider_id
GROUP BY Providers.organization_id
ORDER BY meanScore DESC
LIMIT 5;