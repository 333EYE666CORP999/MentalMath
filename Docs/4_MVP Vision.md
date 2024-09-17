# MVP Vision

Tech notes:

*`⚠️ t0 d0` - means that something should be done here*

*`👀 need review` - this very line needs special attention*

## Intro

This doc is describing on how we see the eventual [minimum-viable product](https://en.wikipedia.org/wiki/Minimum_viable_product) that'll be shipped to the AppStore.

## Core Purpose and Value

### Proposed Commercial Name and Title

**Numerica: Personalized Feedback for Mental Math Mastery**

### Purpose

Numerica serves the simple purpose: help people thrive in mental math.

### UVP / USP

Numerica delivers targeted insights to help users improve their mental math skills. Key features include:

- Game Session Analytics: Detailed performance data from each session.
- Time-Based Stats: Progress tracking across day, week, month, and year.
- Growth & Excellence Areas: Highlights of improvement opportunities and strengths.
- Tailored Learning: Customized recommendations based on user performance. `👀 need review`

Additionally, Numerica offers a *zen mode* for non-competitive, stress-free learning, allowing users to focus purely on skill development without pressure.

## Understanding Target Audience

The target audience for Numerica could include:

1. Students: Primary and secondary school students looking to improve their mental math skills in a supportive, non-competitive environment.
2. Professionals: Adults in professions that require quick mental calculations (e.g., finance, engineering) who want to refine their mental math abilities.
3. Lifelong Learners: Individuals interested in cognitive improvement, brain training, or maintaining mental sharpness through math exercises.
4. Gamers/EdTech Enthusiasts: gamified experiences enjoyers combining fun with skill development.

---

*Non-mvp scope*

 *`⚠️ t0 d0` - think out where to abstract this out*

*`👀 need review` - do we really need to keep in mind these categories? wdut?*

1. *Educators: Teachers seeking tools to track student progress, identify areas of strength and improvement, and provide personalized feedback.*
2. *Parents: Parents who want to help their children practice mental math in a structured yet stress-free manner.*

## Critical Features (Must-Have vs Nice-to-Have)

### Must-Have

- Zen game mode
- Game-session analytics
- Growth & excellence areas highlights
- Tailored learning paths *`👀 need review` - do we need this right away?*

### Nice-to-Have

- Icon / font / color theme change option
- Zen music
- Animated backgrounds ([Endel](https://endel.io) Style) *`👀 need review` - need to discuss this, have a look and let's talk*
- Gamification: Achievements

## Goals, Metrics and Funnels

### Goals

| Goal             | Description                                                  | ⚠️ t0 d0  |
| ---------------- | ------------------------------------------------------------ | -------- |
| User Acquisition | How many new users or customers a business or app gains over a specific period. | set kpis |
| User Retention   | `Retention Rate = (Q users: period start / Q users: period end) × 100` | set kpis |
| Tech Performance | Launch time, loading time, database, core performance        | set kpis |
| `👀 need review`  | *more goals?*                                                | discuss  |

### Metrics

| Metric                        | Description                                    | ⚠️ t0 d0 |
| ----------------------------- | ---------------------------------------------- | ------- |
| Time Spent in App Per Session | Obvious - we need somehow to raise this metric | -       |
| Return after First Use        | Obvious - depicts on how ou app is replayable  | -       |
| Crash-free sessions           | Crashes distress users a lot…                  | -       |
| Crash-free users              | Crashes distress users a lot…                  | -       |
| `👀 need review`               | *more metrics?*                                | discuss |

### Funnels

*`👀 need review` - do we really need to keep in mind funnels now? wdut?*

- How do we answer the question "why our users are not finishing games?". User can close the app in mid-game and abort the session.

## Competition and Market

**`👀 need review` - here i deem to do the following:*

1) *analyze competition and synthesize brief*
2) *analyze domain market trends*
3) *combine 1) and 2) to synthesize market fit*

### Competition

| Competitor | Category | Rating | Regions | User's Feedback | Product Awards (If Any) | Gaps and Pitfalls | Age Rating | Market Share | Pricing Model | Features | User Engagement | Update Frequency | Customer Support | Languages |
| ---------- | -------- | ------ | ------- | --------------- | ----------------------- | ----------------- | ---------- | ------------ | ------------- | -------- | --------------- | ---------------- | ---------------- | --------- |
|            |          |        |         |                 |                         |                   |            |              |               |          |                 |                  |                  |           |

### Domain Market Trends (If Any)

- - - 

### Market Fit

- - - 

## Launch Strategy

*`⚠️ t0 d0` - prerequisites:*

- *crit features*
- *goals & metrics*
- *market understanding* 

### General Strategy

```
- Soft Launch: Target a smaller region or group first to gather feedback and fix issues before a full release.
- App Store Optimization (ASO): Optimize your app’s title, description, keywords, and screenshots for better visibility in the App Store.
- Marketing and Community: Promote your MVP using social media, developer forums, or niche communities. Build a small, passionate group of early adopters.
```

## Serega's Thoughts (🚧🕵🏻‍♂️🏗️)

---

# Целевой первичный сценарий пользователя

## 1. Вход в Приложение

1. **Поиск и Иконка**:
   - Пользователь ищет, где потренировать устный счёт.
   - Находит минималистичную иконку и ёмкое манящее название приложения.

2. **Открытие Приложения**:
   - После открытия видит скриншоты из бесконечного дзен-режима и графики статистики.
   - Устанавливает приложение.

## 2. Онбординг

1. **Онбординг 1**:
   - При первом запуске показывается онбординг, который объясняет:
     - Нажмите кнопку **Zen** и решайте примеры после короткой рекламы.
     - Чтобы отключить рекламу, купите подписку.
     - Кнопка **Subscribe** для покупки подписки.

2. **Работа в Режиме Zen**:
   - Пользователь нажимает кнопку **Zen**.
   - Просматривает короткую рекламу.
   - Появляются примеры по центру экрана. Пользователь вводит ответы и повторяет цикл.

3. **Выход из Режима Zen**:
   - Пользователь нажимает кнопку **Wake** в верхнем правом углу экрана.
   - Видит последнюю статистику сеанса, представленную в виде дэшборда с тремя карточками:
     - Время сеанса
     - Количество примеров
     - Количество ошибок

## 3. Дальнейший Онбординг

1. **Онбординг 2**:
   - Для просмотра детальной статистики:
     - Дэшборд сеанса
     - Графики в динамике по сеансам и датам:
       - Время сеанса
       - Количество примеров
       - Количество ошибок
       - Процент правильных ответов за сеанс
       - Показатель правильных ответов в минуту

2. **Экран 1**: Моковый платный дэшборд сеанса.

3. **Экран 2**: Моковые данные в графике.

4. **Экран 3**: Предложение подписки с кнопкой **Subscribe**.

## 4. Реклама и Подписка

1. **При Запуске Режима Zen**:
   - Реклама показывается перед началом сеанса.
   - Внизу экрана кнопка **Subscribe to turn off ads** для отключения рекламы.

2. **По Завершении Сеанса**:
   - Бесплатная статистика сеанса с дэшбордом.
   - Внизу экрана кнопка **Subscribe to get insights** для получения детальной статистики.

---
</details>
