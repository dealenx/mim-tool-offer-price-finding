local tool = {}

tool.guid = "550e8400-e29b-41d4-a716-446655440001"
tool.name = "Проверка товаров"
tool.description = "Инструмент для работы с каталогом товаров: проверка названий, категорий, цен и штрихкодов"

tool.columns = {
    A = {
        label = "Название",
        description = "Наименование товара",
        field_type = "STRING",
        is_required = true,
        read_only = false
    },
    B = {
        label = "Категория", 
        description = "Категория товара",
        field_type = "STRING",
        is_required = true,
        read_only = false
    },
    C = {
        label = "Цена",
        description = "Цена товара в рублях",
        field_type = "NUMBER",
        is_required = true,
        read_only = false
    }
}

tool.prompt = [[
Проанализируй строку из каталога продуктов.
Проверь корректность названия, категории и цены.
Если находишь ошибки - предложи исправления.
]]

return tool