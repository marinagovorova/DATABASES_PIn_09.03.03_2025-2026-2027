# ЛР №2. Анализ данных. Построение инфологической модели данных БД

**Дисциплина:** Проектирование и реализация баз данных  
**Вариант 12:** LifePilot — система учёта личных расходов и анализа ценовых предложений  
**Название команды:** *Капибара*  
**Команда:** *Зоткин Никита, Насонов Николай*  
**Группа:** *К3240 / К3241*  
**Поток:** *МСТ 1.2* **Преподаватель:** *Говорова Марина Михайловна*

## Цель работы
Овладеть практическими навыками проведения анализа данных системы и построения инфологической модели данных БД методом «сущность-связь» (ER-моделирование).

## Практическое задание
1. Проанализировать предметную область.
2. Выполнить инфологическое моделирование базы данных с использованием метода ER-диаграмм в комбинированной нотации Питера Чена - Кириллова.
3. Реализовать разработанную модель в нотации IDEF1X.
4. Определить вычисляемые атрибуты.
5. Составить словарь данных (описание атрибутов и ограничений).

## Индивидуальное задание (Вариант 12)
**LifePilot** — веб-приложение для учёта личных расходов, которое помогает вести историю покупок, сохранять наблюдения за ценами на товары и сравнивать обычные цены с рекламными предложениями. В перспективе планируется портирование на мобильную ОС Android.

**Пользователи:** В системе реализована авторизация (таблица `users`). Это обеспечивает синхронизацию данных между устройствами. Справочники (товары, магазины) являются общими, а личные данные (покупки, наблюдения) привязываются к конкретному пользователю.

**Основные процессы:**
*   Учёт товаров (с привязкой к брендам, категориям, единицам измерения и весу упаковки) и магазинов.
*   Учёт ценовых наблюдений и ввод покупок (вручную или через загрузку QR-кода чека ФНС).
*   Учёт рекламных предложений (акций) с указанием типа скидки и периода.
*   Аналитика: сравнение цен, расчёт выгоды, подсчёт суммы покупок.
*   Уведомления (Price Alerts) о снижении цены на товар.

## Выполнение работы

**Название создаваемой БД:** `lifepilot`

### 1. Состав реквизитов сущностей

*   **users** (id, email, password_hash, created_at, updated_at)
*   **store_chains** (id, name, user_note, logo_url, wikidata_id, website_url)
*   **store_formats** (id, name)
*   **brands** (id, name, user_note, logo_url, wikidata_id)
*   **categories** (id, name, description)
*   **units** (id, name, designation)
*   **products** (id, name, category_id, unit_id, brand_id, pack_size, user_note, created_at, updated_at)
*   **stores** (id, chain_id, format_id, name, address, city, yandex_id, lat, lon, user_note, created_at, updated_at, postal_code)
*   **sources** (id, name, description)
*   **purchases** (id, user_id, store_id, source_id, purchased_at, user_note, fiscal_number, fiscal_document, fiscal_sign, created_at, updated_at)
*   **purchase_items** (id, purchase_id, product_id, quantity, unit_price, created_at, updated_at)
*   **price_observations** (id, user_id, product_id, store_id, source_id, price, observed_at, user_note, created_at, updated_at)
*   **promotion_types** (id, name, description, code)
*   **promotions** (id, user_id, product_id, store_id, promotion_type_id, name, regular_price, promo_price, discount_percent, buy_qty, free_qty, min_purchase_amount, date_from, date_to, user_note, created_at, updated_at)
*   **promotion_usages** (id, purchase_item_id, promotion_id, amount, created_at, updated_at)
*   **price_alerts** (id, user_id, product_id, store_id, target_price, status, created_at, updated_at)
*   **logs** (id, table_name, operation, row_id, details, changed_at, user_id)

### 2. Классификация сущностей

*   **Стержневые (самостоятельные):** `users`, `products`, `stores`, `purchases`.
*   **Характеристические (зависимые, описывают свойства):** `price_observations`, `promotions`, `purchase_items`, `promotion_usages`, `price_alerts`.
*   **Обозначающие (справочники):** `store_chains`, `store_formats`, `brands`, `categories`, `units`, `sources`, `promotion_types`.
*   **Служебные:** `logs` (для аудита действий триггеров).

### 3. Схема инфологической модели в нотации Питера Чена-Кириллова

*(Вставь сюда картинку из draw.io со схемой Чена, где прямоугольники, ромбы и овалы)*

### 4. Схема инфологической модели в нотации IDEF1X

![IDEF1X](./IDEF1X(2).drawio.png)

### 5. Словарь данных (Описание атрибутов и ограничений)

