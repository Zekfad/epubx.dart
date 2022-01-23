import 'package:quiver/collection.dart' as collections;
import 'package:quiver/core.dart';

import 'epub_metadata_contributor.dart';
import 'epub_metadata_creator.dart';
import 'epub_metadata_date.dart';
import 'epub_metadata_identifier.dart';
import 'epub_metadata_meta.dart';

class EpubMetadata {
  List<String> titles;
  List<EpubMetadataCreator> creators;
  List<String> subjects;
  String? description;
  List<String> publishers;
  List<EpubMetadataContributor> contributors;
  List<EpubMetadataDate> dates;
  List<String> types;
  List<String> formats;
  List<EpubMetadataIdentifier> identifiers;
  List<String> sources;
  List<String> languages;
  List<String> relations;
  List<String> coverages;
  List<String> rights;
  List<EpubMetadataMeta> metaItems;

  EpubMetadata({
    List<String>? titles,
    List<EpubMetadataCreator>? creators,
    List<String>? subjects,
    this.description,
    List<String>? publishers,
    List<EpubMetadataContributor>? contributors,
    List<EpubMetadataDate>? dates,
    List<String>? types,
    List<String>? formats,
    List<EpubMetadataIdentifier>? identifiers,
    List<String>? sources,
    List<String>? languages,
    List<String>? relations,
    List<String>? coverages,
    List<String>? rights,
    List<EpubMetadataMeta>? metaItems,
  }) :
    titles = titles ?? <String>[],
    creators = creators ?? <EpubMetadataCreator>[],
    subjects = subjects ?? <String>[],
    publishers = publishers ?? <String>[],
    contributors = contributors ?? <EpubMetadataContributor>[],
    dates = dates ?? <EpubMetadataDate>[],
    types = types ?? <String>[],
    formats = formats ?? <String>[],
    identifiers = identifiers ?? <EpubMetadataIdentifier>[],
    sources = sources ?? <String>[],
    languages = languages ?? <String>[],
    relations = relations ?? <String>[],
    coverages = coverages ?? <String>[],
    rights = rights ?? <String>[],
    metaItems = metaItems ?? <EpubMetadataMeta>[];

  @override
  int get hashCode {
    final List<int> objects = <int>[
      ...titles.map((String title) => title.hashCode),
      ...creators.map((EpubMetadataCreator creator) => creator.hashCode),
      ...subjects.map((String subject) => subject.hashCode),
      ...publishers.map((String publisher) => publisher.hashCode),
      ...contributors.map((EpubMetadataContributor contributor) => contributor.hashCode),
      ...dates.map((EpubMetadataDate date) => date.hashCode),
      ...types.map((String type) => type.hashCode),
      ...formats.map((String format) => format.hashCode),
      ...identifiers.map((EpubMetadataIdentifier identifier) => identifier.hashCode),
      ...sources.map((String source) => source.hashCode),
      ...languages.map((String language) => language.hashCode),
      ...relations.map((String relation) => relation.hashCode),
      ...coverages.map((String coverage) => coverage.hashCode),
      ...rights.map((String right) => right.hashCode),
      ...metaItems.map((EpubMetadataMeta metaItem) => metaItem.hashCode),
      description.hashCode
    ];

    return hashObjects(objects);
  }

  @override
  bool operator ==(Object other) {
    if (other is! EpubMetadata) {
      return false;
    }
    if (description != other.description) {
      return false;
    }

    if (!collections.listsEqual(titles, other.titles) ||
        !collections.listsEqual(creators, other.creators) ||
        !collections.listsEqual(subjects, other.subjects) ||
        !collections.listsEqual(publishers, other.publishers) ||
        !collections.listsEqual(contributors, other.contributors) ||
        !collections.listsEqual(dates, other.dates) ||
        !collections.listsEqual(types, other.types) ||
        !collections.listsEqual(formats, other.formats) ||
        !collections.listsEqual(identifiers, other.identifiers) ||
        !collections.listsEqual(sources, other.sources) ||
        !collections.listsEqual(languages, other.languages) ||
        !collections.listsEqual(relations, other.relations) ||
        !collections.listsEqual(coverages, other.coverages) ||
        !collections.listsEqual(rights, other.rights) ||
        !collections.listsEqual(metaItems, other.metaItems)) {
      return false;
    }

    return true;
  }
}
