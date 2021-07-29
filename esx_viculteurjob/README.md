# fxserver-esx_viculteurjob
FXServer ESX Viculteur Job

Si vous souhaitez modifier ou ajouter quelque chose au script s'il vous plaît contactez-moi ⁶₆⁷J9les#2905
[REQUIREMENTS]

	* Auto mode
	* esx_service => https://github.com/FXServer-ESX/fxserver-esx_service
  
	* Gestion des joueurs (facturation et actions du boss)
	* esx_society => https://github.com/FXServer-ESX/fxserver-esx_society
	* esx_billing => https://github.com/FXServer-ESX/fxserver-esx_billing

[INSTALLATION]

1) CD dans votre dossier resources/[esx]
2) Copier le référentiel
3) Importez fr_esx_viculteurjob.sql dans votre base de données

4) Ajoutez ceci dans votre server.cfg : 

```
start esx_viculteurjob
```

5) Si vous voulez la gestion des joueurs, vous devez définir Config.EnablePlayerManagement sur true dans config.lua
