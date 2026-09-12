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
- Пользовательский веб-интерфейс: `GET /` (катера, команды, сорта рыбы, рейсы, улов и отчёт).
- Документация HTTP API: `GET /docs`.
- Схема данных: `docs/DATA_MODEL.md`.
- Тесты и единый Makefile-интерфейс.
- CI для push и Pull Request/Merge Request: `.github/workflows/ci.yml`.

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
4. Открыть веб-интерфейс: http://localhost:8000/
5. Документация API: http://localhost:8000/docs
6. Остановить:
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
- `GET /api/reports/catch-by-period`
- `GET /api/reports/catch-by-trip`
- `GET /` — пользовательский веб-интерфейс

## Демонстрационный сценарий
1. Открыть `http://localhost:8000/` и проверить статус API/БД.
2. Через веб-интерфейс создать/проверить катер, команду и сорт рыбы.
3. Создать рейс, связав катер и команду.
4. Добавить улов.
5. Добавить улов сверх грузоподъёмности — интерфейс должен показать ошибку `422`.
6. Обновить отчёт по периоду.
7. Открыть `/docs` и показать соответствующие HTTP endpoint'ы.
8. Показать `GET /health`.

## Git-процесс для ЛР1
Основная ветка: `main`. Прямые изменения в `main` запрещены; все изменения принимаются через Pull Request / Merge Request. Новая функция начинается с задачи, затем создаётся `feature/<short-name>`, выполняются осмысленные коммиты, локальные проверки, push и Pull Request/Merge Request. После ревью выполняется merge в `main`.

Подробная инструкция для реального GitHub/GitLab remote находится в `docs/REMOTE_REPOSITORY.md`, а пример оформленного PR — в `docs/PR-002-LAB-REQUIREMENTS-4-7-8.md`. CI автоматически запускает `make quality` и `make test` на push и PR.

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

## Схема данных
Полная ER-схема с описанием связей: `docs/DATA_MODEL.md`.

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
