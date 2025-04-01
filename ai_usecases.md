# USE-кейсы использования AI в данном проекте

## Настройка неочевидного скругления виджетов из сторонних пакетов
yandex_mapkit | Positioned.fill | ClipRRect | Stack

### Очевидное решение:

Обернуть в `container` с `BoxDecoration` и задать `BorderRadius.circle()`

**Результат:** идеально прямоугольная карта с <u>прямыми</u> углами выходит за пределы <u>скруглённого</u> контейнера

**Что в этот момент хотелось сделать?:** Погуглить / поменять дизайн (потому что ОЧЕНЬ может быть, что так сделать невозможно, это же карты, йоу) / воспользоваться ai

### AI (Cursor) 💥
> Как сделать, чтобы виджет YandexMap внутри container имел закруглённую рамку

1. ❌ Использование ClipRRect:

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16), // Здесь можно указать желаемый радиус
  child: Container(
    height: 300, // Укажите нужную высоту
    width: double.infinity,
    child: YandexMap(
      // ... ваши параметры карты ...
    ),
  ),
)
```

2. ❌ Использование Container с декорацией: _(уже пробовали)_

```dart
Container(
  height: 300,
  width: double.infinity,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    overflow: Clip.antiAlias,
  ),
  child: YandexMap(
    // ... ваши параметры карты ...
  ),
)
```

Первый вариант с ClipRRect является более предпочтительным, так как он гарантированно обрежет содержимое по границам скругления. Вы можете настроить радиус скругления, изменяя значение в `BorderRadius.circular()`.
Также убедитесь, что контейнер имеет фиксированные размеры (height и width), чтобы карта корректно отображалась.

> тем не менее карта не обрезается, выходит за пределы container

❌ В этом случае нужно использовать комбинацию ClipRRect и overflow: Clip.hardEdge для Container. Вот решение:

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Container(
    height: 300,
    width: double.infinity,
    clipBehavior: Clip.hardEdge, // Добавляем это свойство
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
    ),
    child: YandexMap(
      // ... ваши параметры карты ...
    ),
  ),
)
```

Ключевым моментом здесь является добавление `clipBehavior: Clip.hardEdge` к Container. Это свойство принудительно обрежет всё содержимое контейнера, включая карту, по границам контейнера.

❌ Если и это не поможет, можно попробовать обернуть YandexMap в SizedBox:

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(16),
  child: Container(
    height: 300,
    width: double.infinity,
    clipBehavior: Clip.hardEdge,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
    ),
    child: SizedBox(
      height: 300,
      width: double.infinity,
      child: YandexMap(
        // ... ваши параметры карты ...
      ),
    ),
  ),
)
```

Это должно гарантированно обрезать карту по границам контейнера с закруглёнными углами.

> карта не обрезается

✅ В случае с YandexMap может потребоваться более специфичное решение. Попробуйте использовать Stack с позиционированным ClipRRect, который будет действовать как маска:

```dart
Stack(
  children: [
    Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: YandexMap(
          // ... ваши параметры карты ...
        ),
      ),
    ),
  ],
)
```

Если и это не поможет, можно попробовать обернуть всю конструкцию в PhysicalModel:

```dart
PhysicalModel(
  color: Colors.transparent,
  borderRadius: BorderRadius.circular(16),
  clipBehavior: Clip.antiAlias,
  child: YandexMap(
    // ... ваши параметры карты ...
  ),
)
```

Если ни один из этих вариантов не работает, это может быть связано с особенностями реализации самого виджета YandexMap. В таком случае, вы можете попробовать создать issue в репозитории пакета yandex_mapkit, так как это может быть ограничением самого виджета.

Также убедитесь, что вы используете последнюю версию пакета yandex_mapkit, так как в более новых версиях могли исправить подобные проблемы с отображением.

### Итог:
10 минут на решение проблемы  + 10 минут на написание данного .md = красивые скругления карты 🗺️

