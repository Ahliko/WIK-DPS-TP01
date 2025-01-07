# WIK-DPS-TP01

## Sommaire

- [Introduction](#introduction)
- [Installation](#installation)
- [Utilisation](#utilisation)
- [Auteurs](#auteurs)
- [License](#license)

## Introduction

Ce projet a pour but de faire une API qui renvoie les informations sur les Headers de la requête HTTP.

## Installation

Pour installer le projet, il suffit de cloner le dépôt git et de lancer la commande suivante :

```bash  
# Cloner le dépôt git
git clone https://github.com/Ahliko/WIK-DPS-TP01.git && cd ./WIK-DPS-TP01

# Compiler le projet
cargo build
# Ou pour compiler le projet en mode release
cargo build --release
```
## Utilisation

Pour lancer le projet, il suffit de lancer la commande suivante :

```bash
cargo run
# Ou
cd ./target/debug && ./WIK-DPS-TP01 # Sous Linux
cd .\target\debug && .\WIK-DPS-TP01.exe # Sous Windows

# Ou pour lancer le projet en mode release

cargo run --release
# Ou
cd ./target/release && ./WIK-DPS-TP01 # Sous Linux
cd .\target\release && .\WIK-DPS-TP01.exe # Sous Windows
```

## Auteur

- [Ahliko](https://github.com/Ahliko)

## License

Ce projet est sous licence MIT - voir le fichier [LICENSE](LICENSE) pour plus d'informations.
