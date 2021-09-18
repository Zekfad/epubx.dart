import '../ref_entities/epub_book_ref.dart';
import '../ref_entities/epub_chapter_ref.dart';
import '../ref_entities/epub_text_content_file_ref.dart';
import '../schema/navigation/epub_navigation_point.dart';

List<EpubChapterRef> getChapters(EpubBookRef bookRef) {
  if (bookRef.schema!.navigation == null) {
    return <EpubChapterRef>[];
  }
  return getChaptersImpl(bookRef, bookRef.schema!.navigation!.navMap!.points!);
}

List<EpubChapterRef> getChaptersImpl(EpubBookRef bookRef, List<EpubNavigationPoint> navigationPoints) {
  final List<EpubChapterRef> result = <EpubChapterRef>[];
  for (final EpubNavigationPoint navigationPoint in navigationPoints) {
    String? contentFileName;
    String? anchor;
    final int contentSourceAnchorCharIndex = navigationPoint.content!.source!.indexOf('#');
    if (contentSourceAnchorCharIndex == -1) {
      contentFileName = navigationPoint.content!.source;
      anchor = null;
    } else {
      contentFileName = navigationPoint.content!.source!.substring(0, contentSourceAnchorCharIndex);
      anchor = navigationPoint.content!.source!.substring(contentSourceAnchorCharIndex + 1);
    }
    contentFileName = Uri.decodeFull(contentFileName!);
    EpubTextContentFileRef? htmlContentFileRef;
    if (!bookRef.content!.html.containsKey(contentFileName)) {
      throw Exception('Incorrect EPUB manifest: item with href = "$contentFileName" is missing.');
    }

    htmlContentFileRef = bookRef.content!.html[contentFileName];
    final EpubChapterRef chapterRef = EpubChapterRef(
      epubTextContentFileRef: htmlContentFileRef,
      contentFileName: contentFileName,
      anchor: anchor,
      title: navigationPoint.navigationLabels.first.text,
      subChapters: getChaptersImpl(bookRef, navigationPoint.childNavigationPoints),
    );

    result.add(chapterRef);
  }
  return result;
}
