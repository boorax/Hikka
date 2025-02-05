# Разработчикам модулей
### Finally, кто-то сделал документацию по тому, как писать модули...

## Общая структура
Любой модуль начинается с:

- Лицензии
- Импорта зависимостей
- Подключения логирования
- Класса модуля, обернутого в декоратор @loader.tds
- Объявления базовых обработчиков


Все остальные действия выполняются внутри этого класса\*.

\*Важное примечание. Если функция не использует атрибуты и методы класса (`self.что-то`), ее стоит объявление стоит вынести за пределы класса.


## Справочник по структуре

`@loader.tds`
Декоратор, используемый на классе модуля. Нужен для добавления возможности локализации докстрингов команд.


```python
def __init__(self) -> None:
```
Вызывается при начале загрузки модуля. Обычно используется только для инициализации конфига.


```python
async def client_ready(self, client, db) -> None:
```
Вызывается в момент, когда готовы все инстансы (`client`, `db`). Основное место инициализации. Чаще всего здесь объявляют внутренние переменные, готовят базу данных, запускают нужные корутины и другие вещи, которые нужны при загрузке.


```python
async def on_unload(self) -> None:
```
Вызывается в момент выгрузки модуля. Максимальное время выполнения - 5 секунд, при превышении код прерывается. Используется для сброса бесконечных циклов и других действий, нужных при выгрузке \ перезагрузке модуля.

```python
async def testcmd(self, message: Message) -> None:
```
Таким образом выглядят обработчики команд. Все функции класса, которые заканчиваются на -cmd расцениваются как команды. Обратите внимание, что нельзя создать команду, которая начинается с цифры, содержит спецсимволы и др. Действуют те же ограничения, что и на обычные функции Python.

```python
async def watcher(self, message: Message) -> None:
```
Обработчик всех сообщений. В него приходят все события, которые вызваны другими сессиями (**не сессией юзербота**), включая сервисные сообщения.


## utils.py
Для повышения совместимости модуля рекомендуется использовать библиотеку `utils`. Она содержит множество полезных методов:

Возвращает список аргументов из сообщения
```python
get_args(message: Message) -> list
```
---

Возвращает необработанные аргументы в виде одной строки
```python
get_args_raw(message: Message) -> str
```
---

Возвращает список аргументов, разделенных символом sep
```python
get_args_split_by(message: Message, sep: str) -> list
```
---

Возвращает ID объекта (для чатов\каналов без -100)
```python
get_chat_id(message: Message) -> int
```
---

Экранирует HTML, данный в аргументе
```python
escape_html(text: str) -> str
```
---

Получает рабочую директорию
```python
get_base_dir() -> str
```
---

Получает директорию выбранного модуля
```python
get_dir(mod: str) -> str
```
---

Получает отправителя (не работает с сервисными сообщениями)
```python
get_user(message: Message) -> str
```
---

Оборачивает синхронный код в коротину. Рекомендуется использовать тогда, когда нужно внутри модуля использовать синхронный код, чтобы не останавливать основной поток
```python
run_sync(func: FunctionType, *args, **kwargs) -> coroutine
```
---

Репозиционирование объектов и их смещений
```python
relocate_entities(entities: ListLike, offset: int, text: str = None) -> list
```
---

Answer to a message (edit if possible, else send new message)
```python
answer(message: Message, response: str, *args, **kwargs) -> Many
```
---

Get possible target id
```python
get_target(message: Message, arg_no: int = 0) -> int or None
```
---

Merge two dictionaries
```python
merge(a: dict, b: dict) -> dict
```
---

Create new channel (if needed) and return its entity
```python
asset_channel(a: dict, b: dict) -> dict
```
---

Get telegram permalink to entity
```python
get_link(a: dict, b: dict) -> dict
```
---

Split provided `_list` into chunks of `n`
```python
chunks(a: dict, b: dict) -> dict
```



## strings
Хоть они и объявляются как словарь, на самом деле это не словарь. Их можно вызывать. Сделано это для упрощения локализации. Все строки, которые можно вынести в strings - выноси в strings. В этом же словаре объявляется отображаемое имя модуля. Старайся выбирать имя без пробелов, спецсимволов и другого шлака.

## db
База данных FTG. Практически всегда сохраняется в атрибут self.db или self.\_db.

Получение ключа из базы данных, заменяя его `default` в случае отсутствия:
```python
db.get(owner: str, key: str, default: Any = None) -> Many
```
---
Установка значения ключа базы данных
```python
db.set(owner: str, key: str, value: str) -> None
```
---
> Документация будет пополняться
