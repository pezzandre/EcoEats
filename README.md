# EcoEats
Collab PSU - SUPSI 2026, Team 1, EcoEats
# 🌿 EcoEats (Roblox Game)
> Un'esperienza Roblox innovativa basata sulla raccolta, gestione e conservazione delle risorse alimentari, con un sistema di deperimento realistico e un'economia dinamica.

## 📖 Descrizione
**EcoEats**  è un gioco sviluppato su **Roblox Studio** utilizzando il plugin Rojo, che sfida i giocatori a raccogliere ingredienti nel mondo di gioco prestando massima attenzione al tempo. Ogni alimento ha un proprio ciclo di vita: raccogliere cibo fresco porta profitto, mentre conservarlo troppo a lungo nello zaino o a terra porterà al deperimento, trasformandolo in uno spreco che penalizza il giocatore.

## ✨ Caratteristiche Principali (Features)

### 🍎 Sistema di Deperimento Dinamico (Food Aging)
Tutti gli ingredienti (frutta, verdura, pane, uova, ecc.) hanno un ciclo vitale basato su tre stati:
- 🟢 **Fresco (Fresh):** Il massimo del valore.
- 🟠 **Ammaccato (Recoverable/Bruised):** Valore ridotto, ma ancora utilizzabile.
- 🔴 **Avariato (Spoiled):** Valore negativo (penalità) e generazione di particelle di marciume.
*Il timer del deperimento continua a scorrere a velocità ridotta anche quando il cibo è nello zaino del giocatore!*

### 🎒 Gestione Fisica e Tool Avanzata
Il gioco sfrutta un sistema OOP (`FoodBase.luau`) altamente ottimizzato per trasformare modelli 3D complessi (con Mesh, Union e Part multiple) in `Tool` equipaggiabili in tempo reale.
- **Saldature Sicure (`WeldConstraint`):** I modelli vengono fusi dinamicamente senza bug di collisione o cadute fuori mappa.
- **Auto-Pulizia:** Il codice identifica e rimuove automaticamente vecchie saldature o body-movers nascosti nei modelli presi dal Toolbox.

### 💰 Economia e Feedback Visivo (GUI)
- **Monete (Coins):** Un sistema centralizzato (`leaderstats`) gestisce il portafoglio del giocatore.
- **HUD Interattiva:** Un timer a schermo mostra in tempo reale i secondi rimanenti prima che il cibo tenuto in mano scada, cambiando colore da verde a rosso.
- **Ricompense basate sull'azione:** Guadagni monete per la raccolta di cibo fresco, ma subisci penalità economiche se raccogli cibo avariato.

### 🏃‍♂️ Meccaniche di Movimento Custom
Sistema di Sprint e JumpPower personalizzato gestito lato Client per un'esplorazione fluida delle mappe.

---

## 🛠️ Dettagli Tecnici

Il progetto è stato scritto interamente in **Luau** e strutturato per mantenere il codice pulito e scalabile:
- **OOP (Object-Oriented Programming):** Utilizzo massiccio di Metatables per gestire la classe base `FoodBase`, ereditata da ogni singolo script degli ingredienti (es. `cherry.server.luau`, `honey.server.luau`).
- **Client-Server Architecture:** Separazione netta tra logica di calcolo (Server) ed effetti visivi/interfaccia utente (Client).
- **Proximity Prompts dinamici:** Testi e interazioni che si aggiornano in base allo stato in tempo reale dell'oggetto.

---

## 🚀 Come provare il gioco (Per Sviluppatori)

https://www.roblox.com/it/games/104149232360644/EcoEats-Supsi

---

## 👥 Crediti

Questo progetto è stato ideato, programmato e sviluppato con passione da:
- **Andrea Pezzolla** - Sviluppo, Game Design e Programmazione.
- **Massimiliano Zambelli Gat** - Sviluppo, Game Design e Programmazione.
