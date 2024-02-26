Инструкция может изменяться в течении курса.

Что потребуется
===============

Для работы над задачами вам нужно будет установить
 - Для работы и запуска тестов на основной ОС:
  #. Git :-).
  #. Компилятор (g++ или clang или msvc или mingw).
  #. Система сборки CMake >= 3.24.
  #. Менеджер зависимостей Conan >= 2.0.5.
  #. IDE для удобства. (QtCreator/CLion/Visual Studio/...). Можно жить в текстовом редакторе с консолью.
  #. Форматирование исходного кода clang-format.
  #. Средство анализа clang-tidy (необязательно).
 - Для запуска в докере:
  #. docker (Может называться как-то иначе, например, docker-buildx).
  #. Всё :-).

Как тестировать локально
========================

Здесь будет инструкция для докера (Там с большей вероятностью одинаково запуститься у всех. Плюс такой же докер тестирует ваши решения в облаке).

Билд докера
-----------
Создать директорию. В нее поместить Dockerfile. И выполнить::

  docker build -t cpp-build .

Запуск докера::

  docker run --rm  \
           --volume PATH_TO_YOUR_REPO:/home/ubuntu/repo:ro   \
           --volume PATH_TO_CONAN_CACHE:/home/ubuntu/.conan2/:rw \
           -it cpp-build

Где:
 * PATH_TO_YOUR_REPO -- Путь к вашему репозиторию
 * PATH_TO_CONAN_CACHE -- Путь к изначально пустой директории, чтобы конан каждый раз не пересобирал библиотеки

Запуск команд внутри докера. В целом все команды соответсвуют происходящему в файле .github/workflows/ACTION.yml.

Например, для проверки *плохих слов* можно выполнить::

  cd repo
  ! grep -R -n -w -f .bad_words src include

Для запуска clang-format::

  cd repo
  find . -not -path "./build/*" \( -iname "*.h" -o -iname "*.hpp" -o -iname "*.cpp" \) -exec clang-format --dry-run --Werror -style=file {} +

Для сборки и запуска тестов без санитайзеров::

  mkdir build
  cmake -S. -Bbuild -DUSE_CLANG_TIDY=TRUE -DTESTS_BUILD_TYPE=NONE -DCMAKE_BUILD_TYPE=Release
  cmake --build build
  ./build/tests/runUnitTests

Для сборки и запуска тестов c ASAN::

  mkdir build_ASAN
  cmake -S. -Bbuild_ASAN -DTESTS_BUILD_TYPE=ASAN -DCMAKE_BUILD_TYPE=Debug
  cmake --build build_ASAN
  ./build_ASAN/tests/runUnitTests

Как работать с заданиями
======================

#. Создаем репозиторий при помощи ссылки из таблицы.
#. Клонируем его к себе.
#. Создаем ветку develop.
#. Работаем в ней до прохождения тестов.
#. Создаем Pull Request.
#. Ждем.
#. Если не проверили в течении 2-3 дней. Пишем в чат/лс.
#. После проверки у вас могут появится замечания. Исправляем их, выполняем шаги 6-8. (Если нет, переходим к следующему шагу)
#. Проверяем, что появились баллы в таблице.