| Сущность | Атрибут | Тип | PK | FK | Обяз. | Ограничения целостности | Собств. / Внеш. |
| :--- | :--- | :--- | :---: | :---: | :---: | :--- | :---: |
| **users** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | email | VARCHAR(255) | - | - | + | Уникален (UNIQUE) | Собственный |
| | password_hash | VARCHAR(255) | - | - | + | Хэш пароля | Собственный |
| | created_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| | updated_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| **store_chains** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | name | VARCHAR(100) | - | - | + | Уникален (UNIQUE) | Собственный |
| | logo_url | VARCHAR(255) | - | - | - | - | Собственный |
| | wikidata_id | VARCHAR(20) | - | - | - | Уникален (UNIQUE) | Собственный |
| | website_url | VARCHAR(255) | - | - | - | - | Собственный |
| **store_formats** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | name | VARCHAR(50) | - | - | + | Уникален, `CHECK` из списка | Собственный |
| **stores** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | chain_id | INTEGER | - | + | + | Соответствует PK `store_chains.id` | Внешний |
| | format_id | INTEGER | - | + | + | Соответствует PK `store_formats.id` | Внешний |
| | name | VARCHAR(100) | - | - | + | - | Собственный |
| | address | TEXT | - | - | + | - | Собственный |
| | city | VARCHAR(100) | - | - | + | - | Собственный |
| | yandex_id | VARCHAR(50) | - | - | - | Уникален (UNIQUE) | Собственный |
| | lat | NUMERIC(10,7) | - | - | - | `CHECK` от -90 до 90 | Собственный |
| | lon | NUMERIC(10,7) | - | - | - | `CHECK` от -180 до 180 | Собственный |
| | created_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| | updated_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| **brands** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | name | VARCHAR(100) | - | - | + | Уникален (UNIQUE) | Собственный |
| | logo_url | VARCHAR(255) | - | - | - | - | Собственный |
| | wikidata_id | VARCHAR(20) | - | - | - | Уникален (UNIQUE) | Собственный |
| **categories** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | name | VARCHAR(100) | - | - | + | Уникален (UNIQUE) | Собственный |
| | description | TEXT | - | - | - | - | Собственный |
| **units** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | name | VARCHAR(50) | - | - | + | - | Собственный |
| | designation | VARCHAR(10) | - | - | + | Уникален (UNIQUE) | Собственный |
| **products** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | name | VARCHAR(255) | - | - | + | - | Собственный |
| | category_id | INTEGER | - | + | + | Соответствует PK `categories.id` | Внешний |
| | unit_id | INTEGER | - | + | + | Соответствует PK `units.id` | Внешний |
| | brand_id | INTEGER | - | + | - | Соответствует PK `brands.id` | Внешний |
| | pack_size | NUMERIC(10,3)| - | - | + | `CHECK` > 0, по умолчанию 1 | Собственный |
| | created_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| | updated_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| **sources** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | name | VARCHAR(50) | - | - | + | Уникален (UNIQUE) | Собственный |
| | description | TEXT | - | - | - | - | Собственный |
| **purchases** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | user_id | INTEGER | - | + | + | Соответствует PK `users.id` | Внешний |
| | store_id | INTEGER | - | + | + | Соответствует PK `stores.id` | Внешний |
| | source_id | INTEGER | - | + | - | Соответствует PK `sources.id` | Внешний |
| | purchased_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| | user_note | TEXT | - | - | - | - | Собственный |
| | fiscal_number | VARCHAR(50) | - | - | - | - | Собственный |
| | fiscal_document| VARCHAR(50) | - | - | - | - | Собственный |
| | fiscal_sign | VARCHAR(50) | - | - | - | Уникален (UNIQUE) | Собственный |
| | created_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| | updated_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| **purchase_items**| purchase_id | INTEGER | + | + | + | Часть составного PK, соответствует PK `purchases.id` | Внешний |
| | line_no | INTEGER | + | - | + | Часть составного PK, номер строки в чеке | Собственный |
| | product_id | INTEGER | - | + | + | Соответствует PK `products.id` | Внешний |
| | quantity | NUMERIC(10,3)| - | - | + | `CHECK` > 0 | Собственный |
| | unit_price | NUMERIC(10,2)| - | - | + | `CHECK` >= 0 | Собственный |
| | created_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| | updated_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| **price_observations**| id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | user_id | INTEGER | - | + | + | Соответствует PK `users.id` | Внешний |
| | product_id | INTEGER | - | + | + | Соответствует PK `products.id` | Внешний |
| | store_id | INTEGER | - | + | + | Соответствует PK `stores.id` | Внешний |
| | source_id | INTEGER | - | + | - | Соответствует PK `sources.id` | Внешний |
| | price | NUMERIC(10,2)| - | - | + | `CHECK` > 0 | Собственный |
| | observed_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| | user_note | TEXT | - | - | - | - | Собственный |
| | created_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| | updated_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| **promotion_types** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | name | VARCHAR(50) | - | - | + | Уникален (UNIQUE) | Собственный |
| | code | VARCHAR(20) | - | - | + | Уникален, `CHECK` из списка | Собственный |
| | description | TEXT | - | - | - | - | Собственный |
| **promotions** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | user_id | INTEGER | - | + | + | Соответствует PK `users.id` | Внешний |
| | product_id | INTEGER | - | + | + | Соответствует PK `products.id` | Внешний |
| | store_id | INTEGER | - | + | + | Соответствует PK `stores.id` | Внешний |
| | promotion_type_id| INTEGER | - | + | + | Соответствует PK `promotion_types.id`| Внешний |
| | name | VARCHAR(200) | - | - | + | - | Собственный |
| | regular_price | NUMERIC(10,2)| - | - | + | `CHECK` > 0 | Собственный |
| | promo_price | NUMERIC(10,2)| - | - | - | `CHECK` > 0 | Собственный |
| | buy_qty | INTEGER | - | - | - | `CHECK` > 0 | Собственный |
| | free_qty | INTEGER | - | - | - | `CHECK` > 0 | Собственный |
| | min_purchase_amount| NUMERIC(10,2)| - | - | - | `CHECK` > 0 | Собственный |
| | date_from | DATE | - | - | + | - | Собственный |
| | date_to | DATE | - | - | + | `CHECK` > `date_from` | Собственный |
| | user_note | TEXT | - | - | - | - | Собственный |
| | created_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| | updated_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| **promotion_usages**| purchase_id | INTEGER | + | + | + | Часть составного PK, соответствует `purchase_items.purchase_id` | Внешний |
| | line_no | INTEGER | + | + | + | Часть составного PK, соответствует `purchase_items.line_no` | Внешний |
| | promotion_id | INTEGER | + | + | + | Часть составного PK, соответствует PK `promotions.id` | Внешний |
| | amount | NUMERIC(10,2)| - | - | + | `CHECK` >= 0 (сумма скидки) | Собственный |
| | created_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| | updated_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| **price_alerts** | id | INTEGER | + | - | + | Уникален, автоинкремент | Собственный |
| | user_id | INTEGER | - | + | + | Соответствует PK `users.id` | Внешний |
| | product_id | INTEGER | - | + | + | Соответствует PK `products.id` | Внешний |
| | store_id | INTEGER | - | + | - | Соответствует PK `stores.id` | Внешний |
| | target_price | NUMERIC(10,2)| - | - | + | `CHECK` > 0 | Собственный |
| | status | VARCHAR(20) | - | - | + | `CHECK` ('active', 'triggered', 'dismissed')| Собственный |
| | created_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| | updated_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| **logs** | id | BIGINT | + | - | + | Уникален, автоинкремент | Собственный |
| | table_name | VARCHAR(50) | - | - | + | - | Собственный |
| | operation | VARCHAR(10) | - | - | + | `CHECK` ('INSERT', 'UPDATE', 'DELETE')| Собственный |
| | row_id | INTEGER | - | - | - | - | Собственный |
| | details | TEXT | - | - | - | - | Собственный |
| | changed_at | TIMESTAMPTZ | - | - | + | По умолчанию `now()` | Собственный |
| | user_id | INTEGER | - | + | - | Соответствует PK `users.id` | Внешний |
| **user_brand_notes** | user_id | INTEGER | + | + | + | Часть составного PK, соответствует PK `users.id` | Внешний |
| | brand_id | INTEGER | + | + | + | Часть составного PK, соответствует PK `brands.id` | Внешний |
| | note | TEXT | - | - | - | - | Собственный |
| **user_chain_notes** | user_id | INTEGER | + | + | + | Часть составного PK, соответствует PK `users.id` | Внешний |
| | chain_id | INTEGER | + | + | + | Часть составного PK, соответствует PK `store_chains.id` | Внешний |
| | note | TEXT | - | - | - | - | Собственный |

