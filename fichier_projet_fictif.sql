CREATE DATABASE Samsung_DB;
USE Samsung_DB;
/* EX 1 : Afficher les informations des clients qui répondent à tous les critères
suivants :
Age supérieur ou égal à 30 ans.
Revenu annuel compris entre 40 000 et 70 000 euros.
Inscrits après le 1er janvier 2018.
Ayant un score de fidélité supérieur à 5.*/
SELECT 
ID_Client,
Age,
Revenu_Annuel,
ROUND(Score_Fidelite) AS Score_de_fidélité
FROM
clients_samsung
WHERE
Age >= 30 
AND
Revenu_Annuel BETWEEN 40000 AND 70000
AND
Score_Fidelite > 5
ORDER BY
ID_Client,
Age,
Revenu_Annuel,
Score_Fidelite;

/*EX2 : Sélectionner les détails des ventes qui satisfont à toutes les conditions
suivantes :
Montant total de la vente supérieur à 1000 euros.
Score de satisfaction client inférieur à 3.
Ventes réalisées en ligne.
Délai de livraison supérieur à 20 jours.*/
SELECT
ID_Vente,
ROUND(SUM(Montant_Total), 2) AS Montant_total_de_vente,
ROUND(Score_Satisfaction) AS Score_de_satisfaction,
Canal_Achat,
Delai_Livraison_Jours
FROM
ventes_samsung
WHERE
Score_Satisfaction < 3
AND
Canal_Achat = 'En ligne'
AND
Delai_Livraison_Jours > 20
GROUP BY
ID_Vente,
Canal_Achat,
Score_Satisfaction,
Delai_Livraison_Jours
HAVING
Montant_total_de_vente > 1000
ORDER BY
ID_Vente;

/*EX3 : Pour évaluer l'expansion géographique de l'entreprise, identifiez
tous les pays distincts où les produits ont été vendus.*/
SELECT DISTINCT
Pays_Vente,
ID_Produit,
Quantite_Vendue
FROM
ventes_samsung
WHERE
Quantite_Vendue >= 1
ORDER BY
Pays_Vente;

/*EX4 : Évaluez l'efficacité des canaux de vente en fonction de la
satisfaction des clients. Pour chaque canal de vente, affichez le canal, le score
moyen de satisfaction des clients et le nombre total de ventes réalisées par ce
canal.*/
SELECT
Canal_Achat,
COUNT(ID_Vente)                        AS Nombre_total_de_vente,
ROUND(AVG(Score_Satisfaction), 2)      AS Score_moyen_de_satisfaction
FROM
ventes_samsung
GROUP BY
Canal_Achat
Order by
Canal_Achat;

/*EX5 : Affichez chaque produit, son prix, et le nombre total de fois qu'il a
été vendu.*/
SELECT
p.ID_Produit,
p.Nom_Produit,
p.Prix,
SUM(v.Quantite_Vendue) AS Nombre_total_vente
FROM
produits_samsung AS p
LEFT JOIN
ventes_samsung   AS v
ON
p.ID_Produit = v.ID_Produit
GROUP BY
p.ID_Produit,
p.Nom_Produit,
p.Prix
HAVING
SUM(v.Quantite_Vendue);

/* EX 6 : Déterminez l'âge moyen et le revenu annuel maximum des clients
pour chaque pays. Affichez le pays, l'âge moyen et le revenu annuel maximum.*/
SELECT
Pays,
ROUND(AVG(Age), 2) AS Age_moyen,
MAX(Revenu_Annuel) AS Revenu_annuel_maximum
FROM
clients_samsung
GROUP BY
Pays
HAVING
Age_moyen
AND
Revenu_annuel_maximum;

/*EX 7 : Identifiez le délai de livraison minimum et le score de satisfaction
moyen pour chaque méthode d'expédition. Affichez la méthode d'expédition, le
délai de livraison minimum et le score moyen de satisfaction.*/
SELECT
Methode_Expedition,
MIN(Delai_Livraison_Jours) AS Délai_de_livraison_minimum,
ROUND(AVG(Score_Satisfaction), 2) AS Score_moyen_de_satisfaction
FROM
ventes_samsung
GROUP BY
Methode_Expedition
HAVING
Délai_de_livraison_minimum
AND
Score_moyen_de_satisfaction;

/*Déterminez le nombre de clients avec un score de fidélité "Faible"
(<5), "Moyen" (5-7), "Élevé" (>7).*/
SELECT
CASE
    WHEN Score_Fidelite < 5 THEN 'Faible'
    WHEN Score_Fidelite BETWEEN 5 AND 7 THEN 'Moyen'
    ELSE 'Elevé' 
