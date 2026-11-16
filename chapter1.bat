@echo off
chcp 65001 > nul
set score_go=0
set score_rust=0
set score_kotlin=0

echo ========================================================
echo   МОДУЛЬ 1: ВЫБОР ЯЗЫКА ДЛЯ МИКРОСЕРВИСОВ (Вариант 10)
echo   Контекст: Команда Java-разработчиков
echo ========================================================
echo.

echo Вопрос 1: Насколько критичны сроки запуска первого микросервиса?
echo 1. Очень сжатые (нужно выйти в продакшн максимально быстро)
echo 2. Умеренные (есть пара месяцев на обучение и прототип)
echo 3. Не критичны (делаем задел на годы вперёд, готовы долго учиться)
choice /c 123 /n /m "Ваш выбор (1-3): "
if errorlevel 3 (
    set /a score_rust+=15
    goto q2
)
if errorlevel 2 (
    set /a score_go+=15
    set /a score_kotlin+=5
    goto q2
)
if errorlevel 1 (
    set /a score_kotlin+=15
    set /a score_go+=5
)

:q2
echo.
echo Вопрос 2: Насколько важно переиспользование текущей инфраструктуры Java (JVM, библиотеки)?
echo 1. Критически важно (хотим использовать привычные фреймворки и JVM)
echo 2. Желательно, но готовы перейти на лёгкие независимые бинарники
echo 3. Не важно (нужен полный отказ от JVM и минимальное потребление памяти)
choice /c 123 /n /m "Ваш выбор (1-3): "
if errorlevel 3 (
    set /a score_rust+=15
    set /a score_go+=10
    goto q3
)
if errorlevel 2 (
    set /a score_go+=15
    goto q3
)
if errorlevel 1 (
    set /a score_kotlin+=20
)

:q3
echo.
echo Вопрос 3: Какие требования предъявляются к производительности и безопасности памяти?
echo 1. Экстремальная скорость, работа без сборщика мусора (GC)
echo 2. Высокая конкурентность (тысячи горутин) и быстрая сборка
echo 3. Стандартная производительность уровня корпоративного бэкенда
choice /c 123 /n /m "Ваш выбор (1-3): "
if errorlevel 3 (
    set /a score_kotlin+=15
    goto q4
)
if errorlevel 2 (
    set /a score_go+=20
    goto q4
)
if errorlevel 1 (
    set /a score_rust+=20
)

:q4
echo.
echo Вопрос 4: Каков средний уровень квалификации (грейд) в команде?
echo 1. Много Junior/Middle разработчиков (нужен низкий порог входа)
echo 2. Крепкие Middle/Senior Java-инженеры
echo 3. Опытные системные инженеры, готовые к сложной модели владения памятью
choice /c 123 /n /m "Ваш выбор (1-3): "
if errorlevel 3 (
    set /a score_rust+=15
    goto result
)
if errorlevel 2 (
    set /a score_go+=15
    set /a score_kotlin+=10
    goto result
)
if errorlevel 1 (
    set /a score_kotlin+=15
    set /a score_go+=10
)

:result
echo.
echo --------------------------------------------------------
echo Итоговый профиль баллов:
echo Go: %score_go% ^| Rust: %score_rust% ^| Kotlin: %score_kotlin%
echo --------------------------------------------------------

set "rec_tech=Kotlin"
set /a max_score=%score_kotlin%

if %score_go% gtr %max_score% (
    set "rec_tech=Go"
    set /a max_score=%score_go%
)
if %score_rust% gtr %max_score% (
    set "rec_tech=Rust"
    set /a max_score=%score_rust%
)

echo РЕКОМЕНДАЦИЯ СИСТЕМЫ: %rec_tech%
echo.
pause
