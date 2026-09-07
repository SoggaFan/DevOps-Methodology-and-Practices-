# ЛР1 - Рыболовная фирма

Минимальное приложение для учёта катеров, команд, рейсов, сортов рыбы и улова.

## Что реализовано
- HTTP API на FastAPI.
- Реляционная БД PostgreSQL.
- 5 связанных сущностей: `boats`, `crews`, `fish_types`, `trips`, `catches`.
- CRUD-подобные операции для основных справочников и добавления рейсов/улова.
- Health-check: `GET /health`.
- Валидация входных данных и понятные HTTP-ошибки.
- Предметное правило: суммарный улов рейса не может превышать грузоподъёмность катера.
- Конфигурация через переменные окружения.
- Docker Compose для приложения и БД.
- SQL-схема и начальные данные.
- Тесты и единый Makefile-интерфейс.

Требования ЛР1 предполагают путь `задача → изменение кода → локальные проверки → Git → CI → образ → CD → проверка релиза → наблюдение`; в этой работе на первом этапе реализованы приложение, Git-процесс, локальные проверки и контейнерный запуск.

## Быстрый старт

### Вариант А: Docker Compose (рекомендуется для защиты)
1. Скопировать `.env.example` в `.env` и задать пароль.
2. Запустить:
```bash
make up
```
3. Проверить:
```bash
make container-check
```
4. Открыть Swagger: http://localhost:8000/docs
5. Остановить:
```bash
make down
```

### Вариант Б: приложение локально, БД в Docker
```bash
cp .env.example .env
# установить DATABASE_URL с паролем из .env
make up
# в отдельном терминале:
make run
```
В этом варианте API доступен на http://localhost:8000.

## Основные endpoint'ы
- `GET /health`
- `GET/POST /api/boats`
- `GET/POST /api/crews`
- `GET/POST /api/fish-types`
- `GET/POST /api/trips`
- `GET/POST /api/catches`
- `GET /api/reports/catch-by-trip`

## Демонстрационный сценарий
1. Через Swagger создать/проверить катер.
2. Создать команду.
3. Создать сорт рыбы.
4. Создать рейс, связав `boat_id` и `crew_id`.
5. Добавить улов.
6. Добавить улов сверх грузоподъёмности - API должен вернуть `422`.
7. Показать `GET /api/reports/catch-by-trip`.
8. Показать `GET /health`.

## Git-процесс для ЛР1
Основная ветка: `main`.
Новая функция начинается с задачи, затем отдельная ветка `feature/<short-name>`, осмысленные коммиты, push и Merge Request/PR. После ревью изменения вливаются в `main`.

Пример:
```bash
git switch main
git pull --rebase
git switch -c feature/catch-capacity-rule
# изменить код
make verify
git add .
git commit -m "feat: validate catch capacity"
git push -u origin feature/catch-capacity-rule
```
Создать Merge Request/PR, показать diff и результаты проверок, выполнить merge.

## Искусственное разрешение конфликта
```bash
git switch main
git pull
git switch -c conflict-demo
# изменить одну строку README.md и commit
# в main изменить ту же строку и commit
# затем:
git switch conflict-demo
git merge main
```
Появятся маркеры `<<<<<<<`, `=======`, `>>>>>>>`. Исправить файл вручную, затем:
```bash
git add README.md
git commit -m "chore: resolve merge conflict"
```
После демонстрации можно удалить ветку.

## Версия
```bash
git tag -a v0.1.0 -m "ЛР1: первая минимально рабочая версия"
git push origin v0.1.0
```

## Что НЕ должно попасть в Git
- `.env`
- секреты и пароли
- виртуальное окружение `.venv/`
- кеши Python
- локальные файлы IDE

Проверка:
```bash
git status --ignored
git ls-files .env
```
Вторая команда не должна выводить `.env`.

## Команды Makefile
Командный интерфейс соответствует рекомендованной методичкой схеме: `make setup`, `make run`, `make test`, `make quality`, `make migrate`, `make backup`, `make restore`, `make verify`, `make up`, `make down`, `make container-check`.

ЛР1: реализовано правило ограничения улова грузоподъемностью катера.
