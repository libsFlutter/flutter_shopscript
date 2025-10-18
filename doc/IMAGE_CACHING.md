# Image Caching in Flutter ShopScript

## Overview

Flutter ShopScript использует `cached_network_image` для эффективного кеширования изображений продуктов, категорий и других медиа-файлов.

## Зависимости

```yaml
dependencies:
  cached_network_image: ^3.2.3
  flutter_cache_manager: ^3.3.1
```

## Реализация

### 1. Основной виджет для изображений продуктов

Все изображения загружаются через `CachedNetworkImage` с:
- **Placeholder** - индикатор загрузки во время получения изображения
- **Error Widget** - fallback виджет при ошибке загрузки
- **Автоматическое кеширование** - изображения кешируются локально

### 2. Примеры использования

#### В карточке продукта (ProductCard)

```dart
CachedNetworkImage(
  imageUrl: product.mainImage!,
  fit: BoxFit.cover,
  placeholder: (context, url) => Container(
    color: Colors.grey[200],
    child: const Center(
      child: CircularProgressIndicator(),
    ),
  ),
  errorWidget: (context, url, error) {
    return const Icon(Icons.image, size: 50);
  },
)
```

#### На странице деталей продукта

```dart
CachedNetworkImage(
  imageUrl: product.mainImage!,
  width: double.infinity,
  height: 300,
  fit: BoxFit.cover,
  placeholder: (context, url) => Container(
    height: 300,
    color: Colors.grey[200],
    child: const Center(
      child: CircularProgressIndicator(),
    ),
  ),
  errorWidget: (context, url, error) {
    return Container(
      height: 300,
      color: Colors.grey[200],
      child: const Icon(Icons.image, size: 100),
    );
  },
)
```

#### В корзине (CartScreen)

```dart
CachedNetworkImage(
  imageUrl: item.productImage!,
  width: 50,
  height: 50,
  fit: BoxFit.cover,
  placeholder: (context, url) => Container(
    width: 50,
    height: 50,
    color: Colors.grey[200],
    child: const Center(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  ),
  errorWidget: (context, url, error) {
    return const Icon(Icons.image);
  },
)
```

## Преимущества

### ✅ Производительность
- Изображения загружаются только один раз
- Кеш хранится на устройстве
- Быстрый доступ к ранее загруженным изображениям

### ✅ UX/UI
- Плавная загрузка с индикаторами прогресса
- Graceful degradation при ошибках
- Отсутствие мерцания при повторном отображении

### ✅ Экономия трафика
- Повторная загрузка не требуется
- Минимизация использования сети
- Поддержка offline режима для кешированных изображений

## Настройка кеша

### Управление кешем через CacheManager

```dart
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

// Очистить весь кеш
await DefaultCacheManager().emptyCache();

// Удалить конкретное изображение
await DefaultCacheManager().removeFile(imageUrl);

// Получить информацию о файле в кеше
final fileInfo = await DefaultCacheManager().getFileFromCache(imageUrl);
```

### Кастомная конфигурация кеша

```dart
class CustomCacheManager extends CacheManager {
  static const key = 'customCacheKey';
  
  static CustomCacheManager? _instance;
  
  factory CustomCacheManager() {
    _instance ??= CustomCacheManager._();
    return _instance!;
  }
  
  CustomCacheManager._() : super(
    Config(
      key,
      stalePeriod: const Duration(days: 7), // Время жизни кеша
      maxNrOfCacheObjects: 200, // Максимальное количество файлов
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

// Использование
CachedNetworkImage(
  imageUrl: imageUrl,
  cacheManager: CustomCacheManager(),
  // ...
)
```

## Best Practices

### 1. Всегда используйте placeholder
Предотвращает пустые области во время загрузки:

```dart
placeholder: (context, url) => Container(
  color: Colors.grey[200],
  child: const Center(
    child: CircularProgressIndicator(),
  ),
),
```

### 2. Обрабатывайте ошибки
Предоставьте fallback для сбоев сети:

```dart
errorWidget: (context, url, error) {
  return const Icon(Icons.broken_image, size: 50);
},
```

### 3. Оптимизируйте размеры
Для thumbnail используйте меньшие индикаторы:

```dart
placeholder: (context, url) => SizedBox(
  width: 20,
  height: 20,
  child: CircularProgressIndicator(strokeWidth: 2),
),
```

### 4. Учитывайте производительность списков
В больших списках кеширование критично для плавной прокрутки.

## Мониторинг

### Проверка состояния кеша

```dart
// Получить размер кеша
final cacheManager = DefaultCacheManager();
final directory = await cacheManager.store.fileSystem.createDirectory();
// Анализ содержимого
```

## Troubleshooting

### Изображения не кешируются
- Проверьте CORS заголовки сервера
- Убедитесь, что URL корректен
- Проверьте доступное место на устройстве

### Кеш занимает много места
- Уменьшите `maxNrOfCacheObjects`
- Сократите `stalePeriod`
- Регулярно очищайте кеш

### Изображения не обновляются
- Очистите кеш вручную
- Проверьте настройки `stalePeriod`
- Используйте уникальные URL с версиями

## Дополнительные возможности

### Fade-in анимация
```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  fadeInDuration: const Duration(milliseconds: 500),
  fadeOutDuration: const Duration(milliseconds: 200),
)
```

### Прогресс загрузки
```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  progressIndicatorBuilder: (context, url, downloadProgress) => 
    CircularProgressIndicator(value: downloadProgress.progress),
)
```

## Заключение

Кеширование изображений в Flutter ShopScript обеспечивает:
- Быструю загрузку
- Экономию трафика
- Улучшенный UX
- Поддержку offline режима

Все примеры приложений (`example/`, `example_marketplace/`) используют единый подход к кешированию изображений.

