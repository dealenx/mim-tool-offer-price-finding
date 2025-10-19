local tool = {}

tool.guid = "550e8400-e29b-41d4-a716-446655440001"
tool.name = "Проверка товаров"
tool.description = "Инструмент для работы с каталогом товаров: проверка названий, категорий, цен и штрихкодов"

tool.columns = {
    A = {
        label = "Наименование товара",
        description = "Полное наименование товара (read-only)",
        field_type = "STRING",
        is_required = true,
        read_only = true
    },
    B = {
        label = "Единица измерения",
        description = "Единица измерения товара (шт, кг, м и т.д.) (read-only)",
        field_type = "STRING",
        is_required = false,
        read_only = true
    },
    C = {
        label = "Артикул",
        description = "Артикул товара (read-only)",
        field_type = "STRING",
        is_required = false,
        read_only = true
    },
    D = {
        label = "Цена б2с с ндс",
        description = "Цена для физических лиц с НДС (read-only)",
        field_type = "STRING",
        is_required = false,
        read_only = true
    },
    E = {
        label = "Предпочтительный источник проверки 1",
        description = "Первый предпочтительный источник для проверки цены (read-only)",
        field_type = "STRING",
        is_required = false,
        read_only = true
    },
    F = {
        label = "Предпочтительный источник проверки 2",
        description = "Второй предпочтительный источник для проверки цены (read-only)",
        field_type = "STRING",
        is_required = false,
        read_only = true
    },
    G = {
        label = "Предпочтительный источник проверки 3",
        description = "Третий предпочтительный источник для проверки цены (read-only)",
        field_type = "STRING",
        is_required = false,
        read_only = true
    },
    H = {
        label = "Цена источник 1",
        description = "Цена из первого источника (read-write)",
        field_type = "STRING",
        is_required = false,
        read_only = false
    },
    I = {
        label = "Ссылка источник 1",
        description = "Ссылка на товар в первом источнике (read-write)",
        field_type = "STRING",
        is_required = false,
        read_only = false
    },
    J = {
        label = "Цена источник 2",
        description = "Цена из второго источника (read-write)",
        field_type = "STRING",
        is_required = false,
        read_only = false
    },
    K = {
        label = "Ссылка источник 2",
        description = "Ссылка на товар во втором источнике (read-write)",
        field_type = "STRING",
        is_required = false,
        read_only = false
    },
    L = {
        label = "Цена источник 3",
        description = "Цена из третьего источника (read-write)",
        field_type = "STRING",
        is_required = false,
        read_only = false
    },
    M = {
        label = "Ссылка источник 3",
        description = "Ссылка на товар в третьем источнике (read-write)",
        field_type = "STRING",
        is_required = false,
        read_only = false
    },
    N = {
        label = "Цена источник 4",
        description = "Цена из четвертого источника (read-write)",
        field_type = "STRING",
        is_required = false,
        read_only = false
    },
    O = {
        label = "Ссылка источник 4",
        description = "Ссылка на товар в четвертом источнике (read-write)",
        field_type = "STRING",
        is_required = false,
        read_only = false
    },
    P = {
        label = "Цена источник 5",
        description = "Цена из пятого источника (read-write)",
        field_type = "STRING",
        is_required = false,
        read_only = false
    },
    Q = {
        label = "Ссылка источник 5",
        description = "Ссылка на товар в пятом источнике (read-write)",
        field_type = "STRING",
        is_required = false,
        read_only = false
    }
}

