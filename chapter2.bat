@echo off
chcp 65001 > nul
set score=0
set correct=0
set total=3

echo ========================================================
echo   МОДУЛЬ 2: ИНСПЕКЦИЯ КОДА МИКРОСЕРВИСОВ (Вариант 10)
echo ========================================================
echo Правила: верный ответ = +10 очков, ошибка = -5 очков.
echo.

echo --- Фрагмент 1 (Go: HTTP-клиент микросервиса) ---
echo 10: func fetchUser(url string) ([]byte, error) {
echo 11:     resp, err := http.Get(url)
echo 12:     if err != nil {
echo 13:         return nil, err
echo 14:     }
echo 15:     return io.ReadAll(resp.Body)
echo 16: }
echo.
echo Какой дефект здесь скрыт?
echo 1. Магическое число
echo 2. Утечка ресурса (не закрыт resp.Body.Close())
echo 3. Неинициализированная переменная
choice /c 123 /n /m "Ваш выбор (1-3): "
if errorlevel 3 goto f1_wrong
if errorlevel 2 (
    echo [ВЕРНО!] Забыт defer resp.Body.Close(^), соединение не освобождается. (+10 очков)
    set /a score+=10
    set /a correct+=1
    goto f2
)
:f1_wrong
echo [ОШИБКА!] Правильный ответ: 2 (Утечка ресурса). (-5 очков)
set /a score-=5

:f2
echo.
echo --- Фрагмент 2 (Kotlin: биллинг-сервис) ---
echo 20: fun calculateServiceFee(amount: Double): Double {
echo 21:     val fee = amount * 0.035
echo 22:     return amount + fee
echo 23: }
echo.
echo Какой дефект здесь скрыт?
echo 1. Магическое число (0.035 без константы)
echo 2. Мёртвое присваивание
echo 3. Отсутствие обработки ошибок
choice /c 123 /n /m "Ваш выбор (1-3): "
if errorlevel 2 goto f2_wrong
if errorlevel 1 (
    echo [ВЕРНО!] Коэффициент комиссии 0.035 нужно вынести в именованную константу. (+10 очков)
    set /a score+=10
    set /a correct+=1
    goto f3
)
:f2_wrong
echo [ОШИБКА!] Правильный ответ: 1 (Магическое число). (-5 очков)
set /a score-=5

:f3
echo.
echo --- Фрагмент 3 (Rust: чтение конфигурации сервиса) ---
echo 30: fn load_port() -^> u16 {
echo 31:     let cfg = std::fs::read_to_string("config.toml").unwrap();
echo 32:     let port: u16 = cfg.trim().parse().unwrap();
echo 33:     return port;
echo 34: }
echo.
echo Какой дефект здесь скрыт?
echo 1. Неинициализированная переменная
echo 2. Мёртвое присваивание
echo 3. Отсутствие обработки ошибок (использование .unwrap() вызовет панику)
choice /c 123 /n /m "Ваш выбор (1-3): "
if errorlevel 3 (
    echo [ВЕРНО!] При отсутствии файла или неверном формате сервис упадет с panic! (+10 очков)
    set /a score+=10
    set /a correct+=1
    goto summary
)
echo [ОШИБКА!] Правильный ответ: 3 (Отсутствие обработки ошибок). (-5 очков)
set /a score-=5

:summary
set /a percentage=correct*100/total
set rev_level=Junior Reviewer
if %percentage% geq 80 set rev_level=Senior Reviewer
if %percentage% geq 50 if %percentage% lss 80 set rev_level=Middle Reviewer

echo.
echo ========================================================
echo   ИТОГОВЫЙ ОТЧЁТ ИНСПЕКЦИИ КОДА
echo ========================================================
echo Просмотрено фрагментов: %total%
echo Правильных ответов:     %correct% из %total%
echo Набрано очков:          %score%
echo Точность ревью:         %percentage%%%
echo Уровень ревьюера:       %rev_level%
echo ========================================================
echo.
pause
exit /b 0
