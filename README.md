# HomeLab - Annexe 03 - Mise en Œuvre d’un SOC

Ce projet propose la mise en oeuvre d’un **Security Operations Center** (**SOC**) complet dans un environnement virtualisé, **exclusivement à partir d’outils open-source**. Chaque étape (ou homelab) s’appuie sur la précédente, afin d’offrir un apprentissage **progressif** et **opérationnel**. L’accent est mis sur la **pratique**, la **cohérence** et la **structuration** du SOC, du premier outil de surveillance réseau jusqu’à l’intégration des utilisateurs finaux sous Linux ou Windows.

<br>

## Sommaire

- [HomeLab - Annexe 03 - Mise en Œuvre d’un SOC](#homelab---annexe-03---mise-en-œuvre-dun-soc)
  - [Sommaire](#sommaire)
  - [I - Introduction générale du projet](#i---introduction-générale-du-projet)
  - [II - Problématique \& Objectifs](#ii---problématique--objectifs)
    - [A - Problématique](#a---problématique)
    - [B - Objectifs](#b---objectifs)
  - [III - Prérequis techniques](#iii---prérequis-techniques)
  - [Tableau des Outils \& Concepts](#tableau-des-outils--concepts)
    - [Tableau des Outils](#tableau-des-outils)
    - [Concepts](#concepts)
  - [Ordre de déploiement et pourquoi](#ordre-de-déploiement-et-pourquoi)
  - [Introductions de mise en route](#introductions-de-mise-en-route)
  - [Perspective d'évolution possibles](#perspective-dévolution-possibles)
  - [Conclusion](#conclusion)

<br>

## I - Introduction générale du projet

Ce projet **R03-SOC** à pour objectif de mettre en oeuvre un **environnement de cybersécurité** fonctionnel utilisant uniquement des **outils open-source** afin de répondre à un besoin pour une entreprise sans financement. Le seul coût restera l'hébergement et la main d'oeuvre humaine qui permettrons de gérer chacune des parties.

Le but étant d'apprendrez à :

-   **Déployer** pas à pas les différents composants `open-source` d’un SOC.
-   **Simuler** des scénarios réels de surveillance et de réponse aux incidents.
-   **Comprendre** le rôle précis de chaque brique (`IDS/IPS`, `SIEM`, `EDR`, `SOAR`, etc.) et la manière dont elles interagissent.

Dans le climat actuel où les **menaces informatiques** évoluent en continu, la création d’un **SOC** (_Security Operations Center_) permet de couvrir la **détection**, la **surveillance** et la **réponse aux incidents de sécurité**.

<br>

## II - Problématique & Objectifs

### A - Problématique

Ma problématique se pose sur l'inconnu. J'ai eu un cours théorique très expéditif dans mon centre de formation qu'il m'était impossible sans recherche personnel de pouvoir mettre en pratique celui-ci. Mes différentes questions était ?

-   Où se positionne le SOC dans la gouvernance ?
-   Comment construire un **SOC complet** à l’aide de **logiciels open-source** ?
    -   couvrant la détection réseau
    -   la corrélation d’événements
    -   l’analyse forensique
    -   la gestion d’incidents ?

Tout en **optimisant la courbe d’apprentissage**, avec comme seules ressources:

-   une bonne connexion internet
-   une **recherche personnelle** approfondie
-   une première expérience en virtualisation ce qui m'amène à utiliser et optimiser mon ordinateur personnel.

### B - Objectifs

-   **Objectif principal**  
    Simuler en concevant et en déployant **pas à pas** une infrastructure SOC, en utilisant uniquement des solutions/outils **open-source** reconnus et libres d’utilisation.

-   **Objectifs secondaires**
    1. **Assimiler** la composante d'un SOC minimale.
    2. **Découvrir** les bases du SIEM (`Wazuh-indexer`,`Wazuh-server`,`Wazuh-dashboard`).
    3. **Comprendre sans le mettre en pratique** ici sur l'importance d'un IDS/IPS qui permettrait d'obtenir des logs plus riche. (Quelques exemple de configuration seront tout de même proposer pour configurer `Wazuh agent`).
    4. **Réaliser** l’importance de chaque brique dans le processus de **détection** et de **réponse**.
    5. **Établir** une **feuille de route** permettant de relier logiquement tous les composants (`collecte`, `analyse`, `corrélation`, `réaction`).
    6. **Apprendre la réponse à incident** et à la **forensique** via des outils tels que `Velociraptor`; `Zeek`.

Ce projet me permet de répondre avant tout au besoin **technique** lié à l'`annexe R03` que je dois réaliser afin d'acquérir **une première experience concrète** dans le déploiement et la gestion d'un SOC moderne qui pour rappel, dans mon cas, **en utilisant exclusivement des outils open-source**. Chaque composant est soigneusement sélectionné et documenté pour offrir une expérience d'apprentissage optimale, tout en respectant les standards de l'industrie ( _selon mes recherches_ ).

> **NOTE IMPORTANTE**<br>
> J'ai lors de mes tests rencontrer des problématiques majeurs lié aux droits lors de la réalisation du **homelab**.
> Pour solutionner ça, j'ai été contraint de modifier les commandes officiel pour inclure **sudo**.

<br>

## III - Prérequis techniques

1. **Connaissances préalables**

    - Administration système (`Linux` / `Windows`).
    - Notions de réseaux (`TCP/IP`, `routage`).

2. **Environnement matériel et logiciel**

    - **Vagrant** et **VirtualBox** installés et fonctionnels.
    - **Git** ( _fortement recommandé_ ) pour cloner et gérer l’évolution du projet.
    - **Configuration personnel** :

        - **RAM** : `32 GO`
        - **Système d'exploitation** : `Windows 11`
        - **Processeur** : `Intel(R) Core(TM) i5-10600KF CPU @ 4.10GHz`

> **Note**<br>
> L'image **Ubuntu 20.04** utilisées est une Image déployé par `Bento`. C'est une personne qui met à disposition de la communauté
> différentes images relativement légères en mémoire. Malgré la version **dépassées**, elle me permet de ne pas consommer trop en ressource et de permettre d'être opérationnel plus rapidement. Enfin, je déploie un **script** lors de l'installation d'une quelconque VM pour passer le système en français.

3. **Connectivité**

    - Un accès à internet, indispensable pour me permettre de télécharger les dépendances et maintenir l’environnement à jour.
    - Je utilise le réseau **BRIDGE**.

**Pourquoi BRIDGE ?**<br>
Ce type de réseau me permet de rentrer en contact avec toutes les machines virtuelles (VM) déployées, mais aussi, d'appartenir au réseau de l'hôte. En l'occurance pour moi, mon système Windows 11, ce qui me sera utile afin d'éviter de déployer une machine virtuel tournant sur windows.

**Pourquoi ne pas utiliser le réseau NAT ?**<br>
Ce type de réseau permet à chacune des machines virtuelles d'accéder à internet mais empêche la communication entre chaque machine déployée.

<br>

## Tableau des Outils & Concepts

### Tableau des Outils

### Concepts

<br>

## Ordre de déploiement et pourquoi

<br>

## Introductions de mise en route

<br>

## Perspective d'évolution possibles

<br>

## Conclusion