END AS score_de_fidélité,
COUNT(*) AS Nombre_de_clients
FROM
clients_samsung
GROUP BY
score_de_fidélité
HAVING
Nombre_de_clients;

/* EX 9 : Trouvez les produits dont le montant total des ventes dépasse 15
000. Listez l'ID du produit et le montant total des ventes.*/
SELECT
v.ID_Produit,
p.Nom_Produit,
SUM(v.Montant_Total) AS Montant_total_des_ventes
FROM
ventes_samsung AS v
LEFT JOIN
produits_samsung AS p
ON
v.ID_Produit = p.ID_Produit 
GROUP BY
ID_Produit,
Nom_Produit
HAVING 
Montant_total_des_ventes > 15000;

/* EX10 : Trouvez les pays où plus de 400 ventes ont été réalisées. Affichez
le nom du pays et le nombre total de ventes.*/
SELECT
Pays_Vente,
SUM(Quantite_Vendue) AS Nombre_total_de_vente
FROM
ventes_samsung
GROUP BY 
Pays_Vente
HAVING
Nombre_total_de_vente > 400;

/* EX 11 : Calculez le montant total des ventes pour chaque mois de l'année
2021. Utilisez DATE_FORMAT() pour extraire le mois de la date de vente.*/
SELECT
DATE_FORMAT(Date_Vente, '%Y-%M')    AS Mois,
ROUND(SUM(Montant_Total), 2)        AS Montant_totla_de_vente
FROM
ventes_samsung
GROUP BY
Mois
HAVING 
Montant_totla_de_vente
ORDER BY
Montant_totla_de_vente DESC;

/*EX 12 : Classez les ventes en "Weekend" (Samedi et Dimanche) et
"Semaine" (Lundi à Vendredi). Calculez le nombre total de ventes pour chaque
classification.*/
SELECT
CASE
    WHEN DATE_FORMAT(Date_Vente, '%D') BETWEEN '1' AND '5' THEN 'Semaine'
    ELSE 'Week-end'
END                            AS Période_de_la_semaine,
ROUND(SUM(Quantite_Vendue), 2) AS Nombre_total_de_ventes
FROM
ventes_samsung
GROUP BY
Période_de_la_semaine;

/* EX 13 : Catégorisez les ventes en "Début d'Année" (Janvier à Avril), "Milieu
d'Année" (Mai à Août), et "Fin d'Année" (Septembre à Décembre) basé sur la date
de vente. Calculez le montant total des ventes pour chaque catégorie*/
SELECT
CASE
    WHEN MONTH(Date_Vente) BETWEEN 1 AND 4 THEN 'Début_année'
    WHEN MONTH(Date_Vente) BETWEEN 5 AND 8 THEN 'Milieu_année'
    ELSE 'Fin_année'
END                          AS Période_de_vente,
ROUND(SUM(Montant_Total), 2) AS Montant_total_de_vente
FROM
ventes_samsung
GROUP BY
Période_de_vente
ORDER BY
Période_de_vente;

/*EX14: 1Identifiez les clients de France et d'Allemagne ayant un score de
fidélité moyen supérieur à 7.*/
SELECT
Pays,
ID_Client,
ROUND(AVG(Score_Fidelite), 2) AS Score_de_fidélité_moyen
FROM
clients_samsung
WHERE 
Pays
IN ('France', 'Allemagne')
GROUP BY
Pays,
ID_Client
HAVING
Score_de_fidélité_moyen > 7 
ORDER BY
ID_Client;

/*EX 15 : Pour une segmentation marketing, vous devez catégoriser les clients
en fonction de leur revenu et de leur âge. Créez une nouvelle variable "Segment_Client"
avec les conditions suivantes :
"Jeune à Revenu Élevé" : Pour les clients de moins de 35 ans avec un revenu
supérieur à 50 000.
"Jeune à Revenu Moyen" : Pour les clients de moins de 35 ans avec un revenu entre
30 000 et 50 000.
"Jeune à Revenu Faible" : Pour les clients de moins de 35 ans avec un revenu
inférieur à 30 000.
"Senior à Revenu Élevé" : Pour les clients de 35 ans et plus avec un revenu
supérieur à 50 000.
"Senior à Revenu Moyen" : Pour les clients de 35 ans et plus avec un revenu entre
30 000 et 50 000.
"Senior à Revenu Faible" : Pour les clients de 35 ans et plus avec un revenu
inférieur à 30 000.*/
SELECT
ID_Client,
CASE
    WHEN Age < 35 AND Revenu_Annuel > 50000 THEN 'Jeune_à_Revenu_Elevé'
    WHEN Age < 35 AND Revenu_Annuel BETWEEN 30000 AND 50000 THEN 'Jeune_à_Revenu_Moyen'
    WHEN Age < 35 AND Revenu_Annuel < 30000 THEN 'Jeune_à_Revenu_Faible'
    WHEN Age >= 35 AND Revenu_Annuel > 50000 THEN 'Senior_à_Revenu_Élevé'
	WHEN Age >= 35 AND Revenu_Annuel BETWEEN 30000 AND 50000 THEN 'Senior à Revenu Moyen'
	ELSE 'Senior à Revenu Faible'
