# Анализ Nazev.docx

Документ описывает игру `Last Stand: Three fronts`: одиночную 2D pixel-art стратегическую action-игру на стыке RTS, RPG и auto-battler.

Основной цикл:

- игрок выбирает героя и появляется на карте;
- две стороны сражаются волнами юнитов на трех линиях;
- нейтральные существа появляются в лесу/джунглях;
- игрок получает золото и опыт за убийства;
- золото тратится в магазине на покупку или улучшение юнитов;
- цель матча - продавить линии и разрушить главную вражескую постройку.

Герои из документа:

- Forest Ranger: Piercing Arrow, Mark Prey, Nature Dash, Hail of Arrows;
- Bard Frog: Healing Melody, Swamp Ritual, Frog Jump, Sticky Tongue;
- Axe Barbarian: Whirlwind, Blood Rage, Battle Cry, Berserker's Call;
- Sorcerer: Fire Sphere, Ice Sphere, Water Sphere, Void Sphere;
- Ancient Druid: Alpha Wolf, Thorns, Summon Treant, Snake Charmer.

Юниты:

- line melee creep: ближний бой, базовая линия;
- line mage creep: дальняя магическая атака;
- line siege creep: катапульта, высокий урон по зданиям;
- neutral creeps: лесные враги ближнего и дальнего боя.

Каркас в проекте отражает эти блоки через отдельные системы: `LaneManager`, `WaveSpawner`, `NeutralCampSpawner`, `EconomySystem`, `ExperienceSystem`, `ShopSystem`, `AbilityCaster` и базовые классы акторов.
