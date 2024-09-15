# MVP Vision

## Intro

This doc is describing on how we see the eventual [minimum-viable product](https://en.wikipedia.org/wiki/Minimum_viable_product) that'll be shipped to the AppStore.

<img src="https://upload.wikimedia.org/wikipedia/commons/0/04/From_minimum_viable_product_to_more_complex_product.png" alt="how2bb" style="float: left; margin-right: 10px;" />

## Guide (🚧🕵🏻‍♂️🏗️)

<details>
  <summary>Title of Collapsible Section</summary>

  # Structuring the MVP Vision for an Indie Team

  As indie developers, you have the advantage of being nimble and innovative. Here’s a structured approach to crafting your MVP vision, ensuring you build the **right product** for the **right audience** with limited resources.

  ---

  ## 1. Identify Core Purpose and Value
  - **Focus on the Problem**: Determine the core problem your app is solving. Your MVP should address this main issue, ensuring it is the most polished aspect of the app.
  - **Define Your Unique Value Proposition**: What makes your app stand out? This unique element is crucial for competing with larger companies, giving users a compelling reason to choose your app.

  ## 2. Understand Your Target Audience
  - **Who Are You Building For?**: Specify your audience—casual users, power users, or beginners. This ensures your MVP focuses on features valuable to them.
  - **Engage Early**: Test ideas with potential users through mockups, beta tests, or prototypes before fully developing the app.

     **Questions to Ask:**
     - What platforms do our users prefer (iOS only, or future cross-platform)?
     - What are their pain points? How does our app fit into their routine?

  ## 3. List Critical Features (Must-Have vs Nice-to-Have)
  - **Focus on Essentials**: Categorize features into **must-have** (essential for functionality) and **nice-to-have** (additional but not crucial). Avoid feature creep.

     **Example Breakdown**:
     - **Must-Have**: Core functionality that drives the app’s purpose (e.g., for a note-taking app, basic note creation, editing, and saving).
     - **Nice-to-Have**: Additional features like themes or advanced analytics can be added later.

  ## 4. Set Measurable Goals and Metrics
  - **User Acquisition**: Set realistic goals for user acquisition, such as expected downloads, initial feedback, or engagement metrics like daily active users.
  - **User Retention**: Focus on retaining users. Measure engagement to understand why users may not return after their first use.
  - **Technical Performance**: Track metrics around app stability (e.g., crash rates) and performance (e.g., load time).

     **Key Metrics for MVP Success:**
     - How many users complete the core task?
     - How many users return after their first use?
     - What is the app’s crash rate?

  ## 5. Study the Competition and Market
  - **Know Your Competitors**: Research similar apps and user feedback. Identify gaps and address them in your MVP.
  - **App Store Categories and Trends**: Understand your app’s category, competition, and market trends. Ensure your app fits into a growing or under-served space.

  ## 6. Prototype and Iterate Quickly
  - **Low-Fidelity Prototypes**: Start with sketches, wireframes, or low-fidelity prototypes to test basic user flows and gather feedback.
  - **Fast Feedback Loop**: Launch internal betas to refine your MVP based on real user feedback before broader release.

     **Key Question:** How fast can we get from idea to prototype without sacrificing quality?

  ## 7. Avoid Common Pitfalls
  - **Overloading the MVP**: Resist adding too many features initially. The MVP should be minimal, functional, and clear in purpose.
  - **Ignoring User Feedback**: Base the MVP’s evolution on real user feedback, not just internal ideas.
  - **Forgetting the Long-Term Vision**: Keep the long-term vision in mind, but focus on what’s necessary for the first step.

  ## 8. Define Your Launch Strategy
  - **Soft Launch**: Target a smaller region or group first to gather feedback and fix issues before a full release.
  - **App Store Optimization (ASO)**: Optimize your app’s title, description, keywords, and screenshots for better visibility in the App Store.
  - **Marketing and Community**: Promote your MVP using social media, developer forums, or niche communities. Build a small, passionate group of early adopters.

  ---

  ## Checklist for Structuring the MVP Vision

  - **What problem does the MVP solve?**
  - **Who is the target audience, and what are their needs?**
  - **What are the essential features we need for launch?**
  - **What success metrics (downloads, retention, engagement) do we track?**
  - **What is the competition doing, and how do we stand out?**
  - **How do we gather early feedback and iterate fast?**
  - **How do we prepare for a soft launch with ASO and community engagement?**

  ---

  ## Final Thought

  For a small indie team, staying **focused** and **nimble** is crucial. Keep the MVP vision tight and aligned with your core values. Be ready to adjust based on user feedback, but always remember the problem you set out to solve. With a clear structure and well-defined goals, you can make a market impact with your MVP, setting the stage for long-term success.

</details>

## Serega's Thought (🚧🕵🏻‍♂️🏗️)

<details>
  <summary>Title of Collapsible Section</summary>

  Сперва предлагаю реализовать только один режим и не давать выбора настроек, сперва отточим в целом генерацию и генерацию на лету.
Сейчас вижу целесообразным следующий сценарий пользователя:

Ищу где потренировать устный счёт
Вижу минималистичную иконку и ёмкое манящее название
Открываю и вижу скрины из бесконечного дзен режима, графики статистики.
Устанавливаю
Онбоардинг 1 когда только захожу: нажмите кнопку Zen и решайте после короткой рекламы. Чтобы отключить рекламу - купите подписку. Кнопка Subscribe.
Я жму, смотрю рекламу, затем начинают появляться примеры по центру экрана, я ввожу ответ и заново в цикле
Я устал, жму сверху справа кнопку Wake
Мне высвечивается последняя статистика дэшбордом 3 карточки: время сеанса, количество примеров, количество ошибок.
Онбоардинг 2: чтобы посмотреть детальную статистику : дэшборд сеанса, также графики в динамике по сеансам / по датам: время сеанса, количество примеров, количество ошибок, %правильных ответов за сеанс, приведённый показатель правильных ответов в минуту.
Первый раз показать (экран 1) моковый платный дэшбоард сеанса и (экран 2) моковые данные в графике. (Экран 3) Предложение Subscribe.
Каждый раз при запуске дзен - реклама и внизу кнопка subscribe to turn off ads
Каждый раз при окончании дзена: бесплатная статистика сеанса бесплатный дэшборд и внизу кнопка subscribe to get insights  

</details>
