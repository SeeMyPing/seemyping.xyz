# SeeMyPing

SeeMyPing est un projet Django livré avec une configuration avancée pour l'exécution dans des environnements conteneurisés à l'aide de Docker. Il est également prêt pour des déploiements en production avec gestion des fichiers statiques/d'upload via S3-compatible storage.

## Configuration Environnement

```
SECRET_KEY=votre_cle_secrete_django
DEBUG=0
DB_NAME=seemypingdb
DB_USER=seemypinguser
DB_PASSWORD=motdepasse
DB_HOST=db
DB_PORT=5432

S3_REGION=eu-west-1
S3_ACCESS_KEY=yourkey
S3_SECRET_KEY=yoursecret
S3_ENDPOINT=https://s3.your-storage.example.com
BUCKET_NAME=seemyping-bucket

```

## Construction et lancement du conteneur

Pour construire et lancer en production :

```bash
docker build -t seemyping-app .
```

## Structure du projet

- `src/` : Code source Django
- `src/seemyping/settings.py` : Fichier principal de configuration Django. Toutes les variables sensibles sont prises depuis les variables d'environnement pour la sécurité et la flexibilité.
- `src/seemyping/urls.py` : Routage principal
- `src/posts/` : Application blog principale
- `Dockerfile` : Multi-étapes pour réduire la taille finale et respecter les bonnes pratiques (utilisateur non root, volumes, etc.)



## Variables d’environnement (résumé)

- `SECRET_KEY` (obligatoire)
- `DEBUG` (`0` en prod)
- `DB_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_HOST`, `DB_PORT`
- `S3_REGION`, `S3_ACCESS_KEY`, `S3_SECRET_KEY`, `S3_ENDPOINT`, `BUCKET_NAME`

## Auteur
Par Nawer.

- Inspiré par un setup Django classique, optimisé pour production.