END AS Segment_Client
FROM
clients_samsung
GROUP BY
Segment_Client,
ID_Client
ORDER BY
Segment_Client;
/* EX 16 : Déterminez le volume total des ventes pour chaque mois en
affichant tous les mois de l'année avec la quantité totale de produits vendus
durant ces mois.*/
SELECT
DATE_FORMAT(Date_Vente, '%M-%Y') AS MOIS,
ROUND(SUM(Quantite_Vendue), 2) AS Quantité_totale_de_produits_vendus
FROM
ventes_samsung
GROUP BY
MOIS,
Quantite_Vendue
ORDER BY
Quantité_totale_de_produits_vendus DESC;

/* EX 17 : Pour chaque combinaison Gamme et Pays_Vente, calculez :
le nombre de ventes,
le montant total des ventes.*/
SELECT
p.Gamme,
v.Pays_Vente,
ROUND(SUM(v.Quantite_Vendue), 2) AS Nombre_de_vente,
ROUND(SUM(v.Montant_Total), 2)   AS Montant_total_des_ventes
FROM
ventes_samsung                   AS v
LEFT JOIN
produits_samsung                 AS p
ON
v.ID_Produit = p.ID_Produit
GROUP BY
p.Gamme,
v.Pays_Vente;

/* EX18 : Pour chaque gamme de produit et chaque canal d’achat, affichez :
le nombre total de ventes,
la quantité totale vendue,
le montant total des ventes,
la satisfaction moyenne,
Triez par gamme, puis canal.*/
SELECT
p.Gamme,
v.Canal_Achat,
COUNT(v.ID_Vente)                   AS Nombre_total_de_ventes,
SUM(v.Quantite_Vendue)              AS Quantité_totale_vendue, 
ROUND(SUM(v.Montant_Total), 2)      AS Montant_total_de_ventes,
ROUND(AVG(v.Score_Satisfaction), 2) AS Satisfaction_moyenne
FROM
ventes_samsung                      AS v
LEFT JOIN
produits_samsung                    AS p
ON
v.ID_Produit = p.ID_Produit
GROUP BY
p.Gamme,
v.Canal_Achat;

/* EX 19 : Pour chaque mois de l’année 2021 et chaque gamme de produit, affichez :
le nombre de ventes,
le chiffre d’affaires total,
la quantité vendue totale,
et la moyenne du délai de livraison.*/

SELECT
p.Gamme,
DATE_FORMAT(v.Date_Vente, '%M-%Y')     AS Mois,
COUNT(v.ID_Vente)                      AS Nombre_de_vente,
ROUND(SUM(v.Quantite_Vendue), 2)       AS Quantité_totale_vendue,
ROUND(AVG(v.Delai_Livraison_Jours), 2) AS Moyenne_de_délai_de_livraison
FROM
ventes_samsung                          AS v
LEFT JOIN
produits_samsung                        AS p
ON
v.ID_Produit = p.ID_Produit
GROUP BY
Mois,
p.Gamme
ORDER BY
p.Gamme;

/*Pour chaque canal préféré et type de produit préféré, affichez :
le nombre de clients uniques,
la fidélité moyenne des clients,
le montant total dépensé par ces clients,
une classification :
'VIP' si fidélité moyenne > 6 et la somme du montant total des ventes > 200 000 €
'Standard' sinon
Contrainte supplémentaire : Ne prendre en compte que les clients inscrits après le 1er
janvier 2018.*/
SELECT 
  c.Canal_Prefere,
  c.Preference_Produit,
  ROUND(SUM(v.Montant_Total), 2)      AS Montant_dépensé_par_les_clients,
  COUNT(DISTINCT c.ID_Client)         AS Nombre_de_clients_uniques,
CASE
    WHEN AVG(c.Score_Fidelite) > 6 AND SUM(v.Montant_Total) > 200000 THEN 'VIP'
    ELSE 'Standard'
END AS Classification_Client,
   ROUND(AVG(c.Score_Fidelite), 2)      AS Fidélité_moyenne_des_clients
FROM
  clients_samsung AS c
LEFT JOIN
  ventes_samsung AS v
ON
  c.ID_Client = v.ID_Client
WHERE 
  c.Date_Inscription > '2018-01-01'
GROUP BY
  c.Canal_Prefere,
  c.Preference_Produit
ORDER BY 
  Nombre_de_clients_uniques;

