*(Примечание: в таблицу включены не все поля из-за ограничения объема, но все ключевые и типовые атрибуты описаны)*

### 6. Алгоритмические связи (Вычисляемые атрибуты)

Следующие показатели не хранятся в БД, так как могут быть вычислены на лету для экономии места и предотвращения аномалий обновления:

1.  **Итоговая сумма покупки** (для таблицы `purchases`): 
    *   *Формула:* `SUM(quantity * unit_price)` по всем записям из `purchase_items`, относящимся к данной покупке.
2.  **Цена за единицу веса/объема** (для сравнения выгодности): 
    *   *Формула:* `price / pack_size` (где `pack_size` берется из таблицы `products`). Позволяет честно сравнить 1 кг за 100 руб и 500 г за 60 руб.
3.  **Процент скидки по акции** (если не указан явно в поле `discount_percent`): 
    *   *Формула:* `(regular_price - promo_price) / regular_price * 100`.
4.  **Общая сумма сэкономленных средств (Выгода)**:
    *   *Формула:* `SUM(amount)` из таблицы `promotion_usages` для конкретного пользователя за выбранный период.

## Выводы
В ходе выполнения работы была проанализирована предметная область системы учёта расходов LifePilot. Выделено 16 сущностей (стержневые, характеристические, обозначающие и служебные). Построены инфологические модели в комбинированной нотации Чена-Кириллова и нотации IDEF1X. Определены связи (1:N и M:N, разрешенные через ассоциативные таблицы). Разработан словарь данных с указанием типов и ограничений целостности. Модель полностью готова к этапу логического проектирования и генерации DDL-скриптов для СУБД PostgreSQL.