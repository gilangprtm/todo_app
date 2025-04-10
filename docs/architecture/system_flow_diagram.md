# Diagram Alur Sistem

## Alur Data

Alur data dalam aplikasi mengikuti pola unidirectional (satu arah), dari Repositori hingga UI:

```
┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│  Repository  │─────▶│   Service    │─────▶│    State     │
└──────────────┘      └──────────────┘      └──────────────┘
                                                  │
                                                  ▼
                                           ┌──────────────┐
                                           │   Notifier   │
                                           └──────────────┘
                                                  │
┌──────────────┐                                  │
│      UI      │◀─────────────────────────────────┘
└──────────────┘
       │
       └───────────────────┐
                           ▼
                    ┌──────────────┐
                    │    Action    │
                    └──────────────┘
                           │
                           ▼
                    ┌──────────────┐
                    │   Service    │
                    └──────────────┘
```

## Alur Caching

Sistem caching terintegrasi dalam alur data:

```
┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│  Repository  │─────▶│   Service    │─────▶│  Cache Check │
└──────────────┘      └──────────────┘      └──────┬───────┘
                                                  │
                      ┌─────────────────┐         │
                      │ Return Cached   │◀────────┤ Cache Valid?
                      │     Data        │  Yes    │
                      └─────────────────┘         │
                                                  │ No
                                                  ▼
                                          ┌───────────────┐
                                          │  Fetch Data   │
                                          └───────┬───────┘
                                                  │
                                                  ▼
                                          ┌───────────────┐
                                          │ Update Cache  │
                                          └───────┬───────┘
                                                  │
                                                  ▼
                                          ┌───────────────┐
                                          │ Return Data   │
                                          └───────────────┘
```

## Alur State Management

Riverpod digunakan untuk pengelolaan state dengan alur berikut:

```
┌──────────────────┐     ┌──────────────────┐
│ StateNotifier    │────▶│ State            │
│ (Logic)          │     │ (Data)           │
└──────────────────┘     └─────────┬────────┘
                                  │
          ┌─────────────────────────────────────────┐
          │                                         │
          ▼                                         ▼
┌─────────────────┐                    ┌─────────────────────┐
│ Provider        │                    │ ConsumerWidget /    │
│ (Access Point)  │─────────────────▶ │ Consumer            │
└─────────────────┘                    └─────────────────────┘
                                                │
                                                │
┌─────────────────┐                            │
│ User Interaction│◀───────────────────────────┘
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Notifier Method │
└─────────────────┘
```

## Alur Manajemen Error

Error handling diimplementasikan pada semua lapisan:

```
┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│  Repository  │─────▶│   Service    │─────▶│   Notifier   │
└──────┬───────┘      └──────┬───────┘      └──────┬───────┘
       │                     │                     │
       ▼                     ▼                     ▼
┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│ Error Handler│      │ Error Handler│      │ Error Handler│
│ (Repository) │      │  (Service)   │      │  (Notifier)  │
└──────────────┘      └──────────────┘      └──────┬───────┘
                                                  │
                                                  ▼
                                           ┌──────────────┐
                                           │  State with  │
                                           │     Error    │
                                           └──────┬───────┘
                                                  │
                                                  ▼
                                           ┌──────────────┐
                                           │     UI       │
                                           │ Error Display│
                                           └──────────────┘
```

## Alur Cache Maintenance

Strategi pemeliharaan cache otomatis:

```
┌───────────────┐
│ App Startup   │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│   Check Cache │
│     Size      │
└───────┬───────┘
        │
        ▼
┌───────────────┐     No     ┌───────────────┐
│  > 80% of Max │───────────▶│    Continue   │
│     Limit?    │            │    Startup    │
└───────┬───────┘            └───────────────┘
        │ Yes
        ▼
┌───────────────┐
│ Clean Expired │
│     Cache     │
└───────┬───────┘
        │
        ▼
┌───────────────┐     No     ┌───────────────┐
│ Still > 80%?  │───────────▶│    Continue   │
└───────┬───────┘            │    Startup    │
        │ Yes                └───────────────┘
        ▼
┌───────────────┐
│  Apply LRU +  │
│ TTL Strategy  │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│  Continue     │
│    Startup    │
└───────────────┘
```

## Alur User Interaction

Interaksi pengguna memicu alur state sebagai berikut:

```
┌───────────────┐
│  User Action  │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ UI Call to    │
│ Notifier      │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ State Update  │
│ (setLoading)  │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Service Call  │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ Repository    │
│ Data Access   │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ State Update  │
│ (with Data)   │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│ UI Updates    │
│ Automatically │
└───────────────┘
```