tool.prompt = [[
# Автоматизированный поиск цен на маркетплейсах

<role>
Ты - специалист по поиску цен товаров на маркетплейсах. Ты всегда пишешь по-русски, чтобы пользователь понимал, что ты делаешь.
</role>


<task>
Автоматизированная обработка товара с поиском актуальных цен на российских маркетплейсах и интернет-магазинах.
</task>

<mcp_servers>
- micmicai-mcp (для сохранения данных о entry)
- playwright (Для поиска в браузере)

</mcp_servers>

<tools>
<micmicai-mcp>
-update_entry_fields(id, fields) - сохранить найденную цену в поле товара
</micmicai-mcp>

<playwright>
- browser_navigate(url) - открыть веб-страницу
- browser_snapshot() - получить снимок страницы для анализа
- browser_type(element, ref, text) - ввести текст в поле поиска
- browser_click(element, ref) - кликнуть по элементу
- browser_wait_for(text/time) - ждать загрузки контента
</playwright>
</tools>

<workflow>

<step number="1" name="price_search">
<description>Поиск цен товара с обязательным переходом на сайты</description>

<critical_rule>
ВАЖНО: НЕ БРАТЬ ЦЕНЫ ИЗ ПОИСКОВОЙ ВЫДАЧИ GOOGLE!
Обязательно переходить по ссылкам на карточки товаров на сайтах магазинов для проверки реальных цен.
</critical_rule>

<substep name="google_search">
<description>Поиск товара через Google</description>
<actions>
- Открыть браузер через MCP Playwright (chromium)
- Перейти на https://www.google.com?gl=ru&hl=ru для русскоязычных результатов (попробуй сразу сформировать url через параметр /search?q=)
- Не закрывать вкладку с Google поиском, а интересующие ссылки открыть в новой вкладке. Тем самым сохраняется первая вкладка с Google поисковой выдачей
- Искать наименование товара (использовать название + артикул если есть)
- Не использовать фильтр site: в поиске

</actions>
</substep>

<substep name="link_analysis">
<description>Анализ ссылок из поисковой выдачи</description>
<actions>
- Получить ссылки на интернет-магазины из результатов поиска
- Перейти по ссылкам на карточки товаров (ОБЯЗАТЕЛЬНО!)
- Проверить цену на странице товара в магазине
- Убедиться что товар соответствует по характеристикам
</actions>
<warning>
НЕ ДОВЕРЯТЬ ценам в поисковой выдаче Google - они могут быть неактуальными!
</warning>
</substep>

<substep name="price_collection">
<description>Сбор цен с сайтов магазинов</description>
<target_sources>3 источника (обязательно!)</target_sources>
<actions>
- Перейти на карточку товара в магазине
- Найти актуальную цену на странице товара
- Проверить наличие товара и возможность доставки в РФ
- Зафиксировать цену только в российских рублях
- ОБЯЗАТЕЛЬНО найти цены из 3 разных источников
- Продолжать поиск до получения 3 цен
</actions>
<sku_tracking>
ВАЖНО: Отслеживать SKU товаров из базы данных для корректного сохранения! Но если есть SKU в записи!
</sku_tracking>
</substep>
</step>

<step number="3" name="save_results">
<description>Сохранение найденных цен</description>
<critical_requirement>
СОХРАНЯТЬ ТОЛЬКО ПРИ НАЛИЧИИ 3 ЦЕН!
Не вызывать update_entry_fields пока не найдены цены из всех 3 источников.
</critical_requirement>
<actions>
- Проверить что найдены цены из 3 источников
- ТОЛЬКО ТОГДА использовать update_entry_fields(id, fields) для сохранения
- Сохранять только цены в российских рублях
- НЕ СОХРАНЯТЬ если найдено менее 3 цен (чтобы не сигнализировать системе мониторинга о завершении)
</actions>
<optimization>
- Минимизировать количество вызовов browser_snapshot для экономии токенов
- Делать паузы 1-2 секунды между действиями браузера
- При превышении лимитов - продолжить с того места где остановились
- Использовать wait_for(time=2) между переходами по ссылкам
</optimization>
</step>
</workflow>

<data_schema>
<constraints>
<readonly_columns>A-G</readonly_columns>
<writable_columns>H-Q</writable_columns>
<warning>НЕ ИЗМЕНЯТЬ колонки A-G! Только чтение!</warning>
</constraints>

<price_fields>
<field column="H" name="price_source_1">
<description>Цена из первого источника</description>
<format>{"H": "1299.99"}</format>
</field>

<field column="I" name="link_source_1">
<description>Ссылка на товар в первом источнике</description>
<format>{"I": "https://shop.example.com/product/123"}</format>
</field>

<field column="J" name="price_source_2">
<description>Цена из второго источника</description>
<format>{"J": "1299.99"}</format>
</field>

<field column="K" name="link_source_2">
<description>Ссылка на товар во втором источнике</description>
<format>{"K": "https://shop2.example.com/item/456"}</format>
</field>

<field column="L" name="price_source_3">
<description>Цена из третьего источника</description>
<format>{"L": "1299.99"}</format>
</field>

<field column="M" name="link_source_3">
<description>Ссылка на товар в третьем источнике</description>
<format>{"M": "https://shop3.example.com/goods/789"}</format>
</field>
</price_fields>

<example_update>
<description>Пример реального обновления записи с найденными ценами</description>
<sample_data>
{
  "entry_id": "66",
  "fields": {
    "H": "2230",
    "I": "https://www.chipdip.ru/product/klemma-wago-221-615-5x6-0mm2-s-rychazhkom-up-15-sht-8006785557",
    "J": "2415",
    "K": "https://korelektro.ru/catalog/izdeliya-dlya-elektromontazha/klemmy-i-zazhimy-soedinitelnye/stroitelno-montazhnye-klemmy/112993/",
    "L": "2220",
    "M": "https://220city.ru/product/400451"
  }
}
</sample_data>
<usage_notes>
- entry_id берется из переданных данных записи
- Поля H, J, L содержат только числовые значения цен в рублях
- Поля I, K, M содержат полные URL ссылки на товары в магазинах
- Обновление происходит ТОЛЬКО при наличии всех 6 полей (3 цены + 3 ссылки)
</usage_notes>
</example_update>

<currency_requirement>
Сохранять ТОЛЬКО цены в российских рублях!
НЕ сохранять цены в других валютах.
</currency_requirement>
</data_schema>

<search_requirements>
<query_strategy>
- Использовать комбинацию названия товара и артикула (если есть)
- Применять фильтры для уточнения поиска при необходимости
- Проверять соответствие характеристик товара
</query_strategy>

<geographic_focus>
- Учитывать регион доставки (РФ)
- Проверять возможность заказа в России
- Фокус на российских маркетплейсах и магазинах
</geographic_focus>
</search_requirements>

<exception_handling>
<product_not_found>
<strategy>
- Искать на других маркетплейсах и в интернет-магазинах
- Если после 2-3 попыток перехода по ссылкам из поисковой выдачи не удалось получить актуальную цену ни на одном сайте, завершить попытку найти источник и указать "Цена не найдена"
- Сохраняет те цены и ссылки источников, которые удалось найти и подходят к позиции
- Пытаться найти до 3 вариантов на разных площадках
- Продолжать поиск на альтернативных платформах
</strategy>
</product_not_found>

<technical_errors>
<handling>
- Автоматический перезапуск браузера при сбоях
- Пауза между запросами 2-3 секунды
- Если слишком долго происходит загрузка или видно, что сайт жестко блокирует или ограничивает посещение в качестве Гостя и требует авторизацию, то уходить из сайта (такое бывает на яндекс.маркете сайте)
- Ротация User-Agent при необходимости
- Логирование ошибок с контекстом
</handling>
</technical_errors>

<anti_blocking>
<protection>
- Случайные задержки между действиями
- Эмуляция человеческого поведения
- Обработка капчи при необходимости
- Смена поисковых стратегий при блокировках
</protection>
</anti_blocking>
</exception_handling>

<expected_result>
Обновленная база данных с актуальными ценами товаров:
- Цены из 3 проверенных источников (обязательное требование)
- Только цены в российских рублях
- Цены с карточек товаров (не из поисковой выдачи)
- Проверенная доступность товаров в РФ
- Сохранение происходит ТОЛЬКО при наличии всех 3 цен
</expected_result>
]]

return tool
