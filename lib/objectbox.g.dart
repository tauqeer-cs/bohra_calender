// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'screens/add_personal_event.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 5256458540762162001),
      name: 'PersonalEvent',
      lastPropertyId: const IdUid(7, 6607104171707915729),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 7762551733390490815),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 7475725982095857901),
            name: 'idNumber',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 3343686257403520576),
            name: 'hijriDay',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 7989307506066003745),
            name: 'hijriMonth',
            type: 6,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 3819403646063336126),
            name: 'title',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 4156167819389687079),
            name: 'details',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(7, 6607104171707915729),
            name: 'alreadySynced',
            type: 1,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(1, 5256458540762162001),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    PersonalEvent: EntityDefinition<PersonalEvent>(
        model: _entities[0],
        toOneRelations: (PersonalEvent object) => [],
        toManyRelations: (PersonalEvent object) => {},
        getId: (PersonalEvent object) => object.id,
        setId: (PersonalEvent object, int id) {
          object.id = id;
        },
        objectToFB: (PersonalEvent object, fb.Builder fbb) {
          final titleOffset = fbb.writeString(object.title);
          final detailsOffset = fbb.writeString(object.details);
          fbb.startTable(8);
          fbb.addInt64(0, object.id);
          fbb.addInt64(1, object.idNumber);
          fbb.addInt64(2, object.hijriDay);
          fbb.addInt64(3, object.hijriMonth);
          fbb.addOffset(4, titleOffset);
          fbb.addOffset(5, detailsOffset);
          fbb.addBool(6, object.alreadySynced);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = PersonalEvent()
            ..id = const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0)
            ..idNumber =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 6, 0)
            ..hijriDay =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 8, 0)
            ..hijriMonth =
                const fb.Int64Reader().vTableGet(buffer, rootOffset, 10, 0)
            ..title =
                const fb.StringReader().vTableGet(buffer, rootOffset, 12, '')
            ..details =
                const fb.StringReader().vTableGet(buffer, rootOffset, 14, '')
            ..alreadySynced =
                const fb.BoolReader().vTableGet(buffer, rootOffset, 16, false);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [PersonalEvent] entity fields to define ObjectBox queries.
class PersonalEvent_ {
  /// see [PersonalEvent.id]
  static final id =
      QueryIntegerProperty<PersonalEvent>(_entities[0].properties[0]);

  /// see [PersonalEvent.idNumber]
  static final idNumber =
      QueryIntegerProperty<PersonalEvent>(_entities[0].properties[1]);

  /// see [PersonalEvent.hijriDay]
  static final hijriDay =
      QueryIntegerProperty<PersonalEvent>(_entities[0].properties[2]);

  /// see [PersonalEvent.hijriMonth]
  static final hijriMonth =
      QueryIntegerProperty<PersonalEvent>(_entities[0].properties[3]);

  /// see [PersonalEvent.title]
  static final title =
      QueryStringProperty<PersonalEvent>(_entities[0].properties[4]);

  /// see [PersonalEvent.details]
  static final details =
      QueryStringProperty<PersonalEvent>(_entities[0].properties[5]);

  /// see [PersonalEvent.alreadySynced]
  static final alreadySynced =
      QueryBooleanProperty<PersonalEvent>(_entities[0].properties[6]);
}
