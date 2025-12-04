```markdown
 🙌 **Contribuer à GovDefence** – *Fraternité Digitale*

> **"Défendre ensemble, c'est gagner ensemble."**  
> Merci d'être là ! Chaque contribution renforce notre souveraineté numérique. ✊

GovDefence est un projet **communautaire** open source. Tous les niveaux sont bienvenus : idées, docs, code, tests, traductions.

## 🤝 **Comment contribuer ?**

### 1. **Idées & Feedback** ⭐
- Ouvre une **[Issue](https://github.com/FraterniteDigitale/Govdefence/issues/new)** 
- Tag : `💡 idea` ou `🐛 bug`
- Décris ton idée ou le bug + environnement (Termux/WSL/etc.)

### 2. **Code & Features** 💻
```
Fork → Clone → Branch (`feat/nouvelle-fonction`) → Commit → PR
```

**Standards code** :
- Bash : `shellcheck` + `shfmt`
- Respecte les couleurs/émoticons existants
- Ajoute tes dépendances dans `check_deps()`
- Teste sur **2 environnements** min (Linux + Termux)

**Exemple commit** :
```
feat(osint): Ajout module Shodan gratuit via API publique

- Intégration shodan.io (100 scans/mois gratuit)
- Auto-détection clé ou mode dégradé
- Tests Termux/WSL validés
```

### 3. **Documentation** 📖
- Améliore README (tutos, screenshots)
- Traductions (FR/EN/ES)
- Ajoute cas d'usage dans `examples/`

### 4. **Tests & Bug Bounty** 🧪
- Teste sur iSH/Termux (souvent oubliés !)
- Rapporte bugs avec logs + vidéo si possible

## 🎯 **Roadmap ouverte – Priorités communauté**

| Statut | Feature | Contributeur |
|--------|---------|--------------|
| 🟢 Prêt | Dark Web Monitor (Tor) | Toi ? |
| 🟡 Plan | Air-Gapped OSINT | Toi ? |
| 🔴 Idée | GUI Web (Flask) | Toi ? |

**Vote** : Commente sur [Issue #1](https://github.com/FraterniteDigitale/Govdefence/issues/1)

## ⚖️ **Règles d'or**

✅ **Bienvenu** :
- Code éthique/défensif uniquement
- Tests multi-OS
- Docs claires

❌ **Refusé** :
- Outils offensifs illégaux
- Dépéndances payantes obligatoires
- Spam ou code malveillant

## 🤖 **Workflow PR**

1. Fork & clone
2. `git checkout -b feat/ma-super-idee`
3. Code + tests
4. `git push origin feat/ma-super-idee`
5. Ouvre **Pull Request** vers `main`
6. Ajoute **screenshot/demo** si UI/terminal

**Review** : <1 jour si clean 🚀

## 🛠️ **Outils dev recommandés**

```
# Lint Bash
shfmt -i 2 -ci -sr -kp *.sh
shellcheck Govdefence.sh

# Test multi-OS
docker run -it --rm lambci/lambda:build-nodejs8.10 ./Govdefence.sh
```

## 💬 **Besoin d'aide ?**

- 💡 **[Discussions](https://github.com/FraterniteDigitale/Govdefence/discussions)**
- 🐛 **[Issues](https://github.com/FraterniteDigitale/Govdefence/issues)**
- 📧 **Contact** : Ps08010@proton.me
                   @PS08010 (telegram)

## ❤️ **Merci aux contributeurs**

| Nom | Contribs | 
|-----|----------|
| Toi | ?! 😎 |

**Première PR** = Badge "Défenseur Digital" automatique !

---

**Fraternité Digitale** – *Souveraineté. Éthique. Résilience.*
🕊️ MIT License – Contribue, partage, défends.
```

