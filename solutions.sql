-- Database Client JDBC estensione per sql

--! QUERY SELECT
-- 1. Selezionare tutti gli studenti nati nel 1990 (160)

SELECT * 
FROM `students`
WHERE YEAR(`date_of_birth`) = 1990;

-- 2. Selezionare tutti i corsi che valgono più di 10 crediti (479)

SELECT * 
FROM `courses`
WHERE `cfu` > 10;


-- 3. Selezionare tutti gli studenti che hanno più di 30 anni

SELECT * 
FROM `students`
WHERE YEAR(`date_of_birth`) <= 1994;

-- soluzione migliore: 

SELECT * 
FROM `students`
WHERE TIMESTAMPDIFF(YEAR, `date_of_birth`, CURDATE());
-- gli argomenti sono il primo ..., il secondo la colonna da controllare, al terzo la sottrazione da cosa

SELECT * 
FROM `students`
WHERE `date_of_birth` < DATE_SUB(CURDATE(), INTERVAL 30 YEAR);



-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di
-- laurea (286)

SELECT * 
FROM `courses`
WHERE `period` = 'I semestre' AND `year` = 1;


-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del
-- 20/06/2020 (21)

SELECT * 
FROM `exams`
WHERE `date` = '2020-06-20' AND `hour` > '14:00:00';


-- 6. Selezionare tutti i corsi di laurea magistrale (38)

SELECT * 
FROM `degrees`
WHERE `level` = 'magistrale';


-- 7. Da quanti dipartimenti è composta l'università? (12)

SELECT COUNT(*) AS `num_dipartimenti`
FROM `departments`;


-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono? (50)

SELECT COUNT(*) 
FROM `teachers`
WHERE `phone` IS NULL;



--! QUERY GROUP BY
-- 1. Contare quanti iscritti ci sono stati ogni anno

SELECT COUNT(*) AS `students`, YEAR(`enrolment_date`) AS `year`
FROM `students`
GROUP BY `year`;


-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio

SELECT COUNT(*) AS `total_teachers`, `office_address`
FROM `teachers`
GROUP BY `office_address`;


-- 3. Calcolare la media dei voti di ogni appello d'esame

SELECT `exam_id`, AVG(`vote`) as `average_vote`
FROM `exam_student`
GROUP BY `exam_id`;

-- se voglio eliminare gli esami non passati dalla media da calcolare

SELECT `exam_id`, AVG(`vote`) as `average_vote`
FROM `exam_student`
WHERE `vote` >= 18
GROUP BY `exam_id`;



-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento

SELECT COUNT(*) AS `total_courses`, `department_id`
FROM `degrees`
GROUP BY `department_id`;

--! JOIN

-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia

-- ho scelto nome e cognome per non prendere tutto lo studente

SELECT S.`name` AS 'nome studente', S.`surname` AS 'cognome studente', D.`name` AS 'nome corso' 
FROM `students` AS S
JOIN `degrees` AS D
ON S.`degree_id` = D.`id`
WHERE D.`name` = 'Corso di Laurea in Economia';



-- 2. Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze

--ho scelto nome e livello per non prendere tutto

SELECT DEG.`name` AS 'nome corso di laurea',  DEG.`level` AS 'livello corso di laurea', DEP.`name` AS 'nome dipartimento'
FROM `degrees` AS DEG
JOIN `departments` AS DEP
ON DEG.`department_id` = DEP.`id`
WHERE DEP.`name` = 'Dipartimento di Neuroscienze';


-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)

SELECT C.`name` AS 'nome corso', C.`description` AS 'descrizione corso', T.`name` AS 'nome insegnante', T.`surname` AS 'cognome insegnante', T.`id`
FROM `course_teacher` AS CT
JOIN `courses` AS C
ON CT.`course_id` = C.`id`
JOIN `teachers` AS T
ON CT.`teacher_id` = T.`id`
WHERE T.`surname` = 'Amato'
AND T.`name` = 'Fulvio';


-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il
-- relativo dipartimento, in ordine alfabetico per cognome e nome

SELECT S.`surname` AS 'cognome studente', S.`name` AS 'nome studente', DEG.`name` AS 'iscritto/a a', DEP.`name` AS 'dipartimento di cui fa parte il corso'
FROM `students` AS S
JOIN `degrees`AS DEG
ON S.`degree_id` = DEG.`id`
JOIN `departments`AS DEP
ON DEG.`department_id` = DEP.`id`
ORDER BY S.`surname`, S.`name`;



-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti



-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)



-- 7. BONUS: Selezionare per ogni studente quanti tentativi d’esame ha sostenuto per
-- superare ciascuno dei suoi esami

