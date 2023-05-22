#/bin/bash
# variable d'environnement pour utilisation dans les scripts php
set '$bdd' '$url' '$_SERVER' '$path' '$host' '$database' '$login' '$password'
# Configuration du projet
echo "1-Saisir le nom de votre projet" 
read directory
echo "le nom est du projet est : "${directory^^}
echo "2-Saisir le nom de votre base de données"
read database
echo "le nom de la base de données est : "${database^^}
echo "3-Saisir le nom de votre utilisateur base de données"
read userDb
echo "le nom de votre utilisateur de base de données est : "${userDb^^}
echo "4-Saisir le mot de passe de votre base de données"
read mdpUser
echo "le mot de passe de la base de données est : "${mdpUser^^}
echo "5-Saisir l'hote du serveur (Exemple => localhost)"
read host
echo "l'hote du serveur de base de données est : "${host^^}
echo "6-Saisir le chemin de votre dossier web (Exemple => c:xampp/htdocs )"
read env
echo "Le chemin de votre dossier web est : "${env^^}
cd $env
# test si le dossier existe déja
if [ -d $directory ]
then
echo "le répertoire existe déja"
# test sinon on génére le projet
else
# Création des répertoires
mkdir $directory
mkdir "$directory/Public/" "$directory/App/"
mkdir "$directory/Public/asset" "$directory/Public/asset/images" "$directory/Public/asset/script" "$directory/Public/asset/style"
mkdir "$directory/App/Utils" "$directory/App/Model" "$directory/App/Manager" "$directory/App/Vue" "$directory/App/Controller"
# Création fichier htaccess
echo "# Activation du rewrite des URL
RewriteEngine On
# base du projet (emplacement à partir de la racine du serveur)
RewriteBase /$directory
# si ce n'est pas un répertoire
RewriteCond %{REQUEST_FILENAME} !-d
# Si ce n'est pas un fichier
RewriteCond %{REQUEST_FILENAME} !-f
RewriteRule ^(.+)$ index.php [QSA,L]">>$directory/.htaccess
# Création du fichier de configuration BDD
echo "<?php
    $5= '$host';
    $6 = '$database';
    $7= '$userDb';
    $8 = '$mdpUser';
?>">>$directory/env.php
# Création classe de connexion BDD
echo "<?php
    namespace App\Utils;
    class BddConnect{
        //fonction connexion BDD
        public function connexion(){
            //import du fichier de configuration
            include './env.php';
            //retour de l'objet PDO
            return new \PDO('mysql:host='.$5.';dbname='.$6.'', $7, $8, 
            array(\PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION));
}}?>">>$directory/App/Utils/BddConnect.php
# Création des pages de base du projet
echo "<?php
    echo 'Erreur 404
    la page n\'existe pas';
?>">>$directory/error.php
echo "<?php
    echo 'Page de test';
?>">>$directory/test.php
echo "<?php
    echo 'Page d\'Accueil';
?>">>$directory/home.php
# Création du router
echo "<?php
    use App\Utils\BddConnect;
    include './App/Utils/BddConnect.php';
    //utilisation de session_start(pour gérer la connexion au serveur)
    session_start();
    //Analyse de l'URL avec parse_url() et retourne ses composants
    $2 = parse_url($3['REQUEST_URI']);
    //test soit l'url a une route sinon on renvoi à la racine
    $4 = isset($2['path']) ? $2['path'] : '/';
    //routeur
    switch ($4) {
        case '/$directory/':
            include './home.php';
            break;
        case '/$directory/test':
            include './test.php';
            break;
        default:
            include './error.php';
            break;
    }
?>">>$directory/index.php
# Création des fichiers asset
touch $directory/Public/asset/script/script.js 
touch $directory/Public/asset/style/style.css
echo "Votre projet à été créé"
fi