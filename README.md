# Extension WanaCheck

Il est souvent utile de s'assurer que les champs nécessaires ont bien été complétés.

Cette extension vous permettra d'être automome pour des contrôles simples.

![Panneau Attention](images/attention.png)

**Sommaire**

- [Configuration](#configuration)
- [Application](#application)
- [Exemples](#exemples)
- [Administration](#administration)


## Configuration
WanaCheck permet de configurer des **Règles de contrôles de champs** composées de **Conditions** et de **Contrôles** pour n'importe quelle table. 

À l'exécution, l'extension évalue les règles configurées sur un enregistrement et peut bloquer ou demander la confirmation à l'utilisateur lorsque les vérifications échouent.

**Règles**

Plusieurs règles peuvent s'appliquer pour une même table.

**Conditions** et **Contrôles**

Dans un cas comme dans l'ordre, il s'agit de définir un ensemble de filtres comme vous le feriez pour les filtres habituels.
Des champs peuvent être ajoutés un à un ou par l'action **Ajouter champs** permettant une sélection multiple.

## Application

Ces règles sont appliquées par les déclencheurs suivants : 
* Action **Lancer** des documents suivants : 
  * Document d'achat
  * Document de vente
  * Ordre d'assemblage
  * Ordre de transfert
  
* Déblocage de l'un des éléments suivants : 
  * Client
  * Fournisseur
  * Article
  * Resource
  * Projet
  
  Cela suppose que l'élément concerné soit initialement bloqué, afin que le déblocage soit une étape nécessaire.\
  L'utilisation des modèles lors de la création est donc à privilégier.

Pour chacune des **Règles de contrôle de champs** de la table concernée : 
* Le filtre **Conditions** est appliqué à l'élément
  * Si ce dernier en fait partie, les **Contrôles** sont appliqués en appliquant les filtres correspondants à ce même élément.
    * S'il n'en fait pas partie, il n'est donc pas conforme, et dans ce cas : 
      * Si l'option **Confirmer pour outrepasser** est activée, ce n'est qu'une alerte ("Voulez-vous continuer ?" Oui/Non).
      * Dans le cas contraire, l'erreur doit être prise en compte.

## Exemples

Ici, les 3 champs définis en **Contrôles** s'appliquent à tous les clients (pas de **Conditions**) :

![Clients](images/clients.png)

Parmi les règles applicables aux documents de vente (table **En-tête vente**), la première ne s'applique qu'aux commandes, la seconde ne concerne que les devis, 

![Règles](images/rules.png)

**Remarques**
* Pour les commandes, la présence de la **Date de livraison** est ici contrôlée mais, à défaut, une simple confirmation permettra de passer outre.

* La dernière règle ci-dessus vérifie la présence du **N° identif. intracomm.** pour les ventes en Union Europénne, exception faite des devis (le **N° identif. intracomm.** peut ne pas être défini à ce stade) : \
![Ventes UE](images/ventes_ue.png)

* Le fitre est cependant limité à 250 caractères (ici : DE|AT|BE|BG|CY|HR|DK|ES|EE|FI|FR|EL|HU|IE|IT|LV|LT|LU|MT|NL|PL|PT|CZ|RO|SK|SI|SE).


## Administration

**Ensembles d'autorisations**

* **WanaCheck** doit être accordé à tous les utilisateurs de ces règles.
* **WanaCheck_Setup** permet de les établir.
